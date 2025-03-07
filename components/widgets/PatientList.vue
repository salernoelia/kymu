<template>
  <ul class="space-y-4">
    <li
      v-for="patient in patients"
      :key="patient.id"
      @click="() => emits('patientClick', patient)"
      class="flex justify-between items-center border rounded p-4 cursor-pointer hover:bg-gray-100"
    >
      <div>
        <h3 class="text-lg font-semibold">{{ patient.name }}</h3>
        <p class="text-sm text-gray-600">Condition: {{ patient.condition }}</p>
      </div>
      <p class="text-sm text-gray-600">Age: {{ patient.age }}</p>
    </li>
  </ul>
</template>

<script setup lang="ts">
const props = defineProps(["patients"]);
const emits = defineEmits(["patientClick"]);
</script>
