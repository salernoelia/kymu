<template>
  <div class="card flex flex-row justify-between items-center">
    <div class="left">
      <h2>
        {{ name }}
      </h2>
      <h3>
        {{ description }}
      </h3>
    </div>
    <div class="right">
      <h1>:</h1>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps({
  name: {
    type: String,
    default: "Title",
  },
  description: {
    type: String,
    default: "",
  },
});

console.log("Title", props.name, props.description);
</script>

<style scoped></style>
