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
      <div
        class="drop-zone"
        :class="{
          'drop-zone-active': activeDropZone === 0,
          'drop-zone-visible': isDropActive || dragInProgress,
        }"
        @dragover.prevent="activateDropZone(0)"
        @dragleave="deactivateDropZone"
        @drop.stop="onDropInZone($event, 0)"
      ></div>

      <template
        v-for="(exercise, index) in exercises"
        :key="exercise.id"
      >
        <slot
          :name="`exercise-${exercise.id}`"
          :exercise="exercise"
        ></slot>

        <div
          class="drop-zone"
          :class="{
            'drop-zone-active': activeDropZone === index + 1,
            'drop-zone-visible': isDropActive || dragInProgress,
          }"
          @dragover.prevent="activateDropZone(index + 1)"
          @dragleave="deactivateDropZone"
          @drop.stop="onDropInZone($event, index + 1)"
        ></div>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  id: number;
  exercises: Array<{ id: number; [key: string]: any }>;
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
const dragInProgress = inject("dragInProgress", ref(false));

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
  height: 2px;
  margin: 1px 0;
  border-radius: 4px;
  transition: all 0.2s ease;
  background-color: transparent;
  opacity: 0;

  &-visible {
    opacity: 0.3;
    height: 15px;
    background-color: rgba(21, 202, 130, 0.2);
  }

  &-active {
    opacity: 1;
    background-color: #15ca82;
    height: 30px;
    margin: 5px 0;
  }
}
</style>
