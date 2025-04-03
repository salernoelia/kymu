<template>
  <div
    class="unit-block"
    :data-unit-id="id"
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

    <!-- Start Assessment -->
    <div
      v-if="startAssessment && startAssessment.id"
      class="assessment-container"
    >
      <slot name="start-assessment"></slot>
    </div>
    <div
      v-else
      class="assessment-placeholder start-assessment-placeholder"
      @click="onAddAssessment('start')"
    >
      <Icon
        name="material-symbols:clinical-notes"
        size="1.25rem"
      />
      <span>Add Start Assessment</span>
    </div>

    <div class="exercise-container">
      <div
        class="drop-zone"
        :class="{
          'drop-zone-active': activeDropZone === 0,
          'drop-zone-visible': shouldShowDropZone(0),
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
            'drop-zone-visible': shouldShowDropZone(index + 1, exercise.id),
          }"
          @dragover.prevent="activateDropZone(index + 1)"
          @dragleave="deactivateDropZone"
          @drop.stop="onDropInZone($event, index + 1)"
        ></div>
      </template>
    </div>

    <!-- End Assessment -->
    <div
      v-if="endAssessment && endAssessment.id"
      class="assessment-container"
    >
      <slot name="end-assessment"></slot>
    </div>
    <div
      v-else
      class="assessment-placeholder end-assessment-placeholder"
      @click="onAddAssessment('end')"
    >
      <Icon
        name="material-symbols:clinical-notes"
        size="1.25rem"
      />
      <span>Add End Assessment</span>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  id: string;
  exercises: Array<{ id: string; [key: string]: any }>;
  startAssessment?: { id: string; [key: string]: any } | null;
  endAssessment?: { id: string; [key: string]: any } | null;
}>();

const emit = defineEmits<{
  (
    e: "drop",
    data: {
      exerciseId: string;
      sourceUnitId: string;
      targetUnitId: string;
      newPosition: number;
    }
  ): void;
  (
    e: "add-assessment",
    data: {
      unitId: string;
      position: "start" | "end";
    }
  ): void;
}>();

const isDropActive = ref(false);
const isDropHover = ref(false);
const activeDropZone = ref(-1);
const dragInProgress = inject("dragInProgress", ref(false));

const draggingExerciseData = inject<Ref<DraggingExercise | null>>(
  "draggingExerciseData",
  ref(null)
);

function shouldShowDropZone(position: number, exerciseId?: string) {
  if (!dragInProgress.value) return false;

  if (
    draggingExerciseData.value &&
    draggingExerciseData.value.unitId &&
    draggingExerciseData.value.unitId === props.id
  ) {
    if (exerciseId && draggingExerciseData.value.id === exerciseId)
      return false;

    const draggedIndex = props.exercises.findIndex(
      (e) =>
        draggingExerciseData.value?.id != null &&
        e.id === draggingExerciseData.value.id
    );
    if (draggedIndex !== -1 && position === draggedIndex) return false;
  }

  return isDropActive.value || dragInProgress.value;
}

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

function resetDropState() {
  isDropActive.value = false;
  isDropHover.value = false;
  activeDropZone.value = -1;
}

function onDrop(event: DragEvent) {
  event.preventDefault();
  resetDropState();
}

function onDropInZone(event: DragEvent, position: number) {
  event.preventDefault();
  resetDropState();

  if (!event.dataTransfer) return;

  try {
    const dataString = event.dataTransfer.getData("application/json");
    console.log("Drop data:", dataString);

    if (!dataString) {
      console.error("No data found in drop event");
      return;
    }

    const data = JSON.parse(dataString);

    emit("drop", {
      exerciseId: data.id,
      sourceUnitId: data.unitId,
      targetUnitId: props.id,
      newPosition: position,
    });
  } catch (e) {
    console.error("Invalid drop data", e);
  }
}

function onAddAssessment(position: "start" | "end") {
  emit("add-assessment", {
    unitId: props.id,
    position: position,
  });
}
</script>

<style scoped lang="scss">
.unit-block {
  padding: 1rem;
  margin: 1rem 0;
  min-width: 400px;
  max-height: 100%;
  overflow-y: auto;
  overflow-x: hidden;
  height: fit-content;
  transition: all 0.3s ease;
  filter: drop-shadow(0px 0px 20px rgba(40, 60, 126, 0.03));
  border-radius: 8px;
  border-right: 1px solid var(--color-Gray-300);

  &.drop-active {
    border-color: #15ca82;
  }

  &.drop-hover {
    background-color: rgba(21, 202, 130, 0.05);
  }
}

.block-header {
  margin-bottom: 1rem;
  border: 1px solid #ccc;
  background-color: #ffffff;
  border-radius: 8px;
  padding: 1rem;
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
  display: none;

  &-visible {
    opacity: 0.3;
    height: 15px;
    background-color: rgba(21, 202, 130, 0.2);
    display: block;
  }

  &-active {
    opacity: 1;
    background-color: #15ca82;
    height: 30px;
    margin: 5px 0;
    display: block;
  }
}

.assessment-container {
  margin: 1rem 0;
}

.assessment-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.75rem;
  margin: 1rem 0;
  border-radius: 6px;
  border: 1px dashed #ccc;
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    border-color: #2196f3;
    background-color: rgba(33, 150, 243, 0.05);
  }

  &.start-assessment-placeholder {
    border-left: 3px solid #2196f3;
  }

  &.end-assessment-placeholder {
    border-left: 3px solid #9c27b0;
  }
}
</style>
