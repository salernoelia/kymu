<template>
  <div>
    <div v-if="currentUser">
      <NuxtLayout>
        <NuxtPage />
      </NuxtLayout>
    </div>
    <NuxtPage v-else />
  </div>
</template>

<script setup>
import { useSupabaseUser } from '#imports';

const user = useSupabaseUser();
const currentUser = computed(() => user.value);
</script>