<template>
  <div id="container">
    <div class="field">
      <label>Unit Name</label>
      <input
        type="text"
        v-model="unit.name"
        placeholder="Unit name"
      />
    </div>

    <div class="field">
      <label>Description</label>
      <textarea
        v-model="unit.description"
        placeholder="Unit description"
        rows="3"
      ></textarea>
    </div>

    <div class="actions">
      <button
        @click="store.saveUnit(unit)"
        class="save-btn"
      >
        Save Changes
      </button>
      <button
        @click="store.deleteUnit(unit.id)"
        class="delete-btn"
      >
        Delete Unit
      </button>
    </div>

    <div class="exercises-section">
      <h2>Exercises in this unit</h2>
      <button
        @click="store.createExercise(unit.id)"
        class="add-btn"
      >
        Add Exercise
      </button>

      <div
        v-if="exercises.length > 0"
        class="exercises-list"
      >
        <div
          v-for="exercise in exercises"
          :key="exercise.id"
          class="exercise-item"
        >
          {{ exercise.name || `Exercise ${exercise.id}` }}
        </div>
      </div>
      <div
        v-else
        class="no-exercises"
      >
        No exercises in this unit
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const store = useEditorStore();
const unit = reactive({ ...store.selectedUnit! });
const exercises = computed(() => store.getExercisesForUnit(unit.id));
</script>

<style scoped>
#container {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  padding: 1rem;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

label {
  font-weight: bold;
  font-size: 0.9rem;
}

input,
textarea {
  padding: 0.75rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 1rem;
}

.actions {
  display: flex;
  gap: 1rem;
  margin-top: 1rem;
}

button {
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.2s;
}

.save-btn {
  color: rgb(0, 0, 0);
  border: none;
}

.save-btn:hover {
  background-color: #3e8e41;
}

.delete-btn {
  color: rgb(0, 0, 0);
  border: none;
}

.delete-btn:hover {
  background-color: #d32f2f;
}

.add-btn {
  background-color: #2196f3;
  color: white;
  border: none;
  margin-top: 0.5rem;
}

.add-btn:hover {
  background-color: #0b7dda;
}

.exercises-section {
  margin-top: 1rem;
  border-top: 1px solid #eee;
  padding-top: 1rem;
}

.exercises-list {
  margin-top: 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.exercise-item {
  padding: 0.75rem;
  border: 1px solid #eee;
  border-radius: 4px;
  background-color: #f9f9f9;
}

.no-exercises {
  margin-top: 1rem;
  color: #666;
  font-style: italic;
}
</style>
