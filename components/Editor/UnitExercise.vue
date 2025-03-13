<template>
  <div
    class="card"
    :id="`exercise-${id}`"
    :draggable="true"
    @dragstart="onDragStart"
    @dragend="onDragEnd"
    :class="{ dragging: isDragging }"
  >
    <Icon
      name="ic:baseline-drag-handle"
      size="1.5rem"
    />
    <div class="flex flex-col">
      <slot></slot>
    </div>

    <Icon
      class="douplicate icon-single cursor-pointer"
      size="1.25rem"
      name="ic:round-control-point-duplicate"
      @click="() => store.duplicateExercise(exercise.id)"
    />
    <Icon
      class="edit icon-single cursor-pointer"
      size="1.25rem"
      name="material-symbols-light:edit-square-outline"
      @click="() => store.selectExercise(exercise)"
    />
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  id: string;
  exercise: Tables<"exercises">;
  unitId: string;
  orderPosition: number;
}>();

const store = useEditorStore();
const isDragging = ref(false);

function onDragStart(event: DragEvent) {
  if (!event.dataTransfer) return;

  event.stopPropagation();
  isDragging.value = true;

  const data = {
    id: props.id,
    unitId: props.unitId,
    position: props.orderPosition,
  };

  event.dataTransfer.effectAllowed = "move";
  event.dataTransfer.setData("application/json", JSON.stringify(data));

  if (event.target instanceof Element) {
    event.dataTransfer.setDragImage(event.target, 20, 20);
  }

  store.handleDragStart(data);
}

function onDragEnd() {
  isDragging.value = false;
  store.handleDragEnd();
}
</script>

<style scoped lang="scss">
.card {
  border: 1px solid var(--color-gray-400);
  background-color: #fff;
  filter: drop-shadow(0px 0px 20px rgba(40, 60, 126, 0.03));

  padding: 1rem;
  margin: 0.7rem 0;
  cursor: grab;
  position: relative;
  transition: all 0.2s ease;
  display: flex;
  flex-direction: row;
  align-items: center;
  border-radius: 0.5rem;
  gap: 0.5rem;

  &.dragging {
    opacity: 0.5;
    transform: scale(0.98);
  }

  &:hover {
    border-color: #15ca82;
  }
}

.handle {
  cursor: grab;
  color: #666;

  &:hover {
    color: #15ca82;
  }
}

.edit {
  position: absolute;
  right: 0.5rem;
  top: 0.5rem;
  cursor: pointer;
}

.douplicate {
  position: absolute;
  right: 2.5rem;
  top: 0.5rem;
  cursor: pointer;
}
</style>
