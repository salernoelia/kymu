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
        public pivotIndex: Ref<number>,
        public pointIndex: Ref<number>,
        public readonly angle: Ref<number>,
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

        if (!poseLandmarks) {
            return;
        }
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
                this.pivotIndex.value,
                this.pointIndex.value,
                poseLandmarks,
                this.savedLandmarks.value,
            );
        }

        this.ctx.restore();

        // grid.updateLandmarks(poseWorldLandmarks);
    }

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

        const minVisibility = 0.7;
        if (
            (pivot.visibility || 0) < minVisibility ||
            (pointA.visibility || 0) < minVisibility ||
            (pointB.visibility || 0) < minVisibility
        ) {
            return;
        }

        const { angle, angleRad, startAngle, endAngle, vectorA, vectorB } = this
            .calculateJointAngle(
                pivot,
                pointA,
                pointB,
            );

        const { width, height } = this.canvas;
        const pivotX = pivot.x * width;
        const pivotY = pivot.y * height;

        const radius = Math.min(
            Math.sqrt(vectorA.x * vectorA.x + vectorA.y * vectorA.y),
            Math.sqrt(vectorB.x * vectorB.x + vectorB.y * vectorB.y),
        ) * 0.3;

        this.ctx.beginPath();
        this.ctx.arc(pivotX, pivotY, radius * width, startAngle, endAngle);
        this.ctx.strokeStyle = "#FFFF00";
        this.ctx.lineWidth = 2;
        this.ctx.stroke();

        this.ctx.font = "bold 16px Arial";
        this.ctx.fillStyle = "#FFFF00";
        this.ctx.textAlign = "center";

        const textAngle = (startAngle + endAngle) / 2;
        const textRadius = radius * 1.3;
        const textX = pivotX + textRadius * width * Math.cos(textAngle);
        const textY = pivotY + textRadius * width * Math.sin(textAngle);

        this.ctx.fillText(`${angle}°`, textX, textY);

        this.angle.value = angle;
    }

    /**
     * Calculate the angle between two vectors from a pivot point
     * @param pivot The pivot point (joint)
     * @param pointA First reference point (e.g. from saved landmarks)
     * @param pointB Second reference point (e.g. from current landmarks)
     * @returns The angle in degrees and radians, plus vectors and arc angles
     */
    private calculateJointAngle(
        pivot: { x: number; y: number },
        pointA: { x: number; y: number },
        pointB: { x: number; y: number },
    ): {
        angle: number;
        angleRad: number;
        startAngle: number;
        endAngle: number;
        vectorA: { x: number; y: number };
        vectorB: { x: number; y: number };
    } {
        const vectorA = {
            x: pointA.x - pivot.x,
            y: pointA.y - pivot.y,
        };

        const vectorB = {
            x: pointB.x - pivot.x,
            y: pointB.y - pivot.y,
        };

        const dotProduct = vectorA.x * vectorB.x + vectorA.y * vectorB.y;
        const magA = Math.sqrt(vectorA.x * vectorA.x + vectorA.y * vectorA.y);
        const magB = Math.sqrt(vectorB.x * vectorB.x + vectorB.y * vectorB.y);

        const cosTheta = Math.min(Math.max(dotProduct / (magA * magB), -1), 1);
        const angleRad = Math.acos(cosTheta);
        const angle = Math.round(angleRad * (180 / Math.PI));

        let startAngle = Math.atan2(vectorA.y, vectorA.x);
        let endAngle = Math.atan2(vectorB.y, vectorB.x);

        if (Math.abs(endAngle - startAngle) > Math.PI) {
            if (endAngle > startAngle) {
                startAngle += 2 * Math.PI;
            } else {
                endAngle += 2 * Math.PI;
            }
        }

        return {
            angle,
            angleRad,
            startAngle,
            endAngle,
            vectorA,
            vectorB,
        };
    }
}
