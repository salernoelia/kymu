<script setup lang="ts">
definePageMeta({
  title: "Access Denied",
  layout: "auth",
});

const user = useSupabaseUser();
</script>

<template>
  <div>Waiting for login...</div>
</template>
