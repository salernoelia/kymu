<template>
  <div
    class="unit-block"
    @dragover="onDragOver"
    @dragleave="onDragLeave"
    @drop="onDrop"
    :class="{
      'drop-active': isDropActive,
      'drop-hover': isDropHover,
    }"
  >
    <div class="block-header">
      <slot name="header"></slot>
    </div>

    <div class="exercise-container">
      <slot name="exercises"></slot>

      <div
        v-for="(zone, index) in dropZones"
        :key="`drop-zone-${index}`"
        class="drop-zone"
        :class="{ 'drop-zone-active': activeDropZone === index }"
        @dragover.prevent="activateDropZone(index)"
        @dragleave="deactivateDropZone"
        @drop.stop="onDropInZone($event, index)"
      ></div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  id: number;
  exerciseCount: number;
}>();

const emit = defineEmits<{
  (
    e: "drop",
    data: {
      exerciseId: number;
      sourceBlockId: number;
      targetBlockId: number;
      newPosition: number;
    }
  ): void;
}>();

const isDropActive = ref(false);
const isDropHover = ref(false);
const activeDropZone = ref(-1);

// Create drop zones between exercises and at the beginning/end
const dropZones = computed(() => {
  // +1 for the beginning and end of the list
  return Array(props.exerciseCount + 1).fill(null);
});

function onDragOver(event: DragEvent) {
  event.preventDefault();
  isDropActive.value = true;
}

function onDragLeave() {
  isDropActive.value = false;
}

function activateDropZone(index: number) {
  activeDropZone.value = index;
  isDropHover.value = true;
}

function deactivateDropZone() {
  setTimeout(() => {
    activeDropZone.value = -1;
    isDropHover.value = false;
  }, 100);
}

function onDrop(event: DragEvent) {
  // This is a fallback for drops not caught by specific zones
  event.preventDefault();
  isDropActive.value = false;
  isDropHover.value = false;
}

function onDropInZone(event: DragEvent, position: number) {
  event.preventDefault();
  isDropActive.value = false;
  isDropHover.value = false;
  activeDropZone.value = -1;

  if (!event.dataTransfer) return;

  try {
    const data = JSON.parse(event.dataTransfer.getData("application/json"));

    emit("drop", {
      exerciseId: data.id,
      sourceBlockId: data.blockId,
      targetBlockId: props.id,
      newPosition: position,
    });
  } catch (e) {
    console.error("Invalid drop data", e);
  }
}
</script>

<style scoped lang="scss">
.unit-block {
  border: 1px solid #ccc;
  padding: 1rem;
  margin: 1rem 0;
  width: 400px;
  background-color: #f5f5f5;
  border-radius: 8px;
  transition: all 0.3s ease;

  &.drop-active {
    border-color: #15ca82;
  }

  &.drop-hover {
    background-color: rgba(21, 202, 130, 0.05);
  }
}

.block-header {
  margin-bottom: 1rem;
}

.exercise-container {
  position: relative;
}

.drop-zone {
  height: 10px;
  margin: 5px 0;
  border-radius: 4px;
  transition: all 0.2s ease;

  &-active {
    background-color: #15ca82;
    height: 20px;
  }
}
</style>
