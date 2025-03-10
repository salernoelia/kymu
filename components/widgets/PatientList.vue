<template>
  <ul class="space-y-4">
    <li
      v-for="p in families"
      :key="p.id"
      @click="() => emits('patientClick', p)"
      class="flex justify-between items-center border rounded p-4 cursor-pointer hover:bg-gray-100"
    >
      <div>
        <h3 class="text-lg font-semibold">
          Patient {{ p.patient_first_name }} {{ p.patient_last_name }}
        </h3>
        <h3 class="text-lg font-semibold">
          Caregiver: {{ p.caregiver_first_name }} {{ p.caregiver_last_name }}
        </h3>
      </div>
    </li>
  </ul>
</template>

<script setup lang="ts">
const props = defineProps(["families"]);
const emits = defineEmits(["patientClick"]);
</script>
