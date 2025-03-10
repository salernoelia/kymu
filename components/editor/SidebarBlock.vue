<template>
  <div id="container">
    <div class="field">
      <label>Block Name</label>
      <input
        type="text"
        v-model="block.name"
        placeholder="Block name"
      />
    </div>

    <div class="field">
      <label>Description</label>
      <textarea
        v-model="block.description"
        placeholder="Block description"
        rows="3"
      ></textarea>
    </div>

    <div class="field"></div>

    <div class="actions">
      <button
        @click="saveBlock"
        class="save-btn"
      >
        Save Changes
      </button>
      <button
        @click="deleteBlock"
        class="delete-btn"
      >
        Delete Block
      </button>
    </div>

    <div class="exercises-section">
      <h2>Exercises in this block</h2>
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
        No exercises in this block
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  supabase: ReturnType<typeof useSupabaseClient>;
  b: Tables<"training_blocks">;
}>();

const emit = defineEmits(["update:block", "refresh"]);

const block = reactive({ ...props.b });
const exercises = ref<Tables<"training_block_exercises">[]>([]);

onMounted(async () => {
  console.log("Block", props.b);
  await loadExercises();
});

const loadExercises = async () => {
  const { data, error } = await props.supabase
    .from("training_block_exercises")
    .select("*")
    .eq("training_block_id", props.b.id)
    .order("order_position");

  if (error) {
    console.error("Error loading exercises:", error);
    return;
  }

  exercises.value = data || [];
};

const saveBlock = async () => {
  try {
    const { error } = await props.supabase
      .from("training_blocks")
      .update({
        name: block.name,
        description: block.description,
      })
      .eq("id", block.id);

    if (error) {
      console.error("Error updating block:", error);
      return;
    }

    console.log("Block updated successfully");
    emit("update:block", block);
    emit("refresh");
  } catch (err) {
    console.error("Error in saveBlock:", err);
  }
};

const deleteBlock = async () => {
  if (
    !confirm(
      "Are you sure you want to delete this block? This will also delete all exercises in this block."
    )
  ) {
    return;
  }

  try {
    const { error: exercisesError } = await props.supabase
      .from("training_block_exercises")
      .delete()
      .eq("training_block_id", block.id);

    if (exercisesError) {
      console.error("Error deleting exercises:", exercisesError);
      return;
    }

    const { error } = await props.supabase
      .from("training_blocks")
      .delete()
      .eq("id", block.id);

    if (error) {
      console.error("Error deleting block:", error);
      return;
    }

    console.log("Block deleted successfully");
    emit("refresh");
  } catch (err) {
    console.error("Error in deleteBlock:", err);
  }
};

const addExercise = async () => {
  try {
    const nextPosition =
      exercises.value.length > 0
        ? Math.max(...exercises.value.map((e) => e.order_position)) + 1
        : 1;

    const { data, error } = await props.supabase
      .from("training_block_exercises")
      .insert({
        training_block_id: block.id,
        training_unit_id: block.training_unit_id,
        default_exercise_id: 1, // Default value - you may want to have this as a parameter
        name: "New Exercise",
        order_position: nextPosition,
        focus_type: "strength",
        family_scene_adjustment_access: false,
        therapist_uid: block.therapist_uid,
      })
      .select();

    if (error) {
      console.error("Error adding exercise:", error);
      return;
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
