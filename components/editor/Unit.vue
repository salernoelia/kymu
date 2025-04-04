<template>
  <div class="flex flex-row gap-4">
    <div
      class="flex flex-col gap-4 min-w-[350px]"
      @dragover.prevent
      @drop.prevent="handleDropToUnit"
    >
      <EditorCardTitle
        :name="unit.name"
        :description="unit.description || ''"
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
        v-if="editorStore.draggingExercise && unit.exercises.length === 0"
        :unit="unit"
      />
      <EditorDropZone
        v-else-if="editorStore.draggingExercise && !lastExerciseIsBeingDragged"
        :unit="unit"
        :position="unit.exercises.length"
      />
    </div>
    <EditorCardNewExercise
      :unit="unit"
      v-if="lastExerciseInIndexID"
      @click="editorStore.openNewExerciseSidebar(unit, lastExerciseInIndexID)"
    />
    <PrimitivesDivider orientation="vertical" />
  </div>
</template>

<script setup lang="ts">
const patientID = inject("patientId");
const props = defineProps<{ unit: UnitWithDetails }>();
const editorStore = useEditorStore();
const exerciseCrud = useExerciseCrud();

const lastExerciseInIndexID = computed(() => {
  if (!props.unit.exercises.length) return "new";
  return props.unit.exercises[props.unit.exercises.length - 1]?.id;
});

const lastExerciseIsBeingDragged = computed(() => {
  if (!props.unit.exercises.length) return false;
  const lastExercise = props.unit.exercises[props.unit.exercises.length - 1];
  if (!lastExercise) return false;
  return editorStore.isExerciseBeingDragged(lastExercise.id);
});

const handleDragStart = (event: DragEvent, exercise: Tables<"exercises">) => {
  editorStore.startDragExercise(event, exercise, props.unit.id);
};

const handleDropToUnit = (event: DragEvent) => {
  editorStore.onDropExercise(event, props.unit);
};
</script>
