import { Camera } from "@mediapipe/camera_utils";
import {
    drawConnectors,
    drawLandmarks,
    type NormalizedLandmarkList,
} from "@mediapipe/drawing_utils";
import type { Options, Results } from "@mediapipe/pose";
import { Pose, POSE_CONNECTIONS } from "@mediapipe/pose";

export class PoseService extends Camera {
    private readonly pipe = new Pose({
        locateFile: (file) =>
            `https://cdn.jsdelivr.net/npm/@mediapipe/pose/${file}`,
    });

    private readonly ctx: CanvasRenderingContext2D;
    // public savedLandmarks: Ref<NormalizedLandmarkList | null> = ref(null);

    constructor(
        public readonly canvas: HTMLCanvasElement,
        public readonly source: HTMLVideoElement,
        public readonly canvasWidth: number,
        public readonly canvasHeight: number,
        public readonly landmarkContainer: HTMLDivElement,
        public readonly loadingCanvas: Ref<boolean>,
        public mediapipeResults: Ref<Results | null>,
        public savedLandmarks: Ref<NormalizedLandmarkList | null>,
    ) {
        super(source, {
            onFrame: async () => await this.pipe.send({ image: source }),
            width: canvasWidth,
            height: canvasHeight,
        });

        source.addEventListener("loadedmetadata", () => {
            this.canvas.height = source.videoHeight;
            this.canvas.width = source.videoWidth;
        });

        this.ctx = canvas.getContext("2d") as CanvasRenderingContext2D;
    }

    /**
     * @param options {@link https://google.github.io/mediapipe/solutions/pose.html#javascript-solution-api|Mediapipe}
     */
    public setOptions(options: Options): Promise<void> {
        this.pipe.onResults((results) => {
            this.render(results);
            if (isRef(this.mediapipeResults)) {
                // Make sure poseWorldLandmarks is included in the results
                this.mediapipeResults.value = {
                    ...results,
                    poseWorldLandmarks: results.poseWorldLandmarks,
                };
            } else {
                console.error("mediapipeResults is not a Vue ref!");
            }
        });
        this.pipe.setOptions(options);
        return this.start();
    }

    public render({
        poseLandmarks,
        // segmentationMask,
        // poseWorldLandmarks,
        image,
    }: Results): void {
        // const grid = new LandmarkGrid(this.landmarkContainer);

        // if (!poseLandmarks) {
        //   grid.updateLandmarks([]);
        //   return;
        // }
        if (this.loadingCanvas.value) {
            this.loadingCanvas.value = false;
        }

        const { width, height } = this.canvas;
        // this.logService.delay_log(10, "width: %d, height: %d", width, height);
        // this.logService.delay_log(10, "poseLandmarks", poseLandmarks);

        this.ctx.save();
        this.ctx.clearRect(0, 0, width, height);

        // Only overwrite existing pixels.
        this.ctx.globalCompositeOperation = "source-in";
        this.ctx.fillStyle = "#00FF00";
        this.ctx.fillRect(0, 0, width, height);

        // Only overwrite missing pixels.
        this.ctx.globalCompositeOperation = "destination-atop";
        this.ctx.drawImage(image, 0, 0, width, height);

        this.ctx.globalCompositeOperation = "source-over";
        drawConnectors(this.ctx, poseLandmarks, POSE_CONNECTIONS, {
            color: "#00FF00",
            lineWidth: 4,
        });
        drawLandmarks(this.ctx, poseLandmarks, {
            color: "#FF0000",
            lineWidth: 2,
        });

        //  if saved landmarks is not null, draw them also
        if (this.savedLandmarks.value) {
            drawLandmarks(this.ctx, this.savedLandmarks.value, {
                color: "#0000FF",
                lineWidth: 2,
            });
            drawConnectors(
                this.ctx,
                this.savedLandmarks.value,
                POSE_CONNECTIONS,
                {
                    color: "#0000FF",
                    lineWidth: 4,
                },
            );

            // Draw angle arc and text for specific joints
            // For example, for right elbow (assuming indices 12=shoulder, 14=elbow, 16=wrist)
            this.drawJointAngle(
                14,
                16,
                poseLandmarks,
                this.savedLandmarks.value,
            );
        }

        this.ctx.restore();

        // grid.updateLandmarks(poseWorldLandmarks);
    }

