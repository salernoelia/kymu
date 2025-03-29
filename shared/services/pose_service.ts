import { Camera } from "@mediapipe/camera_utils";
import { drawConnectors, drawLandmarks } from "@mediapipe/drawing_utils";
import type { Options, Results } from "@mediapipe/pose";
import { Pose, POSE_CONNECTIONS } from "@mediapipe/pose";

export class LogService {
    // delay_log_last_at
    private last_delay_log_at = 0;

    public delay_log(delay: number, ...args: (string | number | object)[]) {
        const now = Math.floor(Date.now() / 1000);
        if (this.last_delay_log_at < now) {
            this.last_delay_log_at = now + delay;
            console.log(now, args);
        }
    }

    public static debug_log(...args: (string | number | object)[]) {
        if (import.meta.env.VITE_NODE_ENV === "development") {
            console.log("[DEBUG]", args);
        }
    }

    public debug_log(...args: (string | number | object)[]) {
        if (import.meta.env.VITE_NODE_ENV === "development") {
            console.log("[DEBUG]", args);
        }
    }

    public static trace_log(...args: (string | number | object)[]) {
        if (import.meta.env.VITE_NODE_ENV === "development") {
            console.trace("[TRACE]", args);
        }
    }

    public trace_log(...args: (string | number | object)[]) {
        if (import.meta.env.VITE_NODE_ENV === "development") {
            console.trace("[TRACE]", args);
        }
    }

    public static error_log(...args: (string | number | object | unknown)[]) {
        console.error("[ERROR]", args);
    }

    public error_log(...args: (string | number | object | unknown)[]) {
        console.error("[ERROR]", args);
    }
}

export class PoseService extends Camera {
    private readonly pipe = new Pose({
        locateFile: (file) =>
            `https://cdn.jsdelivr.net/npm/@mediapipe/pose/${file}`,
    });

    private readonly ctx: CanvasRenderingContext2D;
    private logService = new LogService();

    constructor(
        public readonly canvas: HTMLCanvasElement,
        public readonly source: HTMLVideoElement,
        public readonly canvasWidth: number,
        public readonly canvasHeight: number,
        public readonly landmarkContainer: HTMLDivElement,
        public readonly loadingCanvas: Ref<boolean>,
        public mediapipeResults: Ref<Results | null>,
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
                this.mediapipeResults.value = results;
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
            this.logService.debug_log("this.loadingCanvas.value is change.");
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

        this.ctx.restore();

        // grid.updateLandmarks(poseWorldLandmarks);
    }
}
