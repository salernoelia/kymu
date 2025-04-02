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
import ROMCombinations from "~/shared/constants/ROMCombinations";

definePageMeta({
  title: "Kymu",
  layout: "television",
});

// ROM combinations moved from component

// const ROMCombinations = {
//   // neck_flexion: { pivot: 11, movable: 0 },
//   shoulder_abduction_left: { pivot: 11, movable: 13 },
//   shoulder_abduction_right: { pivot: 12, movable: 14 },
//   elbow_flexion_left: { pivot: 13, movable: 15 },
//   elbow_flexion_right: { pivot: 14, movable: 16 },
//   wrist_flexion_left: { pivot: 15, movable: 17 },
//   wrist_flexion_right: { pivot: 16, movable: 18 },
//   hip_flexion_left: { pivot: 23, movable: 25 },
//   hip_flexion_right: { pivot: 24, movable: 26 },
//   knee_flexion_left: { pivot: 25, movable: 27 },
//   knee_flexion_right: { pivot: 26, movable: 28 },
//   ankle_flexion_left: { pivot: 27, movable: 31 },
//   ankle_flexion_right: { pivot: 28, movable: 32 },
// };

const romCombinationsKeys = Object.keys(ROMCombinations) as Array<
  keyof typeof ROMCombinations
>;
const selectedROMCombination = ref<keyof typeof ROMCombinations>(
  romCombinationsKeys[0]
);
const currentIndex = ref(0);
const dropdown = ref<HTMLSelectElement | null>(null);
const romComponent = ref(null);

const { remoteKey } = useRemoteControl();

// Move to next/previous dropdown option
const changeROMSelection = (direction: number) => {
  const keys = romCombinationsKeys;
  currentIndex.value =
    (currentIndex.value + direction + keys.length) % keys.length;
  selectedROMCombination.value = keys[currentIndex.value];
};

// Reset remoteKey after handling to prevent multiple actions
const handleRemoteKey = (newKey: string | null) => {
  if (!newKey) return;

  if (newKey === "right") {
    // Select next ROM combination
    changeROMSelection(1);
  } else if (newKey === "left") {
    // Select previous ROM combination
    changeROMSelection(-1);
  } else if (newKey === "ok") {
    // Save landmarks (calls the saveLandmarks method in Rom component)
    if (romComponent.value) {
      romComponent.value.saveLandmarks();
    }
  } else if (newKey === "down") {
    // Reload the page
    window.location.reload();
  } else if (newKey === "up") {
    // Clean up
    if (romComponent.value) {
      romComponent.value.cleanup();
    }
  }

  // Reset the remoteKey to prevent unwanted page refresh
  setTimeout(() => {
    remoteKey.value = null;
  }, 100);
};

watch(remoteKey, handleRemoteKey);
</script>

<style scoped></style>
