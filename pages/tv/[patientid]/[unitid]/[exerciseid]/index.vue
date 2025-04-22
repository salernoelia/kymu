<!-- Exercise ID -->

<template>
  <!-- ROM combination dropdown moved from component -->
  <div class="w-full h-full flex flex-col items-start justify-start gap-2">
    <h1>Exercises will be starting shortly</h1>
    <h2>{{ tvStore.exercisesStates }}</h2>
  </div>
</template>

<script setup lang="ts">
import { ROMCombinations } from "~/shared/constants/ROMCombinations";

const route = useRoute();
const tvStore = useTVStore();

definePageMeta({
  title: "Kymu",
  layout: "television",
});
</script>

<style scoped></style>
