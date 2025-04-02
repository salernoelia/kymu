<template>
  <div class="flex flex-col items-center justify-center h-full gap-4 mt-20">
    <h1 class="text-3xl font-bold mb-4">
      {{ $t("access-denied") }}
    </h1>
    <p class="text-lg">
      {{ $t("access-denied-message") }}
    </p>
    <PrimitivesButton @click="navigateTo(localePath('/'))">
      {{ $t("go-home") }}
    </PrimitivesButton>
  </div>
</template>

<script setup lang="ts">
const localePath = useLocalePath();

definePageMeta({
  title: "Access Denied",
  layout: "auth",
});
</script>
