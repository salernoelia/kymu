<template>
  <div>
    <EditorCardTitle :title="unit.name" />
    <EditorCardExercise />
  </div>
</template>

<script setup lang="ts">
const patientID = inject("patientId");

const props = defineProps<{ unit: Unit }>();
</script>

<style scoped></style>
