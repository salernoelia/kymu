<template>
  <div class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
    <div class="bg-white p-6 rounded shadow-lg w-96">
      <h2 class="text-xl font-semibold mb-4">Patient Details</h2>
      <p><strong>Name:</strong> {{ patient.name }}</p>
      <p><strong>Age:</strong> {{ patient.age }}</p>
      <p><strong>Condition:</strong> {{ patient.condition }}</p>

      <div class="mt-6 flex justify-end">
        <button @click="close" class="bg-red-500 hover:bg-red-700 text-white px-4 py-2 rounded">
          Close
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { patient } = defineProps(["patient"]);
const emit = defineEmits(["close"]);

const close = () => {
  emit("close");
};
</script>