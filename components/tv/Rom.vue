<template>
  <div class="w-full">
    <div class="flex flex-row w-full">
      <div class="flex flex-col w-full items-center">
        <!-- Display the angle information -->
        <div class="angle-display mb-4">
          <h1>Current Angle: {{ calculatedAngle.toFixed(2) }}</h1>
          <!-- <p>Result Angle: {{ savedAngle.toFixed(2) }}</p> -->
        </div>

        <video
          class="input_video"
          ref="source"
          v-show="false"
        ></video>
        <canvas
          class="output_canvas"
          :class="{ loading_canvas: loadingCanvas }"
          :width="canvasWidth"
          :height="canvasHeight"
          style="width: 90%"
          ref="canvas"
        ></canvas>
        <div
          class="landmark-grid-container"
          ref="landmarkContainer"
        ></div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { PoseService } from "~/shared/services/pose_service";
import ROMCombinations from "~/shared/constants/ROMCombinations";
import type { Results } from "@mediapipe/pose";
import type { NormalizedLandmarkList } from "@mediapipe/drawing_utils";

const props = defineProps<{
  romCombination: string;
}>();

const source = ref<HTMLVideoElement | null>(null);
const canvas = ref<HTMLCanvasElement | null>(null);
const landmarkContainer = ref<HTMLDivElement | null>(null);
const loadingCanvas = ref(true);
const mediapipeResults = ref<Results | null>(null);
const savedNormalizedLandmarks = ref<NormalizedLandmarkList | null>(null);

const calculatedAngle = ref(0);
const savedAngle = ref(0);

const pivotIndex = ref(14);
const pointAIndex = ref(16);

// Expose methods to parent component
defineExpose({
  saveLandmarks,
  calculateAngle,
  cleanup,
});

// Update ROM combination when prop changes
watch(
  () => props.romCombination,
  (newCombination) => {
    if (
      newCombination &&
      ROMCombinations[newCombination as keyof typeof ROMCombinations]
    ) {
      updateROMCombination(newCombination as keyof typeof ROMCombinations);
    }
  },
  { immediate: true }
);

function updateROMCombination(combination: keyof typeof ROMCombinations) {
  const { pivot, movable } = ROMCombinations[combination];
  pivotIndex.value = pivot;
  pointAIndex.value = movable;
}

// Methods accessible from parent
function saveLandmarks() {
  savedNormalizedLandmarks.value =
    mediapipeResults.value?.poseLandmarks ?? null;
  console.log("Landmarks saved");
}

function calculateAngle() {
  console.log("calculateVectorAngle");
  savedAngle.value = calculatedAngle.value;
}

function cleanup() {
  calculatedAngle.value = 0;
  savedAngle.value = 0;
  savedNormalizedLandmarks.value = null;
  console.log("cleanup done");
}

onMounted(async () => {
  if (canvas.value && source.value && landmarkContainer.value) {
    await new PoseService(
      canvas.value,
      source.value,
      canvasWidth.value,
      canvasHeight.value,
      landmarkContainer.value,
      loadingCanvas,
      mediapipeResults,
      savedNormalizedLandmarks,
      pivotIndex,
      pointAIndex,
      calculatedAngle
    ).setOptions({
      modelComplexity: 1,
      smoothLandmarks: true,
      enableSegmentation: true,
      smoothSegmentation: true,
      minDetectionConfidence: 0.3,
      minTrackingConfidence: 0.3,
    });
  }
});

const canvasWidth = computed(() => window.innerWidth);
const canvasHeight = computed(() => canvasWidth.value * (9 / 16));
</script>

<style scoped>
.pose {
  align-items: center;
  text-align: center;
  margin: 1.5rem 1.5rem;
}
.pose h1 {
  margin: 1.5rem 1.5rem;
}
.loading_canvas {
  background: url("https://media.giphy.com/media/8agqybiK5LW8qrG3vJ/giphy.gif")
    center no-repeat;
}
.angle-display {
  background-color: rgba(255, 255, 255, 0.7);
  padding: 10px;
  border-radius: 5px;
  font-size: 1.2rem;
  font-weight: bold;
  text-align: center;
}
@media (min-width: 1024px) {
  .pose {
    margin: 3rem 3rem;
  }
  .input_video,
  .output_canvas {
    margin: 1.5rem 1.5rem;
  }
}
</style>
