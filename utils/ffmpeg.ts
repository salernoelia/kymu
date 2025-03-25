import { FFmpeg } from "@ffmpeg/ffmpeg";
import { fetchFile, toBlobURL } from "@ffmpeg/util";

// Base URL for FFmpeg core files
const baseURL = "https://cdn.jsdelivr.net/npm/@ffmpeg/core-mt@0.12.9/dist/esm";

// Singleton FFmpeg instance
let ffmpegInstance: FFmpeg | null = null;

/**
 * Gets or initializes the FFmpeg instance
 */
export const getFFmpeg = async (): Promise<FFmpeg> => {
    if (!ffmpegInstance) {
        const ffmpeg = new FFmpeg();

        try {
            ffmpeg.on("log", ({ message }) => {
                console.log(`[FFmpeg]: ${message}`);
            });

            // Load FFmpeg
            await ffmpeg.load({
                coreURL: await toBlobURL(
                    `${baseURL}/ffmpeg-core.js`,
                    "text/javascript",
                ),
                wasmURL: await toBlobURL(
                    `${baseURL}/ffmpeg-core.wasm`,
                    "application/wasm",
                ),
                workerURL: await toBlobURL(
                    `${baseURL}/ffmpeg-core.worker.js`,
                    "text/javascript",
                ),
            });

            ffmpegInstance = ffmpeg;
        } catch (error) {
            console.error("Failed to load FFmpeg:", error);
            throw new Error("Failed to load FFmpeg");
        }
    }

    return ffmpegInstance;
};

/**
 * Apply brightness and contrast adjustments to a video
 */
export const applyBrightnessContrast = async (
    videoFile: File | Blob,
    brightness: number,
    contrast: number,
    progressCallback?: (progress: number) => void,
): Promise<Blob> => {
    const ffmpeg = await getFFmpeg();
    const inputFileName = "input.mp4";
    const outputFileName = "output.mp4";

    // Set up progress monitoring
    if (progressCallback) {
        ffmpeg.on("progress", ({ progress }) => {
            progressCallback(Math.round(progress * 100));
        });
    }

    // Write input file
    await ffmpeg.writeFile(inputFileName, await fetchFile(videoFile));

    // Run FFmpeg command
    await ffmpeg.exec([
        "-i",
        inputFileName,
        "-vf",
        `eq=brightness=${brightness / 100}:contrast=${contrast / 100}`,
        "-c:a",
        "copy",
        outputFileName,
    ]);

    // Read output file
    const data = await ffmpeg.readFile(outputFileName);
    return new Blob([data], { type: "video/mp4" });
};

/**
 * Trim a video to specified start and end times
 */
export const trimVideo = async (
    videoFile: File | Blob,
    startTime: number,
    endTime: number,
    progressCallback?: (progress: number) => void,
): Promise<Blob> => {
    const ffmpeg = await getFFmpeg();
    const inputFileName = "input.mp4";
    const outputFileName = "output.mp4";

    if (progressCallback) {
        ffmpeg.on("progress", ({ progress }) => {
            progressCallback(Math.round(progress * 100));
        });
    }

    await ffmpeg.writeFile(inputFileName, await fetchFile(videoFile));

    await ffmpeg.exec([
        "-i",
        inputFileName,
        "-ss",
        startTime.toString(),
        "-to",
        endTime.toString(),
        "-c",
        "copy",
        outputFileName,
    ]);

    const data = await ffmpeg.readFile(outputFileName);
    return new Blob([data], { type: "video/mp4" });
};

/**
 * Rotate a video by specified degrees
 */
export const rotateVideo = async (
    videoFile: File | Blob,
    degrees: number,
    progressCallback?: (progress: number) => void,
): Promise<Blob> => {
    const ffmpeg = await getFFmpeg();
    const inputFileName = "input.mp4";
    const outputFileName = "output.mp4";

    if (progressCallback) {
        ffmpeg.on("progress", ({ progress }) => {
            progressCallback(Math.round(progress * 100));
        });
    }

    await ffmpeg.writeFile(inputFileName, await fetchFile(videoFile));

    // Determine transpose value based on rotation degrees
    const transposeValue = degrees === 90
        ? "1"
        : degrees === 180
        ? "2"
        : degrees === 270
        ? "3"
        : "0";

    await ffmpeg.exec([
        "-i",
        inputFileName,
        "-vf",
        `transpose=${transposeValue}`,
        "-c:a",
        "copy",
        outputFileName,
    ]);

    const data = await ffmpeg.readFile(outputFileName);
    return new Blob([data], { type: "video/mp4" });
};

