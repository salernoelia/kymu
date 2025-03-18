<template>
  <div class="exercise-creator-page">
    <h1>Rehabilitation Exercise Creator</h1>
    <p class="description">
      Create customized rehabilitation exercises by selecting movement patterns
      and adjusting range of motion.
    </p>

    <ThreeExerciseBuilder />
  </div>
</template>

<script setup lang="ts">
// Page component for exercise creation
</script>

<style scoped>
.exercise-creator-page {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
}

h1 {
  margin-bottom: 10px;
}

.description {
  margin-bottom: 30px;
  color: #666;
}
</style>
