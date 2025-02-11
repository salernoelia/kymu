<template>
  <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
    <div v-for="patient in patients" :key="patient.id" @click="handleClick(patient)"
      class="border rounded p-4 cursor-pointer hover:shadow-lg">
      <h3 class="text-lg font-semibold">{{ patient.name }}</h3>
      <p class="text-sm text-gray-600">Age: {{ patient.age }}</p>
      <p class="text-sm text-gray-600">Condition: {{ patient.condition }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
const { patients } = defineProps(["patients"]);
const emit = defineEmits(["patientClick"]);

const handleClick = (patient) => {
  emit("patientClick", patient);
};
</script>