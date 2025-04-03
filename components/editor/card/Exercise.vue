<template>
  <EditorDropZone
    v-if="
      editorStore.dragging && !editorStore.isExerciseBeingDragged(exercise.id)
    "
    :unit="unit"
    :position="index"
  />
  <div
    class="card flex flex-row justify-between items-center"
    draggable="true"
    @dragstart="emit('dragstart', $event)"
    @dragend="handleDragEnd"
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
      <h1>:</h1>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  exercise: Tables<"exercises">;
  index: number;
  unit: UnitWithDetails;
}>();

const emit = defineEmits<{
  dragstart: [event: DragEvent];
}>();

const editorStore = useEditorStore();

const handleDragEnd = (event: DragEvent) => {
  editorStore.endDragExercise(event);
};
</script>
