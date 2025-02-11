<template>
  <div class="space-y-6">
    <!-- Diff (ik its too general and will never work irl) -->
    <div>
      <label class="block text-gray-700">Difficulty</label>
      <select class="border rounded px-4 py-2 w-full focus:ring focus:ring-blue-300">
        <option value="easy">Easy</option>
        <option value="medium">Medium</option>
        <option value="hard">Hard</option>
      </select>
    </div>

    <!-- Reps -->
    <div>
      <label class="block text-gray-700">Repetition goal per game</label>
      <input type="number" placeholder="Enter repetitions"
        class="border rounded px-4 py-2 w-full focus:ring focus:ring-blue-300" />
    </div>

    <!-- time limit in mins -->
    <div>
      <label class="block text-gray-700">Time Limit (Minutes)</label>
      <input type="number" placeholder="Set time limit"
        class="border rounded px-4 py-2 w-full focus:ring focus:ring-blue-300" />
    </div>
  </div>
</template>