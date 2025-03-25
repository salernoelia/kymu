<template>
  <div class="export-options">
    <h3>Export Video</h3>

    <div class="export-format">
      <label>Format</label>
      <select v-model="exportFormat">
        <option value="mp4">MP4</option>
        <option value="webm">WebM</option>
        <option value="gif">GIF</option>
      </select>
    </div>

    <div class="export-quality">
      <label>Quality</label>
      <select v-model="exportQuality">
        <option value="high">High</option>
        <option value="medium">Medium</option>
        <option value="low">Low</option>
      </select>
    </div>

    <button
      @click="startExport"
      :disabled="isProcessing || clips.length === 0"
      class="export-button"
    >
      {{ isProcessing ? "Processing..." : "Export Video" }}
    </button>

    <div
      v-if="isProcessing"
      class="export-progress"
    >
      <div>Processing: {{ Math.round(progress) }}%</div>
      <div class="progress-bar">
        <div
          class="progress"
          :style="{ width: `${progress}%` }"
        ></div>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  clips: {
    type: Array,
    default: () => [],
  },
  isProcessing: {
    type: Boolean,
    default: false,
  },
  progress: {
    type: Number,
    default: 0,
  },
});

const emit = defineEmits(["export"]);

const exportFormat = ref("mp4");
const exportQuality = ref("high");

const startExport = () => {
  if (props.clips.length === 0) return;
  emit("export", exportFormat.value, exportQuality.value);
};
</script>

<style scoped>
.export-options {
  width: 100%;
  padding: 10px;
  background-color: #f5f5f5;
}

.export-format,
.export-quality {
  margin: 10px 0;
  display: flex;
  align-items: center;
}

.export-format label,
.export-quality label {
  width: 80px;
}

.export-button {
  margin-top: 10px;
  padding: 8px 16px;
  background-color: #4a8af4;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.export-button:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.export-progress {
  margin-top: 15px;
}

.progress-bar {
  height: 10px;
  background-color: #ddd;
  border-radius: 5px;
  margin-top: 5px;
  overflow: hidden;
}

.progress {
  height: 100%;
  background-color: #4a8af4;
  transition: width 0.3s ease;
}
</style>
