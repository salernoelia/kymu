<script setup lang="ts">
definePageMeta({
  title: "Access Denied",
  layout: "auth",
});

const user = useSupabaseUser();

watch(
  user,
  () => {
    if (user.value) {
      return navigateTo("/");
    }
  },
  { immediate: true }
);
</script>

<template>
  <div>Waiting for login...</div>
</template>
