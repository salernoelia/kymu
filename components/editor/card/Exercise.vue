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
      <PrimitivesDivider class="mt-1 mb-1" />
      <h2>Herzfrequenz</h2>
      <Transition name="chart-fade">
        <AreaChart
          :data="data"
          index="name"
          :categories="['Total', 'Average']"
          class="w-full h-[250px] -translate-x-4"
          :show-gradiant="true"
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

import {
  type DateValue,
  getLocalTimeZone,
  today,
} from "@internationalized/date";
import { AreaChart } from "@/components/ui/chart-area";
import { curveCardinal } from "d3";

const data = [
  {
    name: "2min",
    Total: 75,
    Average: 78,
  },
  {
    name: "4min",
    Total: 85,
    Average: 82,
  },
  {
    name: "6min",
    Total: 110,
    Average: 105,
  },
  {
    name: "8min",
    Total: 130,
    Average: 125,
  },
  {
    name: "10min",
    Total: 145,
    Average: 140,
  },
  {
    name: "12min",
    Total: 120,
    Average: 130,
  },
  {
    name: "14min",
    Total: 100,
    Average: 110,
  },
];

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
</script>

<style scoped lang="scss">
.card {
  transition: all 0.3s ease-in-out;
  overflow: visible;
}

.chart-container {
  width: 100%;
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.5s ease-in-out;

  &.chart-visible {
    max-height: 300px; /* Increased from 220px */
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
