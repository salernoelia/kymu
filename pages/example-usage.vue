<script setup lang="ts">
import { Calendar } from "@/components/ui/calendar";
import { toZonedDateTime } from "reka-ui"; // Import the correct conversion function
import { ref } from "vue";

const markedDates = ref([
  toZonedDateTime(new Date(2023, 6, 15)),
  toZonedDateTime(new Date(2023, 6, 20)),
]);
</script>

<template>
  <Calendar :marked-dates="markedDates" />
</template>
