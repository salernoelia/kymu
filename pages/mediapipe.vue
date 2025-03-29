<template>
  <div class="pose">
    <h1>Pose demo</h1>
    <!-- <h1>Elbow Right: {{ elbow_right }}</h1>
    <h1>Wrist Right: {{ wrist_right }}</h1> -->
    <h1>saved wrist A: {{ saved_wrist_right_A }}</h1>
    <h1>saved wrist B: {{ saved_wrist_right_B }}</h1>
    <h1>saved elbow: {{ saved_elbow_right }}</h1>

    <h1>Result Angle: {{ resultAngle }}</h1>
    <div class="container">
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
</template>

<script setup lang="ts">
import { PoseService, LogService } from "~/shared/services/pose_service";
import type { Results } from "@mediapipe/pose";
import { set } from "@vueuse/core";

const source = ref<InstanceType<typeof HTMLVideoElement> | null>(null);
const canvas = ref<InstanceType<typeof HTMLCanvasElement> | null>(null);
const landmarkContainer = ref<InstanceType<typeof HTMLDivElement> | null>(null);
const logService = new LogService();
const loadingCanvas = ref(true);
const mediapipeResults = ref<Results | null>(null);
const resultAngle = ref(0);

const elbow_right = computed(() => {
  return mediapipeResults.value?.poseLandmarks?.[14];
});
const wrist_right = computed(() => {
  return mediapipeResults.value?.poseLandmarks?.[16];
});

const saved_wrist_right_A = ref({
  x: 0,
  y: 0,
  z: 0,
  visibility: 0,
});

const saved_wrist_right_B = ref({
  x: 0,
  y: 0,
  z: 0,
  visibility: 0,
});

const saved_elbow_right = ref({
  x: 0,
  y: 0,
  z: 0,
  visibility: 0,
});

const calculateVectorAngle = () => {
  if (
    saved_elbow_right.value &&
    wrist_right.value &&
    wrist_right.value.visibility
  ) {
    saved_wrist_right_B.value = {
      x: wrist_right.value.x,
      y: wrist_right.value.y,
      z: wrist_right.value.z,
      visibility: wrist_right.value.visibility,
    };
    const { angleDeg } = useCalculateVectorAngle(
      saved_elbow_right.value,
      saved_wrist_right_A.value,
      wrist_right.value
    );
    resultAngle.value = angleDeg;
    console.log("Angle between vectors:", angleDeg);
    console.log(
      "calculation done:",
      saved_elbow_right.value,
      saved_wrist_right_A.value,
      saved_wrist_right_B.value
    );
  } else {
    console.log(
      "Elbow or wrist landmark not found",
      elbow_right,
      wrist_right,
      saved_wrist_right_A
    );
  }
};

const handleKeyDown = (event: KeyboardEvent) => {
  if (event.key === "a") {
    if (
      wrist_right.value &&
      wrist_right.value.visibility &&
      elbow_right.value &&
      elbow_right.value.visibility
    ) {
      saved_wrist_right_A.value = {
        x: wrist_right.value.x,
        y: wrist_right.value.y,
        z: wrist_right.value.z,
        visibility: wrist_right.value.visibility,
      };

      saved_elbow_right.value = {
        x: elbow_right.value.x,
        y: elbow_right.value.y,
        z: elbow_right.value.z,
        visibility: elbow_right.value.visibility,
      };
    }
  }

  if (event.key === "b") {
    console.log("calculateVectorAngle");
    calculateVectorAngle();
  }
};

// Remove event listener when component is unmounted
onUnmounted(() => {
  window.removeEventListener("keydown", handleKeyDown);
});

const canvasWidth = computed(() => {
  return window.innerWidth * 0.7;
});

const canvasHeight = computed(() => {
  return canvasWidth.value * (9 / 16);
});

onMounted(async () => {
  logService.debug_log("onMounted");
  logService.debug_log("canvasWidth", canvasWidth);
  logService.debug_log("canvasHeight", canvasHeight);
  if (canvas.value && source.value && landmarkContainer.value) {
    await new PoseService(
      canvas.value,
      source.value,
      canvasWidth.value,
      canvasHeight.value,
      landmarkContainer.value,
      loadingCanvas,
      mediapipeResults
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

onActivated(() => {
  logService.debug_log("onActivated");
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
