<template>
  <div class="flex flex-row gap-4">
    <div class="flex flex-col gap-4 min-w-[350px]">
      <EditorCardTitle
        :name="unit.name"
        :description="unit.description"
      />
      <EditorCardExercise
        v-for="exercise in unit.exercises || []"
        :key="exercise.id"
        :exercise="exercise"
      >
      </EditorCardExercise>
    </div>
    <PrimitivesDivider orientation="vertical" />
  </div>
</template>

<script setup lang="ts">
const patientID = inject("patientId");

const props = defineProps<{ unit: UnitWithDetails }>();
console.log("unit", props.unit);
</script>

<style scoped></style>
