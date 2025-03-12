<template>
  <div id="container">
    <div class="field">
      <label>Exercise Name</label>
      <input
        type="text"
        v-model="exercise.name"
        placeholder="Exercise name"
      />
    </div>

    <div class="field">
      <label>Focus Type</label>
      <select v-model="exercise.focus_type">
        <option value="strength">Strength</option>
        <option value="mobility">Mobility</option>
        <option value="balance">Balance</option>
        <option value="coordination">Coordination</option>
      </select>
    </div>

    <div class="field">
      <label>Repetitions Goal</label>
      <input
        type="number"
        v-model="exercise.repetitions_goal"
        min="1"
      />
    </div>

    <div class="field">
      <label>Duration Goal (seconds)</label>
      <input
        type="number"
        v-model="exercise.duration_seconds_goal"
        min="1"
      />
    </div>

    <div class="field">
      <label>
        <input
          type="checkbox"
          v-model="exercise.family_scene_adjustment_access"
        />
        Allow family scene adjustment
      </label>
    </div>

    <div class="actions">
      <button
        @click="saveExercise"
        class="save-btn"
      >
        Save Changes
      </button>
      <button
        @click="deleteExercise"
        class="delete-btn"
      >
        Delete Exercise
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  supabase: ReturnType<typeof useSupabaseClient<Database>>;
  e: Tables<"exercises">;
}>();

const emit = defineEmits(["update"]);

const exercise = reactive({ ...props.e });

onMounted(() => {
  console.log("Exercise", props.e);
});

const saveExercise = async () => {
  try {
    const { error } = await props.supabase
      .from("exercises")
      .update({
        name: exercise.name,
        focus_type: exercise.focus_type,
        duration_seconds_goal: exercise.duration_seconds_goal,
        repetitions_goal: exercise.repetitions_goal,
        family_scene_adjustment_access: exercise.family_scene_adjustment_access,
      })
      .eq("id", exercise.id);

    if (error) {
      console.error("Error updating exercise:", error);
      return;
    }

    console.log("Exercise updated successfully");
    emit("update");
  } catch (err) {
    console.error("Error in saveExercise:", err);
  }
};

const deleteExercise = async () => {
  if (!confirm("Are you sure you want to delete this exercise?")) {
    return;
  }

  try {
    const { data: unitData } = await props.supabase
      .from("units")
      .select("id, exercises_index")
      .eq("id", exercise.training_unit_id)
      .single();

    if (unitData) {
      const updatedExercisesIndex = [...(unitData.exercises_index || [])];
      const indexToRemove = updatedExercisesIndex.indexOf(exercise.id);
      if (indexToRemove !== -1) {
        updatedExercisesIndex.splice(indexToRemove, 1);

        await props.supabase
          .from("units")
          .update({
            exercises_index: updatedExercisesIndex,
          })
          .eq("id", unitData.id);
      }
    }

    // Now delete the exercise
    const { error } = await props.supabase
      .from("exercises")
      .delete()
      .eq("id", props.e.id);

    if (error) {
      console.error("Error deleting exercise", error);
      return;
    }

    console.log("Exercise deleted");
    emit("update");
  } catch (err) {
    console.error("Error in deleteExercise:", err);
  }
};
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
textarea,
select {
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
  background-color: #4caf50;
  color: white;
  border: none;
}

.save-btn:hover {
  background-color: #3e8e41;
}

.delete-btn {
  background-color: #f44336;
  color: white;
  border: none;
}

.delete-btn:hover {
  background-color: #d32f2f;
}

/* Checkbox specific styling */
input[type="checkbox"] {
  width: auto;
  margin-right: 8px;
  padding: 0;
}

.field label:has(input[type="checkbox"]) {
  display: flex;
  align-items: center;
  font-weight: normal;
}
</style>
