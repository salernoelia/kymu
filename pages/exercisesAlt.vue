<template>
  <div>
    <div class="flex flex-col space-y-8 w-full">
      <h1 class="text-2xl font-semibold mb-8">Training Configurator</h1>
      <div>
        <label class="block text-gray-700">Training Name</label>
        <input type="text" placeholder="Enter training name"
          class="border rounded py-2 w-full focus:ring focus:ring-blue-300 px-4" />
      </div>
      <div>
        <label class="block text-gray-700">Training Description</label>
        <input type="text" placeholder="Enter training description (optional)"
          class="border rounded py-2 w-full focus:ring focus:ring-blue-300 px-4" />
      </div>
      <!-- severity -->
      <div>
        <label class="block text-gray-700">Severity of Post-Stroke Effects</label>
        <select class="border rounded px-4 py-2 w-full focus:ring focus:ring-blue-300">
          <option value="mild">Mild</option>
          <option value="moderate">Moderate</option>
          <option value="severe">Severe</option>
        </select>
      </div>
      <!-- schedule -->
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-gray-700">Session Duration (Minutes)</label>
          <input type="number" placeholder="e.g. 30"
            class="border rounded px-4 py-2 w-full focus:ring focus:ring-blue-300" />
        </div>
        <div>
          <label class="block text-gray-700">Frequency (Sessions/Week)</label>
          <input type="number" placeholder="e.g. 3"
            class="border rounded px-4 py-2 w-full focus:ring focus:ring-blue-300" />
        </div>
      </div>
      <!-- patient -->
      <div>
        <label class="block text-gray-700 mb-2">Assign to Patients</label>
        <PatientDropdown :patients="patients" />
      </div>
      <!-- games-->
      <div>
        <h2 class="text-xl font-semibold mb-4">Select Game</h2>
        <GameSelection :games="games" />
      </div>
      <!-- movemenrts -->
      <div>
        <h2 class="text-xl font-semibold mb-4">Target Movements</h2>
        <MovementSelection :movements="movements" />
      </div>
      <!-- settings -->
      <div class="mt-10">
        <h2 class="text-xl font-semibold mb-4">Settings</h2>
        <GameSettings />
      </div>
      <!-- submit -->
      <div class="mt-10">
        <button class="bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 rounded-full">
          Create Personalized Training
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import jsonData from '../assets/data/data.json';

const games = ref(jsonData.games);
const movements = ref(jsonData.movements);
const patients = ref(jsonData.patients);
</script>
