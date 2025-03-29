<template>
  <div class="angle-visualization">
    <canvas ref="canvasRef"></canvas>
    <div
      v-if="showAngle"
      class="angle-label"
    >
      {{ angleValue.toFixed(1) }}°
    </div>
  </div>
</template>

<script setup lang="ts">
interface Point {
  x: number;
  y: number;
  z: number;
  visibility?: number;
}

interface Props {
  pivotPoint: Point;
  pointA: Point;
  pointB: Point;
  width?: number | string;
  height?: number | string;
  showAngle?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  width: "100%",
  height: "300px",
  showAngle: true,
});

const {
  canvasRef,
  angleValue,
  initVisualization,
  cleanupVisualization,
  visualizeAngle,
  resetScene,
} = useVectorAngleVisualization();

const hasValidPoints = computed(() => {
  return (
    props.pivotPoint &&
    props.pointA &&
    props.pointB &&
    (props.pivotPoint.visibility === undefined ||
      props.pivotPoint.visibility > 0.5) &&
    (props.pointA.visibility === undefined || props.pointA.visibility > 0.5) &&
    (props.pointB.visibility === undefined || props.pointB.visibility > 0.5)
  );
});

watch(
  () => [props.pivotPoint, props.pointA, props.pointB],
  async () => {
    if (hasValidPoints.value) {
      await nextTick();
      resetScene();
      visualizeAngle(props.pivotPoint, props.pointA, props.pointB);
    }
  },
  { deep: true, immediate: true }
);

onMounted(async () => {
  await nextTick();
  initVisualization();

  if (hasValidPoints.value) {
    visualizeAngle(props.pivotPoint, props.pointA, props.pointB);
  }
});

onUnmounted(() => {
  cleanupVisualization();
});
</script>

<style scoped>
.angle-visualization {
  position: relative;
  width: v-bind("props.width");
  height: v-bind("props.height");
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

canvas {
  width: 100%;
  height: 100%;
  display: block;
}

.angle-label {
  position: absolute;
  top: 10px;
  left: 10px;
  background-color: rgba(0, 0, 0, 0.7);
  color: #ffff00;
  padding: 4px 8px;
  border-radius: 4px;
  font-family: Arial, sans-serif;
  font-weight: bold;
  font-size: 14px;
}
</style>
