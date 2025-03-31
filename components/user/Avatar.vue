<template>
  <div
    v-if="user?.email"
    class="avatar"
  >
    {{ user?.email[0]?.toUpperCase() }}
  </div>
</template>

<script setup lang="ts">
const user = useSupabaseUser();
</script>

<style scoped>
.avatar {
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--color-Primary);
  color: var(--color-Gray-100);
  border-radius: 20%;
  font-size: 1.5rem;

  height: 2.5rem;
  aspect-ratio: 1;
}
</style>
