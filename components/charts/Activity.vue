<script setup lang="ts">
const props = defineProps({
  timePeriod: {
    type: String,
    required: true,
    validator: (value) =>
      ["since-last", "week", "month", "six-months"].includes(value),
  },
});

const graphData = computed(() => {
  switch (props.timePeriod) {
    case "six-months":
    case "week":
    case "month":
    case "since-last":
    default:
      return [];
  }
});
</script>

<template>
  <div class="w-full">
    <div class="text-center">Graph for: {{ timePeriod }}</div>
  </div>
</template>
