<template>
  <div class="unit-block">
    <slot></slot>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  id: string;
  index: number;
  title: string;
  description: string;
  exercises: string[];
}>();
</script>

<style scoped lang="scss">
.unit-block {
  border: 1px solid #ccc;
  padding: 1rem;
  margin: 1rem 0;
  width: 400px;
}
</style>
