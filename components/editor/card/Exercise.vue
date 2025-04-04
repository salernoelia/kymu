<template>
  <EditorDropZone
    v-if="
      dragDropStore.draggingExercise &&
      !dragDropStore.isExerciseBeingDragged(exercise.id)
    "
    :unitID="unit.id"
    :position="index"
  />
  <div
    class="card flex flex-col justify-between items-start"
    draggable="true"
    @dragstart="emit('dragstart', $event)"
    @dragend="handleDragEnd"
    @mouseenter="startHoverTimer"
    @mouseleave="cancelHoverAndHideChart"
    @click="editorStore.openEditExerciseSidebar(exercise.id)"
  >
    <div class="flex flex-row w-full justify-between items-start">
      <div class="left">
        <h2>
          {{ exercise.name }}
        </h2>
        <h3>
          {{ exercise.description }}
        </h3>
      </div>
      <div class="right">
        <Icon name="mdi-light:dots-vertical" />
      </div>
    </div>

    <div
      class="chart-container"
      :class="{ 'chart-visible': showChart }"
    >
      <Transition name="chart-fade">
        <ChartsBar
          v-if="showChart"
          :data="barChartData"
          :width="300"
          :height="200"
          barColor="#3498db"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  exercise: Tables<"exercises">;
  index: number;
  unit: UnitWithDetails;
}>();
const editorStore = useEditorStore();
const dragDropStore = useDragDropStore();

const showChart = ref(false);
const hoverTimer = ref<number | null>(null);
const HOVER_DELAY = 300;

const emit = defineEmits<{
  dragstart: [event: DragEvent];
}>();

const handleDragEnd = (event: DragEvent) => {
  dragDropStore.endDragExercise(event);
};

const startHoverTimer = () => {
  if (hoverTimer.value !== null) {
    clearTimeout(hoverTimer.value);
  }

  hoverTimer.value = window.setTimeout(() => {
    showChart.value = true;
    hoverTimer.value = null;
  }, HOVER_DELAY);
};

const cancelHoverAndHideChart = () => {
  if (hoverTimer.value !== null) {
    clearTimeout(hoverTimer.value);
    hoverTimer.value = null;
  }

  showChart.value = false;
};

const barChartData = ref([
  { name: "Jan", value: 45 },
  { name: "Feb", value: 23 },
  { name: "Mar", value: 56 },
  { name: "Apr", value: 78 },
  { name: "May", value: 42 },
]);
</script>

<style scoped lang="scss">
.card {
  transition: all 0.3s ease-in-out;
  overflow: hidden;
}

.chart-container {
  width: 100%;
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease-in-out;

  &.chart-visible {
    max-height: 220px;
  }
}

// Chart transition effects
.chart-fade-enter-active,
.chart-fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.chart-fade-enter-from,
.chart-fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
</style>
