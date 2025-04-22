<template>
  <div class="flex flex-row justify-center align-center">
    <div v-if="currentExercise">
      <h1>{{ currentExercise.name }}</h1>
      <p>{{ currentExercise.description }}</p>
      <p>{{ currentExercise.exercise_type }}</p>
      <p>{{ currentExercise }}</p>

      <div>
        <p>
          Exercise {{ exerciseProgress.current }} of
          {{ exerciseProgress.total }} ({{ exerciseProgress.percentage }}%)
        </p>

        <div v-if="currentExercise.repetitions_goal">
          <p>Goal: {{ currentExercise.repetitions_goal }} repetitions</p>
        </div>

        <div v-if="currentExercise.duration_seconds_goal">
          <p>Goal: {{ currentExercise.duration_seconds_goal }} seconds</p>
        </div>
      </div>

      <div>
        <button
          @click="tvStore.exerciseStateMachine.goToPreviousExercise()"
          :disabled="tvStore.exerciseStateMachine.isFirstExercise"
        >
          Previous
        </button>

        <button @click="startCurrentExercise">Start Exercise</button>

        <button
          @click="tvStore.exerciseStateMachine.goToNextExercise()"
          :disabled="tvStore.exerciseStateMachine.isLastExercise"
        >
          Next
        </button>
      </div>
      <TvProgress
        :current="exerciseProgress.current - 1"
        :total="exerciseProgress.total"
      />
    </div>

    <div v-else>
      <p>No exercise found</p>
    </div>
  </div>
</template>

<script setup lang="ts">
const tvStore = useTVStore();
const route = useRoute();

const exerciseId = computed(() => route.params.exerciseid as string);
const unitId = computed(() => route.params.unitid as string);

const currentExercise = computed(() => tvStore.currentExercise);
const exerciseProgress = computed(() => tvStore.exerciseProgress);

onMounted(async () => {
  if (unitId.value) {
    await tvStore.getUnitById(unitId.value);

    if (exerciseId.value) {
      tvStore.setCurrentExercise(exerciseId.value);
    }
  }
});

const startCurrentExercise = () => {
  tvStore.exerciseStateMachine.startExercise();
};

definePageMeta({
  title: "Kymu",
  layout: "television",
});
</script>

<style scoped></style>
