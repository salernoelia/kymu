<template>
  <div
    id="container"
    :class="[focus ? 'bg-blue-500' : 'bg-gray-200']"
  >
    <h1>{{ title }}</h1>
    <p>{{ description }}</p>
  </div>
</template>

<script setup lang="ts">
const props = defineProps({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  focus: {
    type: Boolean,
    default: false,
  },
});
</script>

<style scoped>
#container {
  background: linear-gradient(118deg, #f0f8ff 30%, #f5f5f5 60%, #f0f8ff 90%);
  background-size: 150% 150%;
  animation: gradientAnimation 15s ease infinite;
  padding: 20px;
  border-radius: 10px;
  height: 500px;
  width: 300px;
  display: flex;
  flex-direction: column;
}

#container.bg-blue-500 {
  border: 5px solid var(--color-Exclamation);
}
</style>
