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
        @click="saveUnit"
        class="save-btn"
      >
        Save Changes
      </button>
      <button
        @click="deleteUnit"
        class="delete-btn"
      >
        Delete Unit
      </button>
    </div>

    <div class="exercises-section">
      <h2>Exercises in this unit</h2>
      <button
        @click="addExercise"
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
import { Tables, Database } from "~/shared/types/database.types";

const props = defineProps<{
  supabase: ReturnType<typeof useSupabaseClient<Database>>;
  u: Tables<"units"> & { exercises?: Tables<"exercises">[] };
}>();

const emit = defineEmits(["update:unit", "refresh"]);

const unit = reactive({ ...props.u });
const exercises = ref<Tables<"exercises">[]>([]);

onMounted(async () => {
  console.log("Unit", props.u);
  await loadExercises();
});

const loadExercises = async () => {
  const { data, error } = await props.supabase
    .from("exercises")
    .select("*")
    .eq("training_unit_id", props.u.id);

  if (error) {
    console.error("Error loading exercises:", error);
    return;
  }

  if (data && unit.exercises_index) {
    exercises.value = [...data].sort((a, b) => {
      const aIndex = unit.exercises_index?.indexOf(a.id) ?? -1;
      const bIndex = unit.exercises_index?.indexOf(b.id) ?? -1;
      return aIndex - bIndex;
    });
  } else {
    exercises.value = data || [];
  }
};

const saveUnit = async () => {
  try {
    const { error } = await props.supabase
      .from("units")
      .update({
        name: unit.name,
        description: unit.description,
      })
      .eq("id", unit.id);

    if (error) {
      console.error("Error updating unit:", error);
      return;
    }

    console.log("Unit updated successfully");
    emit("update:unit", unit);
    emit("refresh");
  } catch (err) {
    console.error("Error in saveUnit:", err);
  }
};

const deleteUnit = async () => {
  if (
    !confirm(
      "Are you sure you want to delete this unit? This will also delete all exercises in this unit."
    )
  ) {
    return;
  }

  try {
    const { error: exercisesError } = await props.supabase
      .from("exercises")
      .delete()
      .eq("training_unit_id", unit.id);

    if (exercisesError) {
      console.error("Error deleting exercises:", exercisesError);
      return;
    }

    const { error } = await props.supabase
      .from("units")
      .delete()
      .eq("id", unit.id);

    if (error) {
      console.error("Error deleting unit:", error);
      return;
    }

    console.log("Unit deleted successfully");
    emit("refresh");
  } catch (err) {
    console.error("Error in deleteUnit:", err);
  }
};

const addExercise = async () => {
  try {
    const { data, error } = await props.supabase
      .from("exercises")
      .insert({
        training_unit_id: unit.id,
        default_exercise_id: 1,
        name: "New Exercise",
        focus_type: "strength",
        family_scene_adjustment_access: false,
        therapist_uid: unit.therapist_uid,
      })
      .select();

    if (error) {
      console.error("Error adding exercise:", error);
      return;
    }

    if (data && data[0]) {
      const newExerciseId = data[0].id;
      const updatedExercisesIndex = [
        ...(unit.exercises_index || []),
        newExerciseId,
      ];

      const { error: updateError } = await props.supabase
        .from("units")
        .update({
          exercises_index: updatedExercisesIndex,
        })
        .eq("id", unit.id);

      if (updateError) {
        console.error("Error updating unit's exercises_index:", updateError);
      }
    }

    await loadExercises();
    emit("refresh");
  } catch (err) {
    console.error("Error in addExercise:", err);
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
