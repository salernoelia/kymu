<template>
  <div class="flex items-center justify-between p-4 w-full">
    <div class="flex items-center w-1/3 jusify-start">
      <img
        src="/logo/logo_kymu_text.png"
        alt="Kymu Logo"
        class="w-auto h-10"
      />
    </div>

    <div class="flex items-center gap-4 w-1/3 justify-end">
      <!-- <WidgetsLanguageSelector /> -->
      <UserAvatar />
    </div>
  </div>
</template>

<script setup lang="ts">
const localePath = useLocalePath();
</script>

<style scoped lang="scss">
.nav-link {
  display: flex;
  color: var(--color-Gray-500);
  font-size: 1rem;

  &:hover {
    background-color: var(--color-grey-400);
  }
}

.router-link-active {
  color: var(--color-primary);
}
</style>
