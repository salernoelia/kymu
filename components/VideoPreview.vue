<template>
  <div class="video-preview">
    <video
      ref="videoRef"
      :src="source"
      @timeupdate="onTimeUpdate"
      @loadedmetadata="onMetadataLoaded"
      controls
      playsinline
    ></video>
  </div>
</template>

<script setup>
const props = defineProps({
  source: {
    type: String,
    default: "",
  },
  playing: {
    type: Boolean,
    default: false,
  },
  currentTime: {
    type: Number,
    default: 0,
  },
});

const emit = defineEmits(["duration-change", "time-update"]);

const videoRef = ref(null);

watch(
  () => props.playing,
  async (playing) => {
    if (!videoRef.value || !props.source) return;

    if (playing) {
      try {
        await videoRef.value.play();
      } catch (error) {
        console.error("Error playing video:", error);
      }
    } else {
      videoRef.value.pause();
    }
  }
);

watch(
  () => props.currentTime,
  (newTime) => {
    if (
      !videoRef.value ||
      isNaN(newTime) ||
      newTime === null ||
      videoRef.value.currentTime === newTime
    )
      return;

    videoRef.value.currentTime = newTime;
  }
);

// When source changes, ensure we notify about the new duration when metadata loads
watch(
  () => props.source,
  () => {
    if (videoRef.value && props.source) {
      videoRef.value.load();
    }
  }
);

const onTimeUpdate = () => {
  if (!videoRef.value) return;
  emit("time-update", videoRef.value.currentTime);
};

const onMetadataLoaded = () => {
  if (!videoRef.value) return;
  emit("duration-change", videoRef.value.duration);
};
</script>

<style scoped>
.video-preview {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: black;
}

video {
  max-width: 100%;
  max-height: 100%;
  width: 100%;
  height: auto;
}
</style>
