<template>
  <div class="grid grid-cols-2 gap-4">
    <div v-for="game in games" :key="game.id" class="p-4 border rounded hover:bg-blue-50 cursor-pointer"
      :class="{ 'bg-blue-100': selectedGame === game.id }" @click="selectGame(game.id)">
      <img :src="game.preview" alt="Game Preview" class="w-full h-32 object-cover rounded mb-4" />
      <h3 class="font-semibold">{{ game.title }}</h3>
      <p class="text-sm text-gray-600">{{ game.description }}</p>
    </div>
  </div>
</template>

<script setup>
const { games } = defineProps(['games']);
const selectedGame = ref(null);

const selectGame = (id) => {
  selectedGame.value = id;
};
</script>