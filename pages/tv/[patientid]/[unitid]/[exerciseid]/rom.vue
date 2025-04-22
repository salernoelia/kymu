<template>
  <div class="w-full h-full flex flex-col items-start justify-start gap-2">
    <h1>{{ currentExercise?.name }}</h1>
    <TvRom
      :rom-combination="selectedROMCombination"
      ref="romComponent"
    ></TvRom>
  </div>
</template>

<script setup lang="ts">
import { ROMCombinations } from "~/shared/constants/ROMCombinations";

const localePath = useLocalePath();
const route = useRoute();

const tvStore = useTVStore();

// Route params
const patientId = route.params.patientid as string;

const unitId = computed(() => route.params.unitid as string);
const currentExercise = computed(() => tvStore.currentExercise);
const exerciseProgress = computed(() => tvStore.exerciseProgress);

const {
  currentUnit,
  isLoading: storeLoading,
  error: storeError,
} = storeToRefs(tvStore);

definePageMeta({
  title: "Kymu",
  layout: "television",
});

const romCombinationsKeys = Object.keys(ROMCombinations) as Array<
  keyof typeof ROMCombinations
>;
const selectedROMCombination = ref<Tables<"exercise_categories">["name"]>(
  currentExercise.value?.category ?? "shoulder_abduction_left"
);

const romComponent = ref<null | {
  markPainMoment: () => void;
  saveLandmarks: () => void;
  calculateAngle: () => void;
  cleanup: () => void;
}>(null);

const { remoteKey } = useRemoteControl();

// onMounted(() => {
//   tvStore.initializeExercises();
// });

const handleRemoteKey = (newKey: string | null) => {
  if (!newKey) return;

  if (newKey === "right") {
    tvStore.exerciseStateMachine.goToNextExercise();
    navigateTo(
      localePath(
        `/tv/${patientId}/${unitId.value}/${currentExercise?.value?.id}/progress`
      )
    );
  } else if (newKey === "ok") {
    if (romComponent.value) {
      romComponent.value.saveLandmarks();
    }
  } else if (newKey === "down") {
    window.location.reload();
  } else if (newKey === "up") {
    if (romComponent.value) {
      romComponent.value.markPainMoment();
    }
  }

  setTimeout(() => {
    remoteKey.value = null;
  }, 100);
};

watch(remoteKey, handleRemoteKey);
</script>

<style scoped></style>
