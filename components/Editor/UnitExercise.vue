<template>
  <div
    id="card"
    :draggable="true"
    @dragstart="onDragStart"
    @dragend="onDragEnd"
    :class="{ dragging: isDragging }"
  >
    <div class="handle">
      <svg
        width="16"
        height="16"
        viewBox="0 0 24 24"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          d="M8 6H16M8 12H16M8 18H16"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
        />
      </svg>
    </div>
    <slot></slot>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  id: number;
  unitId: number;
  orderPosition: number;
}>();

const emit = defineEmits<{
  (
    e: "dragstart",
    data: { id: number; unitId: number; position: number }
  ): void;
  (e: "dragend"): void;
}>();

const isDragging = ref(false);

function onDragStart(event: DragEvent) {
  if (!event.dataTransfer) return;

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

  emit("dragstart", data);
}

function onDragEnd() {
  isDragging.value = false;
  emit("dragend");
}
</script>

<style scoped lang="scss">
#card {
  border: 1px solid #494949;
  padding: 1rem;
  margin: 0.7rem 0;
  cursor: grab;
  position: relative;
  transition: all 0.2s ease;

  &.dragging {
    opacity: 0.5;
    transform: scale(0.98);
  }

  &:hover {
    border-color: #15ca82;
  }
}

.handle {
  position: absolute;
  top: 10px;
  right: 10px;
  cursor: grab;
  color: #666;

  &:hover {
    color: #15ca82;
  }
}
</style>
