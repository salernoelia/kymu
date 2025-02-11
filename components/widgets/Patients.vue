<template>
  <div class="container mx-auto p-6">
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-semibold">Patients</h1>

      <div>
        <button @click="setView('list')" :class="getButtonClass('list')" class="px-4 py-2 rounded-l border">
          List View
        </button>
        <button @click="setView('grid')" :class="getButtonClass('grid')" class="px-4 py-2 rounded-r border">
          Grid View
        </button>
      </div>
    </div>

    <!-- views -->
    <div v-if="view === 'list'">
      <PatientList :patients="patients" @patientClick="showDetails" />
    </div>
    <div v-else-if="view === 'grid'">
      <PatientGrid :patients="patients" @patientClick="showDetails" />
    </div>

    <!-- popup -->
    <PatientDetails v-if="selectedPatient" :patient="selectedPatient" @close="closeDetails" />
  </div>
</template>

<script setup lang="ts">
import jsonData from '~/assets/data/data.json';
const patients = ref(jsonData.patients);


const view = ref("list");
const selectedPatient = ref(null);


const setView = (newView) => {
  view.value = newView;
};


const showDetails = (patient) => {
  selectedPatient.value = patient;
};

const closeDetails = () => {
  selectedPatient.value = null;
};

const getButtonClass = (targetView) => {
  return view.value === targetView ? "bg-blue-500 text-white" : "bg-white text-gray-700";
};
</script>