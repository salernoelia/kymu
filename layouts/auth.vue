<template>
  <div class="h-screen overflow-y-hidden">
    <WidgetsLanguageSelector id="langselector" />

    <NuxtImg
      @click="() => navigateTo('/')"
      src="/logo/logo_kymu_blue 1.png"
    />

    <NuxtPage />
  </div>
</template>

<script lang="ts">
const localePath = useLocalePath();
</script>

<style scoped>
#langselector {
  position: absolute;
  top: 10px;
  right: 10px;
}
</style>
