<template>
  <div class="flex flex-col items-center justify-center min-h-screen p-4">
    <h1 class="text-3xl font-bold mb-4">Access Denied</h1>
    <p class="text-lg mb-6">
      You don't have permission to access the requested page.
    </p>
    <NuxtLink
      to="/"
      class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
    >
      Return to Home
    </NuxtLink>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  title: "Access Denied",
  layout: "about",
});
</script>
