<template>
  <div
    class="drop-zone"
    @drop.prevent="handleDrop"
    @dragover.prevent
    @dragenter.prevent
  ></div>
</template>

<script setup lang="ts">
const props = defineProps<{
  unitID: Tables<"units">["id"];
  position?: number;
}>();

const editorStore = useEditorStore();
const dragDropStore = useDragDropStore();

const handleDrop = (event: DragEvent) => {
  dragDropStore.onDropExercise(event, props.unitID, props.position);
};
</script>
<style scoped>
.drop-zone {
  background-color: var(--color-Tertiary);
  border-radius: 5px;
  border: 2px dashed var(--color-Tertiary);
  height: 40px;
  transition: all 0.3s ease;
}

.drop-zone:hover {
  opacity: 0.9;
}
</style>
