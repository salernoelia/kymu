<template>
  <div class="c flex flex-row justify-center items-center">
    <Icon
      name="ic:round-plus"
      class="w-6 h-6"
    />
  </div>
</template>

<script setup lang="ts"></script>

<style scoped lang="scss">
.c {
  padding: 1rem;
  border-radius: 0.5rem;
  background-color: #fff;
  border: var(--color-Stroke) 1px dashed;
  transition: all 0.3s ease;
  cursor: pointer;
  opacity: 0.9;
}

.c:hover {
  background-color: var(--color-Gray-100);
  border: var(--color-Primary) 1px dashed;
}
</style>
