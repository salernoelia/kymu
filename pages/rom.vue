<template>
  <div class="pose">
    <p>Current Angle: {{ calculatedAngle }}</p>
    <p>Result Angle: {{ savedAngle }}</p>

    <PrimitivesButton
      @click="
        () => {
          savedNormalizedLandmarks = mediapipeResults?.poseLandmarks ?? null;
        }
      "
    >
      Start
    </PrimitivesButton>

    <p>ROM Combinations</p>
    <select
      name="select-rom-combination"
      @change="
        setROMCombination(
          ($event.target as HTMLSelectElement)
            ?.value as keyof typeof ROMCombinations
        )
      "
    >
      <option
        v-for="(value, key) in ROMCombinations"
        :key="key"
        :value="key"
      >
        {{ $t(key) }}
      </option>
    </select>

    <div class="flex flex-row w-full">
      <div class="flex flex-col w-full items-center">
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
import type { Results } from "@mediapipe/pose";

import { type NormalizedLandmarkList } from "@mediapipe/drawing_utils";

const source = ref<InstanceType<typeof HTMLVideoElement> | null>(null);
const canvas = ref<InstanceType<typeof HTMLCanvasElement> | null>(null);
const landmarkContainer = ref<InstanceType<typeof HTMLDivElement> | null>(null);
const loadingCanvas = ref(true);
const mediapipeResults = ref<Results | null>(null);
const savedNormalizedLandmarks = ref<NormalizedLandmarkList | null>(null);

const ROMCombinations = {
  // neck_flexion: { pivot: 11, movable: 0 },
  shoulder_abduction_right: { pivot: 11, movable: 13 },
  shoulder_abduction_left: { pivot: 12, movable: 14 },
  elbow_flexion_right: { pivot: 13, movable: 15 },
  elbow_flexion_left: { pivot: 14, movable: 16 },
  wrist_flexion_right: { pivot: 15, movable: 17 },
  wrist_flexion_left: { pivot: 16, movable: 18 },
  hip_flexion_right: { pivot: 23, movable: 25 },
  hip_flexion_left: { pivot: 24, movable: 26 },
  knee_flexion_right: { pivot: 25, movable: 27 },
  knee_flexion_left: { pivot: 26, movable: 28 },
  ankle_flexion_right: { pivot: 27, movable: 31 },
  ankle_flexion_left: { pivot: 28, movable: 32 },
};

const calculatedAngle = ref(0);
const savedAngle = ref(0);

const pivotIndex = ref(14);
const pointAIndex = ref(16);

const setROMCombination = (combination: keyof typeof ROMCombinations) => {
  const { pivot, movable } = ROMCombinations[combination];
  pivotIndex.value = pivot;
  pointAIndex.value = movable;
};

const handleKeyDown = (event: KeyboardEvent) => {
  if (event.key === "a") {
    savedNormalizedLandmarks.value =
      mediapipeResults.value?.poseLandmarks ?? null;
  }

  if (event.key === "b") {
    console.log("calculateVectorAngle");
    savedAngle.value = calculatedAngle.value;
  }

  if (event.key === "c") {
    calculatedAngle.value = 0;
    savedNormalizedLandmarks.value = null;
    console.log("cleanup done");
  }

  if (event.key === "d") {
    window.location.reload();
  }
};

// Remove event listener when component is unmounted
onUnmounted(() => {
  window.removeEventListener("keydown", handleKeyDown);
});

const canvasWidth = computed(() => {
  return window.innerWidth;
});

const canvasHeight = computed(() => {
  return canvasWidth.value * (9 / 16);
});

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
  window.addEventListener("keydown", handleKeyDown);
});
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
