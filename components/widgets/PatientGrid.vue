<template>
  <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
    <div
      v-for="p in families"
      :key="p.id"
      @click="handleClick(p)"
      class="border rounded p-4 cursor-pointer hover:shadow-lg"
    >
      <h3 class="text-lg font-semibold">
        {{ p.patient_first_name }} {{ p.patient_last_name }}
      </h3>
      <h3 class="text-lg font-semibold">
        {{ p.caregiver_first_name }} {{ p.caregiver_last_name }}
      </h3>
    </div>
  </div>
</template>

<script setup lang="ts">
const { families } = defineProps(["families"]);
const emit = defineEmits(["patientClick"]);

const handleClick = (families: any) => {
  emit("patientClick", families);
};
</script>
