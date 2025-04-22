<template>
  <div class="tv-exercise-container">
    <h1>Heutiger Plan</h1>
    <div
      v-if="isLoading"
      class="loading"
    >
      <p>Loading exercises...</p>
    </div>

    <div
      v-else-if="error"
      class="error"
    >
      <p>{{ error }}</p>
    </div>

    <div
      v-else-if="!currentUnit || !currentUnit.exercises?.length"
      class="no-exercises"
    >
      <p>No exercises available for this unit</p>
    </div>

    <div
      v-else
      class="exercises flex flex-row gap-4"
    >
      <TvExercises
        v-for="(exercise, index) in currentUnit.exercises"
        :key="exercise.id || index"
        :title="exercise.name"
        :description="exercise.description"
      />
    </div>

    <div
      v-if="currentUnit"
      class="navigation-help mt-4"
    ></div>
    <h1>Drücke nach rechts um weiterzumachen!</h1>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  title: "Kymu",
  layout: "television",
});

// Composables
const localePath = useLocalePath();
const { remoteKey } = useRemoteControl();
const route = useRoute();
const tvStore = useTVStore();

// Route params
const patientId = route.params.patientid as string;
const unitId = route.params.unitid as string;
const exerciseProgress = computed(() => tvStore.exerciseProgress);

// State
const isLoading = ref(true);
const error = ref<string | null>(null);

// Access the reactive state from the store
const {
  currentUnit,
  isLoading: storeLoading,
  error: storeError,
} = storeToRefs(tvStore);

// Watch for remote control inputs
watch(
  () => remoteKey.value,
  (newKey) => {
    if (newKey === "ok") {
      navigateToSelectedExercise();
    }
  }
);

// Methods
const navigateToSelectedExercise = () => {
  if (!currentUnit.value?.exercises) return;
  console.log("unitid", unitId);
  navigateTo(
    localePath(
      `/tv/${patientId}/${unitId}/${
        currentUnit.value?.exercises[exerciseProgress.value.current - 1]?.id
      }/progress`
    )
  );
};

const fetchUnitData = async () => {
  try {
    isLoading.value = true;
    error.value = null;

    if (!unitId) {
      error.value = "Invalid unit ID";
      return;
    }

    await tvStore.getUnitById(unitId);

    if (!currentUnit.value) {
      error.value = "Unit not found";
    }
  } catch (err) {
    console.error("Error fetching unit data:", err);
    error.value =
      err instanceof Error ? err.message : "Failed to load unit data";
  } finally {
    isLoading.value = false;
  }
};

// Lifecycle
onMounted(async () => {
  await fetchUnitData();
});
</script>

<style scoped></style>
