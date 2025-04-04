<template>
  <div>
    <h1>Edit Exercise</h1>
    <h3>{{ editorStore.selectedExercise }}</h3>
  </div>
</template>

<script setup lang="ts">
const editorStore = useEditorStore();
</script>

<style scoped></style>
