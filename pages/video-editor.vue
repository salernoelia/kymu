<template>
  <div class="video-editor">
    <h1>Video Editor</h1>
    <div class="editor-layout">
      <MediaUploader @file-uploaded="handleFileUpload" />

      <div class="preview-container">
        <VideoPreview
          :source="currentVideo"
          :playing="isPlaying"
          :current-time="currentTime"
          @duration-change="updateVideoDuration"
          @time-update="updateCurrentTime"
        />
      </div>

      <div class="controls-container">
        <VideoControls
          :playing="isPlaying"
          :current-time="currentTime"
          :duration="videoDuration"
          @play-pause="togglePlayPause"
          @seek="handleSeek"
        />
      </div>

      <VideoTimeline
        :clips="videoClips"
        :current-time="currentTime"
        @clip-selected="selectClip"
        @clip-moved="moveClip"
        @clip-trimmed="trimClip"
      />

      <div class="actions-container">
        <VideoEffects
          :selected-clip="selectedClip"
          @effect-applied="applyEffect"
        />

        <ExportOptions
          :clips="videoClips"
          @export="exportVideo"
          :is-processing="isProcessing"
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import type { VideoClip } from "~/shared/types/video";

import MediaUploader from "~/components/MediaUploader.vue";
import VideoPreview from "~/components/VideoPreview.vue";
import VideoControls from "~/components/VideoControls.vue";
import VideoTimeline from "~/components/VideoTimeline.vue";
import VideoEffects from "~/components/VideoEffects.vue";
import ExportOptions from "~/components/ExportOptions.vue";

// State
const currentVideo = ref<string>("");
const isPlaying = ref<boolean>(false);
const currentTime = ref<number>(0);
const videoDuration = ref<number>(0);
const videoClips = ref<VideoClip[]>([]);
const selectedClip = ref<VideoClip | null>(null);
const isProcessing = ref<boolean>(false);

// Added methods for video callbacks
const updateVideoDuration = (duration: number) => {
  videoDuration.value = duration;
};

const updateCurrentTime = (time: number) => {
  currentTime.value = time;
};

// Methods
const handleFileUpload = (file: File) => {
  const url = URL.createObjectURL(file);
  currentVideo.value = url;

  // Create a new clip
  const newClip: VideoClip = {
    id: Date.now().toString(),
    source: url,
    startTime: 0,
    endTime: 0, // Will be updated once metadata is loaded
    name: file.name,
    effects: [],
  };

  // Create a video element to get duration
  const video = document.createElement("video");
  video.src = url;
  video.onloadedmetadata = () => {
    videoDuration.value = video.duration;
    newClip.endTime = video.duration;
    videoClips.value.push(newClip);
  };
};

const togglePlayPause = () => {
  isPlaying.value = !isPlaying.value;
};

const handleSeek = (time: number) => {
  currentTime.value = time;
};

const selectClip = (clipId: string) => {
  selectedClip.value =
    videoClips.value.find((clip) => clip.id === clipId) || null;
};

const moveClip = (clipId: string, newPosition: number) => {
  const clips = [...videoClips.value];
  const clipIndex = clips.findIndex((clip) => clip.id === clipId);
  if (clipIndex !== -1) {
    const [clip] = clips.splice(clipIndex, 1);
    clips.splice(newPosition, 0, clip);
    videoClips.value = clips;
  }
};

const trimClip = (clipId: string, startTime: number, endTime: number) => {
  videoClips.value = videoClips.value.map((clip) => {
    if (clip.id === clipId) {
      return { ...clip, startTime, endTime };
    }
    return clip;
  });
};

const applyEffect = (clipId: string, effect: any) => {
  videoClips.value = videoClips.value.map((clip) => {
    if (clip.id === clipId) {
      return {
        ...clip,
        effects: [...clip.effects, effect],
      };
    }
    return clip;
  });
};

const exportVideo = async (format: string, quality: string) => {
  if (videoClips.value.length === 0) return;

  isProcessing.value = true;
  try {
    // Get the actual video files from the URLs
    const videoFiles = await Promise.all(
      videoClips.value.map(async (clip) => {
        const response = await fetch(clip.source);
        const blob = await response.blob();
        return new File([blob], clip.name, { type: blob.type });
      })
    );

    // Import the FFmpeg utility
    const { exportVideo: ffmpegExport } = await import("~/utils/ffmpeg");

    // Process the video
    const exportedBlob = await ffmpegExport(videoFiles, format, quality);

    // Create a download link
    const downloadUrl = URL.createObjectURL(exportedBlob);
    const downloadLink = document.createElement("a");
    downloadLink.href = downloadUrl;
    downloadLink.download = `exported-video.${format}`;
    document.body.appendChild(downloadLink);
    downloadLink.click();
    document.body.removeChild(downloadLink);

    // Clean up the URL
    URL.revokeObjectURL(downloadUrl);
  } catch (error) {
    console.error("Error exporting video:", error);
    alert("There was an error exporting your video. Please try again.");
  } finally {
    isProcessing.value = false;
  }
};
</script>

<style scoped>
.video-editor {
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.editor-layout {
  display: grid;
  grid-template-rows: auto auto auto 1fr auto;
  gap: 20px;
  height: calc(100vh - 100px);
}

.preview-container {
  height: 400px;
}

.controls-container,
.actions-container {
  display: flex;
  gap: 20px;
}
</style>
