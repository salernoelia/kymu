<template>
  <div class="video-controls">
    <button
      @click="$emit('play-pause')"
      class="play-pause-btn"
    >
      {{ playing ? "Pause" : "Play" }}
    </button>

    <div class="timeline-container">
      <input
        type="range"
        min="0"
        :max="duration || 100"
        :value="currentTime || 0"
        @input="handleSeek"
        step="0.01"
        class="timeline-slider"
      />
      <div class="time-display">
        {{ formatTime(currentTime || 0) }} / {{ formatTime(duration || 0) }}
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  playing: {
    type: Boolean,
    default: false,
  },
  currentTime: {
    type: Number,
    default: 0,
  },
  duration: {
    type: Number,
    default: 0,
  },
});

const emit = defineEmits(["play-pause", "seek"]);

const handleSeek = (event) => {
  const target = event.target;
  const value = parseFloat(target.value);
  if (!isNaN(value)) {
    emit("seek", value);
  }
};

const formatTime = (timeInSeconds) => {
  if (isNaN(timeInSeconds) || timeInSeconds === null) return "00:00";

  const minutes = Math.floor(timeInSeconds / 60);
  const seconds = Math.floor(timeInSeconds % 60);
  return `${minutes.toString().padStart(2, "0")}:${seconds
    .toString()
    .padStart(2, "0")}`;
};
</script>

<style scoped>
.video-controls {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
}

.play-pause-btn {
  padding: 8px 16px;
}

.timeline-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.timeline-slider {
  width: 100%;
}

.time-display {
  font-size: 14px;
}
</style>
