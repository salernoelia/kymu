<template>
  <div class="training-statistics">
    <h1 class="text-2xl font-semibold mb-6">Training Statistics</h1>

    <div class="statistics-container">
      <div class="dropdown-container">
        <label
          for="patient-select"
          class="block text-gray-700 mb-2"
          >Select Patient</label
        >
        <select
          id="patient-select"
          v-model="selectedPatient"
          @change="fetchPatientStats"
          class="border rounded px-4 py-2 w-full focus:ring focus:ring-blue-300"
        >
          <option
            disabled
            value=""
          >
            Select a patient
          </option>
          <option
            v-for="patient in patients"
            :key="patient.id"
            :value="patient.id"
          >
            {{ patient.name }}
          </option>
        </select>
      </div>

      <div class="statistics-content">
        <div
          v-if="statistics.length"
          class="statistics"
        >
          <div
            class="stat-item"
            v-for="stat in statistics"
            :key="stat.id"
          >
            <h2 class="font-semibold text-lg">{{ stat.title }}</h2>
            <p class="text-gray-600">{{ stat.value }}</p>
          </div>
        </div>
        <p
          v-else
          class="text-gray-500"
        >
          No statistics available for the selected patient.
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { StatsByPatient } from "~/shared/types/stats";
import type { Patient } from "~/shared/types/patient";

const patients = ref<Patient[]>([]);
const selectedPatient = ref("");
const statistics = ref([]);

const loadPatients = async () => {
  const data = await import("../../assets/data/data.json");
  if (!data.patients) {
    return;
  }
  patients.value = data.patients;
};

const fetchPatientStats = () => {
  if (!selectedPatient.value) {
    statistics.value = [];
    return;
  }

  const statsByPatient: StatsByPatient = {
    1: [
      { id: 1, title: "Total Sessions", value: 45 },
      { id: 2, title: "Average Duration", value: "30 mins" },
      { id: 3, title: "Most Practiced Movement", value: "Shoulder Flexion" },
      { id: 4, title: "Total Time Spent", value: "22 hours" },
    ],
    2: [
      { id: 1, title: "Total Sessions", value: 30 },
      { id: 2, title: "Average Duration", value: "25 mins" },
      { id: 3, title: "Most Practiced Movement", value: "Wrist Extension" },
      { id: 4, title: "Total Time Spent", value: "12 hours" },
    ],
    3: [
      { id: 1, title: "Total Sessions", value: 60 },
      { id: 2, title: "Average Duration", value: "40 mins" },
      { id: 3, title: "Most Practiced Movement", value: "Elbow Flexion" },
      { id: 4, title: "Total Time Spent", value: "30 hours" },
    ],
  };

  statistics.value = statsByPatient[selectedPatient.value] || [];
};

onMounted(() => {
  loadPatients();
});
</script>

<style scoped>
.training-statistics {
  padding: 20px;
}

.statistics-container {
  width: 600px;
  margin: 0 auto;
}

.dropdown-container {
  margin-bottom: 20px;
}

.statistics-content {
  min-height: 150px;
}

.statistics {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.stat-item {
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  width: 200px;
  text-align: center;
  background-color: #f9f9f9;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.stat-item h2 {
  margin-bottom: 0.5rem;
  color: #333;
}

.stat-item p {
  color: #555;
}
</style>
