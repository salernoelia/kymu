<template>
  <div class="flex flex-row justify-center align-center">
    <div v-if="currentExercise">
      <h1>{{ currentExercise.name }}</h1>
      <h2>{{ currentExercise.description }}</h2>
      <h2>{{ currentExercise.exercise_type }}</h2>
      <!-- <p>{{ currentExercise }}</p> -->

      <div>
        <h2>
          Exercise {{ exerciseProgress.current }} of
          {{ exerciseProgress.total }} ({{ exerciseProgress.percentage }}%)
        </h2>

        <div v-if="currentExercise.repetitions_goal">
          <h2>Goal: {{ currentExercise.repetitions_goal }} repetitions</h2>
        </div>

        <div v-if="currentExercise.duration_seconds_goal">
          <h2>Goal: {{ currentExercise.duration_seconds_goal }} seconds</h2>
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
      <div class="w-full flex justify-center">
        <TvProgress
          :current="exerciseProgress.current - 1"
          :total="exerciseProgress.total"
        />
      </div>
    </div>

    <div v-else>
      <p>No exercise found</p>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute();
const tvStore = useTVStore();

const localePath = useLocalePath();

const exerciseId = computed(() => route.params.exerciseid as string);
const unitId = computed(() => route.params.unitid as string);
const currentExercise = computed(() => tvStore.currentExercise);
const exerciseProgress = computed(() => tvStore.exerciseProgress);

// Route params
const patientId = route.params.patientid as string;

// Access the reactive state from the store
const {
  currentUnit,
  isLoading: storeLoading,
  error: storeError,
} = storeToRefs(tvStore);

const { remoteKey } = useRemoteControl();

watch(
  () => remoteKey.value,
  (newKey) => {
    if (newKey === "right") {
      console.log("unitid", unitId.value);
      navigateTo(
        localePath(
          `/tv/${patientId}/${unitId.value}/${currentUnit.value?.exercises[0]?.id}/instruction`
        )
      );
    }
  }
);

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
