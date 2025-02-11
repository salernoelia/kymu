<template>
  <ul class="space-y-4">
    <li v-for="patient in patients" :key="patient.id" @click="handleClick(patient)"
      class="flex justify-between items-center border rounded p-4 cursor-pointer hover:bg-gray-100">
      <div>
        <h3 class="text-lg font-semibold">{{ patient.name }}</h3>
        <p class="text-sm text-gray-600">Condition: {{ patient.condition }}</p>
      </div>
      <p class="text-sm text-gray-600">Age: {{ patient.age }}</p>
    </li>
  </ul>
</template>

<script setup lang="ts">
const { patients } = defineProps(["patients"]);
const emit = defineEmits(["patientClick"]);

const handleClick = (patient) => {
  emit("patientClick", patient);
};
</script>