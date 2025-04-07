<template>
  <div
    class="dialog-backdrop"
    @click.self="onDiscard"
  >
    <div class="dialog-container">
      <p class="mb-4">Do you want to save your changes?</p>
      <div class="flex flex-row items-center justify-between gap-4">
        <PrimitivesButton
          variant="danger"
          @click="onDiscard"
        >
          Discard
        </PrimitivesButton>

        <PrimitivesButton
          variant="primary"
          @click="onSave"
        >
          Save
        </PrimitivesButton>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  onSave: () => void;
  onDiscard: () => void;
}>();
</script>

<style scoped>
.dialog-backdrop {
  z-index: 9998;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.dialog-container {
  z-index: 9999;
  background-color: white;
  padding: 1.5rem;
  border-radius: 0.5rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  max-width: 90%;
  width: 400px;
}
</style>
