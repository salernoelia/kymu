<template>
  <div class="relative">
    <!-- Searchable Input -->
    <div class="flex items-center border rounded px-4 py-2 w-full focus-within:ring focus-within:ring-blue-300">
      <input type="text" v-model="search" placeholder="Search patients..." class="flex-grow focus:outline-none"
        @focus="openDropdown" />
      <!-- Dropdown Toggle Button -->
      <button @click="toggleDropdown" class="ml-2 text-gray-500 hover:text-gray-700 focus:outline-none">
        ▼
      </button>
    </div>

    <!-- Dropdown List -->
    <div v-if="showDropdown && filteredPatients.length > 0 && !assignLater"
      class="absolute z-10 bg-white border rounded shadow-md mt-1 w-full max-h-60 overflow-y-auto">
      <div v-for="patient in filteredPatients" :key="patient.id"
        class="block px-4 py-2 hover:bg-blue-100 cursor-pointer" @click="addPatient(patient)">
        {{ patient.name }}
      </div>
    </div>

    <!-- Assign Later Checkbox -->
    <div class="mt-4">
      <input type="checkbox" v-model="assignLater" class="mr-2" @change="clearPatients" />
      <span>Assign later</span>
    </div>

    <!-- Selected Patients Display -->
    <div v-if="selectedPatients.length > 0" class="mt-4">
      <h4 class="font-semibold mb-2">Assigned Patients:</h4>
      <div v-for="(patient, index) in selectedPatients" :key="index"
        class="flex items-center justify-between border rounded px-4 py-2 mb-2 bg-gray-100">
        <span>{{ patient.name }}</span>
        <button @click="removePatient(patient.id)" class="text-red-500 hover:text-red-700">
          ✕
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
const selectedPatients = ref([]);
const patients = defineProps(['patients']);

const search = ref('');
const assignLater = ref(false);
const showDropdown = ref(false);

// Filter based on query
const filteredPatients = computed(() =>
  patients.filter(
    (p) =>
      p.name.toLowerCase().includes(search.value.toLowerCase()) &&
      !selectedPatients.value.some((selected) => selected.id === p.id)
  )
);

const addPatient = (patient) => {
  if (!selectedPatients.value.find((p) => p.id === patient.id)) {
    selectedPatients.value.push(patient);
  }
  search.value = '';
  showDropdown.value = false;
};

// Rm patient from ul
const removePatient = (id) => {
  selectedPatients.value = selectedPatients.value.filter(
    (p) => p.id !== id
  );
};


const clearPatients = () => {
  if (assignLater.value) {
    selectedPatients.value = [];
    showDropdown.value = false;
  }
};

const toggleDropdown = () => {
  showDropdown.value = !showDropdown.value;
};

const openDropdown = () => {
  showDropdown.value = true;
};
</script>