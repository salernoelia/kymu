<!-- Exercise ID -->

<template>
  <!-- ROM combination dropdown moved from component -->
  <div class="w-full h-full flex flex-col items-start justify-start gap-2">
    <select
      name="select-rom-combination"
      class="w-96 p-2 text-lg border rounded"
      v-model="selectedROMCombination"
      ref="dropdown"
    >
      <option
        v-for="(value, key) in ROMCombinations"
        :key="key"
        :value="key"
      >
        {{ $t(key) }}
      </option>
    </select>
    <TvRom
      :rom-combination="selectedROMCombination"
      ref="romComponent"
    ></TvRom>
  </div>
</template>

<script setup lang="ts">
import { ROMCombinations } from "~/shared/constants/ROMCombinations";

const tvStore = useTVStore();

definePageMeta({
  title: "Kymu",
  layout: "television",
});

const romCombinationsKeys = Object.keys(ROMCombinations) as Array<
  keyof typeof ROMCombinations
>;
const selectedROMCombination = ref<keyof typeof ROMCombinations>(
  romCombinationsKeys[0] ?? "shoulder_abduction_left"
);
const currentIndex = ref(0);
const dropdown = ref<HTMLSelectElement | null>(null);

const romComponent = ref<null | {
  markPainMoment: () => void;
  saveLandmarks: () => void;
  calculateAngle: () => void;
  cleanup: () => void;
}>(null);

const { remoteKey } = useRemoteControl();

onMounted(() => {
  tvStore.initializeExercisesState();
});

const changeROMSelection = (direction: number) => {
  const keys = romCombinationsKeys;
  currentIndex.value =
    (currentIndex.value + direction + keys.length) % keys.length;
  const newSelection = keys[currentIndex.value];
  if (newSelection) selectedROMCombination.value = newSelection;
};

const handleRemoteKey = (newKey: string | null) => {
  if (!newKey) return;

  if (newKey === "right") {
    changeROMSelection(1);
  } else if (newKey === "left") {
    changeROMSelection(-1);
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
