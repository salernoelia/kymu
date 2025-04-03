<template>
  <div class="card flex flex-row justify-between items-center">
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
const props = defineProps<{ exercise: Tables<"exercises"> }>();
</script>

<style scoped></style>
