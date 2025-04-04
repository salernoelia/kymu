<template>
  <EditorDropZone
    v-if="
      editorStore.draggingExercise &&
      !editorStore.isExerciseBeingDragged(exercise.id)
    "
    :unit="unit"
    :position="index"
  />
  <div
    class="card flex flex-row justify-between items-start"
    draggable="true"
    @dragstart="emit('dragstart', $event)"
    @dragend="handleDragEnd"
    @click="editorStore.openEditExerciseSidebar(exercise.id)"
  >
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
</template>

<script setup lang="ts">
const props = defineProps<{
  exercise: Tables<"exercises">;
  index: number;
  unit: UnitWithDetails;
}>();
const editorStore = useEditorStore();

const emit = defineEmits<{
  dragstart: [event: DragEvent];
}>();

const handleDragEnd = (event: DragEvent) => {
  editorStore.endDragExercise(event);
};
</script>
