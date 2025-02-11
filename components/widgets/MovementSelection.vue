<template>
  <div class="grid grid-cols-2 gap-4">
    <label v-for="movement in movements" :key="movement.id" class="flex items-center space-x-2 cursor-pointer">
      <input type="checkbox" :value="movement.name" v-model="selectedMovements" />
      <span>{{ movement.name }}</span>
    </label>
  </div>
</template>

<script setup>
const { movements } = defineProps(['movements']);
const selectedMovements = ref([]);
</script>