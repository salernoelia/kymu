<template>
  <div>
    <h1>New Unit or temp</h1>
    <h3>{{ editorStore.selectedUnit }}</h3>
  </div>
</template>

<script setup lang="ts">
const editorStore = useEditorStore();
</script>

<style scoped></style>
