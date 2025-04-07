<template>
  <div class="flex flex-row gap-4">
    <div
      class="flex flex-col gap-4 min-w-[400px] max-w-[400px] overflow-y-auto"
      @dragover.prevent
    >
      <EditorCardTitle
        :name="unit.name"
        :description="unit.description || ''"
        @click="
          editorStore.openEditUnitSidebar(
            unit
            // ,
            // lastExerciseInIndexID
          )
        "
      />
      <EditorCardAssessment
        v-if="unit.start_assessment"
        :assessment="unit.start_assessment"
        :unitID="unit.id"
      />
      <EditorCardExercise
        v-for="(exercise, index) in unit.exercises || []"
        :key="exercise.id"
        :exercise="exercise"
        :index="index"
        :unit="unit"
        @dragstart="handleDragStart($event, exercise)"
      >
      </EditorCardExercise>
      <EditorDropZone
        v-if="dragDropStore.draggingExercise && unit.exercises.length === 0"
        :unitID="unit.id"
      />
      <EditorDropZone
        v-else-if="
          dragDropStore.draggingExercise && !lastExerciseIsBeingDragged
        "
        :unitID="unit.id"
        :position="unit.exercises.length"
      />
      <EditorCardNewExercise
        :unit="unit"
        v-if="lastExerciseInIndexID"
        @click="editorStore.openNewExerciseSidebar(unit, lastExerciseInIndexID)"
      />
      <EditorCardAssessment
        v-if="unit.end_assessment"
        :assessment="unit.end_assessment"
        :unitID="unit.id"
      />
    </div>
    <PrimitivesDivider orientation="vertical" />
  </div>
</template>

<script setup lang="ts">
const patientID = inject("patientId");
const props = defineProps<{
  unit: UnitWithDetails;
}>();
const editorStore = useEditorStore();
const dragDropStore = useDragDropStore();
const exerciseCrud = useExerciseCrud();

const lastExerciseInIndexID = computed(() => {
  if (!props.unit.exercises.length) return "new";
  return props.unit.exercises[props.unit.exercises.length - 1]?.id;
});

const lastExerciseIsBeingDragged = computed(() => {
  if (!props.unit.exercises.length) return false;
  const lastExercise = props.unit.exercises[props.unit.exercises.length - 1];
  if (!lastExercise) return false;
  return dragDropStore.isExerciseBeingDragged(lastExercise.id);
});

const handleDragStart = (event: DragEvent, exercise: Tables<"exercises">) => {
  dragDropStore.startDragExercise(event, exercise, props.unit.id);
};

function guiltTrip() {
  guiltTrip();
}
</script>
<!--   -->
