<template>
  <div class="video-timeline">
    <div class="time-markers">
      <div
        v-for="marker in timeMarkers"
        :key="marker.time"
        class="time-marker"
        :style="{ left: `${marker.position}%` }"
      >
        {{ marker.label }}
      </div>
    </div>

    <div class="clips-container">
      <div
        v-for="clip in clips"
        :key="clip.id"
        class="timeline-clip"
        :class="{ selected: selectedClipId === clip.id }"
        :style="{
          left: `${(clip.startTime / totalDuration) * 100}%`,
          width: `${((clip.endTime - clip.startTime) / totalDuration) * 100}%`,
        }"
        @click="selectClip(clip.id)"
      >
        <div class="clip-info">{{ clip.name }}</div>
        <div
          class="clip-handle left"
          @mousedown="startTrimming(clip.id, 'start', $event)"
        ></div>
        <div
          class="clip-handle right"
          @mousedown="startTrimming(clip.id, 'end', $event)"
        ></div>
      </div>

      <div
        class="playhead"
        :style="{ left: `${(currentTime / totalDuration) * 100}%` }"
      ></div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  clips: VideoClip[];
  currentTime: number;
}>();

const emit = defineEmits<{
  "clip-selected": [clipId: string];
  "clip-moved": [clipId: string, newPosition: number];
  "clip-trimmed": [clipId: string, startTime: number, endTime: number];
}>();

const selectedClipId = ref<string | null>(null);
const isDragging = ref(false);
const isTrimming = ref(false);
const trimmingEdge = ref<"start" | "end" | null>(null);
const trimmingClipId = ref<string | null>(null);
const initialMouseX = ref(0);
const initialClipStart = ref(0);
const initialClipEnd = ref(0);

const totalDuration = computed(() => {
  if (props.clips.length === 0) return 60; // Default timeline length

  return Math.max(...props.clips.map((clip) => clip.endTime));
});

const timeMarkers = computed(() => {
  const markers = [];
  const step = Math.ceil(totalDuration.value / 10); // Create ~10 markers

  for (let i = 0; i <= totalDuration.value; i += step) {
    markers.push({
      time: i,
      position: (i / totalDuration.value) * 100,
      label: formatTime(i),
    });
  }

  return markers;
});

const selectClip = (clipId: string) => {
  selectedClipId.value = clipId;
  emit("clip-selected", clipId);
};

const startTrimming = (
  clipId: string,
  edge: "start" | "end",
  event: MouseEvent
) => {
  event.stopPropagation();
  event.preventDefault();

  const clip = props.clips.find((c) => c.id === clipId);
  if (!clip) return;

  isTrimming.value = true;
  trimmingEdge.value = edge;
  trimmingClipId.value = clipId;
  initialMouseX.value = event.clientX;
  initialClipStart.value = clip.startTime;
  initialClipEnd.value = clip.endTime;

  document.addEventListener("mousemove", handleMouseMove);
  document.addEventListener("mouseup", handleMouseUp);
};

const handleMouseMove = (event: MouseEvent) => {
  if (!isTrimming.value || !trimmingClipId.value || !trimmingEdge.value) return;

  const clip = props.clips.find((c) => c.id === trimmingClipId.value);
  if (!clip) return;

  const container = document.querySelector(".clips-container");
  if (!container) return;

  const containerRect = container.getBoundingClientRect();
  const containerWidth = containerRect.width;

  const deltaX = event.clientX - initialMouseX.value;
  const deltaTime = (deltaX / containerWidth) * totalDuration.value;

  let newStartTime = clip.startTime;
  let newEndTime = clip.endTime;

  if (trimmingEdge.value === "start") {
    newStartTime = Math.max(0, initialClipStart.value + deltaTime);
    newStartTime = Math.min(newStartTime, clip.endTime - 0.5); // Minimum clip duration: 0.5s
  } else {
    newEndTime = Math.min(
      totalDuration.value,
      initialClipEnd.value + deltaTime
    );
    newEndTime = Math.max(newEndTime, clip.startTime + 0.5); // Minimum clip duration: 0.5s
  }

  emit("clip-trimmed", clip.id, newStartTime, newEndTime);
};

const handleMouseUp = () => {
  isTrimming.value = false;
  trimmingEdge.value = null;
  trimmingClipId.value = null;

  document.removeEventListener("mousemove", handleMouseMove);
  document.removeEventListener("mouseup", handleMouseUp);
};

const formatTime = (timeInSeconds: number): string => {
  const minutes = Math.floor(timeInSeconds / 60);
  const seconds = Math.floor(timeInSeconds % 60);
  return `${minutes}:${seconds.toString().padStart(2, "0")}`;
};
</script>

<style scoped>
.video-timeline {
  position: relative;
  width: 100%;
  height: 100px;
  background-color: #f0f0f0;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.time-markers {
  position: relative;
  height: 20px;
  border-bottom: 1px solid #ccc;
}

.time-marker {
  position: absolute;
  transform: translateX(-50%);
  font-size: 12px;
}

.clips-container {
  position: relative;
  flex-grow: 1;
}

.timeline-clip {
  position: absolute;
  height: 60px;
  top: 10px;
  background-color: #4a8af4;
  border-radius: 4px;
  cursor: move;
}

.timeline-clip.selected {
  border: 2px solid #ffa500;
}

.clip-info {
  font-size: 12px;
  padding: 4px;
  color: white;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.clip-handle {
  position: absolute;
  width: 8px;
  height: 100%;
  top: 0;
  cursor: col-resize;
}

.clip-handle.left {
  left: 0;
}

.clip-handle.right {
  right: 0;
}

.playhead {
  position: absolute;
  top: 0;
  height: 100%;
  width: 2px;
  background-color: red;
  transform: translateX(-50%);
}
</style>
