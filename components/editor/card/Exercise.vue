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
  >
    <div class="flex flex-row w-full justify-between items-start">
      <div class="h-full flex flex-row gap-4 items-center">
        <Icon
          name="ic:baseline-drag-handle"
          class="icon"
        />

        <div class="flex flex-col">
          <h2>
            {{ exercise.name }}
          </h2>
          <h3>
            {{ exercise.description }}
          </h3>
        </div>
      </div>
      <div class="right flex flex-row gap-3">
        <Icon
          @click="toggleChart"
          name="ic:baseline-bar-chart"
          class="icon"
        />
        <Icon
          @click="editorStore.openEditExerciseSidebar(exercise.id)"
          name="ic:baseline-edit"
          class="icon"
        />

        <DropdownMenu>
          <DropdownMenuTrigger
            ><Icon
              name="ic:baseline-more-vert"
              class="icon"
          /></DropdownMenuTrigger>
          <DropdownMenuContent>
            <DropdownMenuLabel>{{ exercise.name }}</DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem
              @click="editorStore.openEditExerciseSidebar(exercise.id)"
              >{{ $t("ex-edit") }}</DropdownMenuItem
            >
            <DropdownMenuItem>{{ $t("ex-analysis") }}</DropdownMenuItem>
            <DropdownMenuItem @click="toggleChart">{{
              $t("ex-rating-graph")
            }}</DropdownMenuItem>
            <DropdownMenuItem @click="toggleChart">{{
              $t("ex-execution-graph")
            }}</DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
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
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

const props = defineProps<{
  exercise: Tables<"exercises">;
  index: number;
  unit: UnitWithDetails;
}>();
const editorStore = useEditorStore();
const dragDropStore = useDragDropStore();

const showChart = ref(false);

const emit = defineEmits<{
  dragstart: [event: DragEvent];
}>();

const handleDragEnd = (event: DragEvent) => {
  dragDropStore.endDragExercise(event);
};

const toggleChart = () => {
  showChart.value = !showChart.value;
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