/**
 * Change video playback speed
 */
export const changeVideoSpeed = async (
    videoFile: File | Blob,
    speed: number,
    progressCallback?: (progress: number) => void,
): Promise<Blob> => {
    const ffmpeg = await getFFmpeg();
    const inputFileName = "input.mp4";
    const outputFileName = "output.mp4";

    if (progressCallback) {
        ffmpeg.on("progress", ({ progress }) => {
            progressCallback(Math.round(progress * 100));
        });
    }

    await ffmpeg.writeFile(inputFileName, await fetchFile(videoFile));

    await ffmpeg.exec([
        "-i",
        inputFileName,
        "-filter_complex",
        `[0:v]setpts=${1 / speed}*PTS[v];[0:a]atempo=${speed}[a]`,
        "-map",
        "[v]",
        "-map",
        "[a]",
        outputFileName,
    ]);

    const data = await ffmpeg.readFile(outputFileName);
    return new Blob([data], { type: "video/mp4" });
};

/**
 * Merge multiple videos into one
 */
export const mergeVideos = async (
    videoFiles: Array<File | Blob>,
    progressCallback?: (progress: number) => void,
): Promise<Blob> => {
    const ffmpeg = await getFFmpeg();

    if (progressCallback) {
        ffmpeg.on("progress", ({ progress }) => {
            progressCallback(Math.round(progress * 100));
        });
    }

    // Create file list for concat
    let fileList = "";
    for (let i = 0; i < videoFiles.length; i++) {
        const fileName = `input${i}.mp4`;
        fileList += `file ${fileName}\n`;

        // Write each input file
        await ffmpeg.writeFile(fileName, await fetchFile(videoFiles[i]));
    }

    // Write the list file
    await ffmpeg.writeFile("list.txt", new TextEncoder().encode(fileList));

    // Execute concat command
    await ffmpeg.exec([
        "-f",
        "concat",
        "-safe",
        "0",
        "-i",
        "list.txt",
        "-c",
        "copy",
        "output.mp4",
    ]);

    const data = await ffmpeg.readFile("output.mp4");
    return new Blob([data], { type: "video/mp4" });
};

/**
 * Export video with specified format and quality
 */
export const exportVideo = async (
    videoFiles: Array<File | Blob>,
    format: string,
    quality: string,
    progressCallback?: (progress: number) => void,
): Promise<Blob> => {
    try {
        const ffmpeg = await getFFmpeg();

        if (progressCallback) {
            ffmpeg.on("progress", ({ progress }) => {
                progressCallback(Math.round(progress * 100));
            });
        }

        // First merge videos if there are multiple
        let inputFile: Blob;
        if (videoFiles.length > 1) {
            inputFile = await mergeVideos(videoFiles);
        } else {
            inputFile = videoFiles[0];
        }

        await ffmpeg.writeFile("input.mp4", await fetchFile(inputFile));

        // Quality settings
        let crf = "23"; // Medium quality default
        if (quality === "high") crf = "18";
        if (quality === "low") crf = "28";

        const outputFileName = `output.${format}`;

        if (format === "gif") {
            await ffmpeg.exec([
                "-i",
                "input.mp4",
                "-vf",
                "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse",
                outputFileName,
            ]);
        } else if (format === "webm") {
            await ffmpeg.exec([
                "-i",
                "input.mp4",
                "-c:v",
                "libvpx-vp9",
                "-crf",
                crf,
                "-b:v",
                "0",
                "-deadline",
                "good",
                "-c:a",
                "libopus",
                outputFileName,
            ]);
        } else {
            // MP4 format
            await ffmpeg.exec([
                "-i",
                "input.mp4",
                "-c:v",
                "libx264",
                "-preset",
                "medium",
                "-crf",
                crf,
                "-c:a",
                "aac",
                outputFileName,
            ]);
        }

        const data = await ffmpeg.readFile(outputFileName);
        const mimeType = format === "gif"
            ? "image/gif"
            : format === "webm"
            ? "video/webm"
            : "video/mp4";

        return new Blob([data], { type: mimeType });
    } catch (error) {
        console.error("Error in exportVideo:", error);
        throw error;
    }
};
