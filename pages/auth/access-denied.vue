<template>
  <div class="flex flex-col items-center justify-center h-full gap-4">
    <h1 class="text-3xl font-bold mb-4">
      {{ $t("access-denied") }}
    </h1>
    <p class="text-lg">
      {{ $t("access-denied-message") }}
    </p>
    <div class="flex flex-row gap-4">
      <PrimitivesButton @click="navigateTo(localePath('/'))">
        {{ $t("go-home") }}
      </PrimitivesButton>

      <PrimitivesButton @click="navigateTo(localePath('/auth/login'))">
        {{ $t("login") }}
      </PrimitivesButton>
    </div>
  </div>
</template>

<script setup lang="ts">
const localePath = useLocalePath();

definePageMeta({
  title: "Access Denied",
  layout: "auth",
});
</script>