    /**
     * Draw angle arc and text between saved and current landmark positions
     * @param pivotIndex Index of the pivot point (e.g. elbow)
     * @param pointIndex Index of the point that moves (e.g. wrist)
     * @param currentLandmarks Current pose landmarks
     * @param savedLandmarks Previously saved landmarks
     */
    private drawJointAngle(
        pivotIndex: number,
        pointIndex: number,
        currentLandmarks: NormalizedLandmarkList,
        savedLandmarks: NormalizedLandmarkList,
    ): void {
        // Ensure landmarks exist at these indices
        if (
            !currentLandmarks[pivotIndex] || !currentLandmarks[pointIndex] ||
            !savedLandmarks[pivotIndex] || !savedLandmarks[pointIndex]
        ) {
            return;
        }

        // Get pivot point (e.g. elbow)
        const pivot = currentLandmarks[pivotIndex];

        // Get the saved position (point A)
        const pointA = savedLandmarks[pointIndex];

        // Get current position (point B)
        const pointB = currentLandmarks[pointIndex];

        // Check visibility thresholds
        const minVisibility = 0.5;
        if (
            (pivot.visibility || 0) < minVisibility ||
            (pointA.visibility || 0) < minVisibility ||
            (pointB.visibility || 0) < minVisibility
        ) {
            return;
        }

        // Calculate vectors from pivot to points
        const vectorA = {
            x: pointA.x - pivot.x,
            y: pointA.y - pivot.y,
        };

        const vectorB = {
            x: pointB.x - pivot.x,
            y: pointB.y - pivot.y,
        };

        // Calculate angle between vectors
        const dotProduct = vectorA.x * vectorB.x + vectorA.y * vectorB.y;
        const magA = Math.sqrt(vectorA.x * vectorA.x + vectorA.y * vectorA.y);
        const magB = Math.sqrt(vectorB.x * vectorB.x + vectorB.y * vectorB.y);

        if (magA === 0 || magB === 0) return;

        const cosTheta = Math.min(Math.max(dotProduct / (magA * magB), -1), 1);
        const angle = Math.acos(cosTheta);
        const angleDeg = Math.round(angle * (180 / Math.PI));

        // Draw the arc
        const radius = Math.min(magA, magB) * 0.3;

        // Get screen coordinates
        const { width, height } = this.canvas;
        const pivotX = pivot.x * width;
        const pivotY = pivot.y * height;

        // Calculate starting and ending angles for the arc
        let startAngle = Math.atan2(vectorA.y, vectorA.x);
        let endAngle = Math.atan2(vectorB.y, vectorB.x);

        // Ensure we draw the smallest angle between vectors
        if (Math.abs(endAngle - startAngle) > Math.PI) {
            if (endAngle > startAngle) {
                startAngle += 2 * Math.PI;
            } else {
                endAngle += 2 * Math.PI;
            }
        }

        // Draw arc
        this.ctx.beginPath();
        this.ctx.arc(pivotX, pivotY, radius * width, startAngle, endAngle);
        this.ctx.strokeStyle = "#FFFF00";
        this.ctx.lineWidth = 2;
        this.ctx.stroke();

        // Draw angle text
        this.ctx.font = "bold 16px Arial";
        this.ctx.fillStyle = "#FFFF00";
        this.ctx.textAlign = "center";

        // Position the text slightly outside the arc
        const textAngle = (startAngle + endAngle) / 2;
        const textRadius = radius * 1.3;
        const textX = pivotX + textRadius * width * Math.cos(textAngle);
        const textY = pivotY + textRadius * width * Math.sin(textAngle);

        this.ctx.fillText(`${angleDeg}°`, textX, textY);
    }

    /**
     * saveNormalizedLandmarks
     */
}
