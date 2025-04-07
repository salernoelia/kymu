<template>
  <div class="h-screen overflow-y-hidden">
    <WidgetsLanguageSelector id="langselector" />

    <NuxtImg src="/logo/logo_kymu_blue 1.png" />

    <NuxtPage />
  </div>
</template>

<style scoped>
#langselector {
  position: absolute;
  top: 10px;
  right: 10px;
}
</style>
