<template>
  <div>
    <NavigationTop />
    <PrimitivesDivider class="px-4" />
    <main class="p-6">
      <slot></slot>
    </main>
  </div>
</template>

<script setup lang="ts">
import Divider from "~/components/primitives/Divider.vue";
</script>

<style scoped></style>
