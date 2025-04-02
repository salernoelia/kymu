<script setup lang="ts">
const props = defineProps<{
  timePeriod: TimePeriod;
}>();

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
