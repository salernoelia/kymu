<template>
  <div class="w-full">
    <div class="flex flex-row w-full">
      <div class="flex flex-col w-full items-center">
        <!-- Display the angle information -->
        <div class="angle-display mb-4">
          <p>Current Angle: {{ currentAngle.toFixed(2) }}</p>
          <p>Pain Moments: {{ romStore.painMomentAngles }}</p>

          <p>{{ referenceAngle }}</p>
          <p>{{ isInsideOfThreshold }}</p>
          <!-- <p>Result Angle: {{ romStore.resultAngle.toFixed(2) }}</p> -->
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
          style="width: 50%"
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
// todo: use the fetched categories
import { ROMCombinations } from "~/shared/constants/ROMCombinations";
import { getReferenceAngleDeg } from "~/shared/utils/getReferenceAngleDeg";
import type { Results } from "@mediapipe/pose";
import type { NormalizedLandmarkList } from "@mediapipe/drawing_utils";
import { useRomStore } from "~/stores/romStore";
import * as Tone from "tone";

const supabase = useSupabaseClient();

// const { data: romCombinationData } = await supabase
//   .from("exercise_categories")
//   .select("*");
// console.log(romCombinationData);

const props = defineProps<{
  romCombination: string;
}>();

console.log(props.romCombination);

const romStore = useRomStore();

//create a synth and connect it to the main output (your speakers)
const synth = new Tone.Synth().toDestination();

//play a middle 'C' for the duration of an 8th note
synth.triggerAttackRelease("C4", "8n");

const source = ref<HTMLVideoElement | null>(null);
const canvas = ref<HTMLCanvasElement | null>(null);
const landmarkContainer = ref<HTMLDivElement | null>(null);
const loadingCanvas = ref(true);
const mediapipeResults = ref<Results | null>(null);
const exerciseInitialNormalizedLandmarks = ref<NormalizedLandmarkList | null>(
  null
);

const currentAngle = ref(0);
const referenceAngle = ref(0);

const pivotIndex = ref(14);
const movableIndex = ref(16);
const referenceIndex = ref(23);
const thresholdDeg = ref(30);

const toneForRom = useToneForRom(currentAngle);

const isInsideOfThreshold = computed((): boolean => {
  if (
    !mediapipeResults.value ||
    !mediapipeResults.value.poseWorldLandmarks ||
    !mediapipeResults.value.poseWorldLandmarks.length ||
    !mediapipeResults.value.poseWorldLandmarks[movableIndex.value] ||
    !mediapipeResults.value.poseWorldLandmarks[pivotIndex.value] ||
    !mediapipeResults.value.poseWorldLandmarks[referenceIndex.value] ||
    mediapipeResults.value.poseWorldLandmarks[movableIndex.value]
      ?.visibility === undefined ||
    (mediapipeResults.value.poseWorldLandmarks[movableIndex.value]
      ?.visibility ?? 0) < 0.9
  ) {
    return false;
  }

  const A = mediapipeResults.value.poseWorldLandmarks[movableIndex.value];
  const B = mediapipeResults.value.poseWorldLandmarks[pivotIndex.value];
  const C = mediapipeResults.value.poseWorldLandmarks[referenceIndex.value];

  if (!A || !B || !C) return false;

  referenceAngle.value = getReferenceAngleDeg(A, B, C);

  if (referenceAngle.value <= thresholdDeg.value) {
    // toneForRom.startTone();
    return true;
  } else {
    toneForRom.stopTone();
    return false;
  }
});

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
  const { pivot, movable, reference, threshold } = ROMCombinations[combination];
  pivotIndex.value = pivot;
  movableIndex.value = movable;
  referenceIndex.value = reference;
  thresholdDeg.value = threshold;
}

function saveLandmarks() {
  exerciseInitialNormalizedLandmarks.value =
    mediapipeResults.value?.poseLandmarks ?? null;
  console.log("Landmarks saved");
}

function calculateAngle() {
  console.log("calculateVectorAngle");
  romStore.resultAngle = currentAngle.value;
}

function markPainMoment() {
  console.log("marked pain moment at", currentAngle.value);
  romStore.painMomentAngles.push(currentAngle.value);
  romStore.painMomentAngles.sort((a, b) => a - b);
}

function cleanup() {
  currentAngle.value = 0;
  romStore.resultAngle = 0;
  exerciseInitialNormalizedLandmarks.value = null;
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
      exerciseInitialNormalizedLandmarks,
      pivotIndex,
      movableIndex,
      currentAngle
    ).setOptions({
      modelComplexity: 0,
      smoothLandmarks: true,
      enableSegmentation: false,
      smoothSegmentation: false,
      minDetectionConfidence: 0.3,
      minTrackingConfidence: 0.3,
      selfieMode: true,
    });
  }
});

onBeforeUnmount(() => {
  toneForRom.stopTone();
});

const canvasWidth = computed(() => window.innerWidth);
const canvasHeight = computed(() => canvasWidth.value * (9 / 16));

defineExpose({
  saveLandmarks,
  calculateAngle,
  cleanup,
  markPainMoment,
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
