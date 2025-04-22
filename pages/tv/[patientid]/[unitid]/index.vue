<template>
  <div class="tv-exercise-container">
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
      class="exercises flex flex-row"
    >
      <TvExercises
        v-if="exercisesWithFocus"
        v-for="(exercise, index) in exercisesWithFocus"
        :key="exercise.id || index"
        :title="exercise.name"
        :description="exercise.description"
        :focus="exercise.focus"
      />
    </div>

    <div
      v-if="currentUnit"
      class="navigation-help mt-4"
    >
      <p>Use ⬅️ and ➡️ to navigate, OK to select</p>
      <p>
        Selected: {{ selectedIndex + 1 }} /
        {{ currentUnit.exercises?.length || 0 }}
      </p>
    </div>
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

// State
const selectedIndex = ref(0);
const isLoading = ref(true);
const error = ref<string | null>(null);

// Access the reactive state from the store
const {
  currentUnit,
  isLoading: storeLoading,
  error: storeError,
} = storeToRefs(tvStore);

// Computed
const exercisesWithFocus = computed(() => {
  if (!currentUnit.value?.exercises) return [];

  return currentUnit.value.exercises.map((exercise, index) => {
    const exerciseObj = exercise as Record<string, any>;
    return {
      ...exerciseObj,
      focus: index === selectedIndex.value,
    };
  });
});

// Watch for remote control inputs
watch(
  () => remoteKey.value,
  (newKey) => {
    if (currentUnit.value?.exercises?.length) {
      const exerciseCount = currentUnit.value.exercises.length;

      if (newKey === "right") {
        selectedIndex.value = (selectedIndex.value + 1) % exerciseCount;
      } else if (newKey === "left") {
        selectedIndex.value =
          (selectedIndex.value - 1 + exerciseCount) % exerciseCount;
      } else if (newKey === "ok") {
        navigateToSelectedExercise();
      }
    }
  }
);

// Methods
const navigateToSelectedExercise = () => {
  if (!currentUnit.value?.exercises) return;

  const selectedExercise = currentUnit.value.exercises[selectedIndex.value];
  if (selectedExercise && unitId) {
    navigateTo(localePath(`/tv/${patientId}/${unitId}/${selectedExercise.Id}`));
  }
};

const fetchUnitData = async () => {
  try {
    isLoading.value = true;
    error.value = null;

    if (!unitId) {
      error.value = "Invalid unit ID";
      return;
    }

    await tvStore.getInstanceUnitByID(unitId);

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
