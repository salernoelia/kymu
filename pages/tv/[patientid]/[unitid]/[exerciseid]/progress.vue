<template>
  <div>
    {{ tvStore.currentUnit }}
  </div>
</template>

<script setup lang="ts">
const tvStore = useTVStore();

definePageMeta({
  title: "Kymu",
  layout: "television",
});
</script>

<style scoped></style>
