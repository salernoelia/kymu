<template>
  <div id="container">
    <input
      type="text"
      :placeholder="e.name"
      v-model="exercise.name"
    />

    <!-- select repetition or duration goal -->
    <div id="goal">
      <label>Goal</label>
      <select v-model="exercise.focus_type">
        <option :value="e.focus_type">{{ e.focus_type }}</option>
        <option value="duration">Duration</option>
        <option value="repetitions">Repetitions</option>
      </select>
    </div>

    <div
      v-if="e.duration_seconds_goal"
      id="duration"
    >
      <label>Duration</label>
      <input
        type="number"
        :placeholder="e.duration_seconds_goal.toString()"
        v-model="exercise.duration_seconds_goal"
      />
    </div>

    <div
      v-if="e.repetitions_goal"
      id="repetitions"
    >
      <label>Repetitions</label>
      <input
        type="number"
        :placeholder="e.repetitions_goal.toString()"
        v-model="exercise.repetitions_goal"
      />
    </div>

    <label>Focus Type</label>
    <select v-model="exercise.focus_type">
      <option :value="e.focus_type">{{ e.focus_type }}</option>
      <option value="strength">Strength</option>
      <option value="endurance">Endurance</option>
      <option value="balance">Balance</option>
      <option value="flexibility">Flexibility</option>
    </select>

    <label>Family Scene Adjustment Access</label>
    <input
      type="checkbox"
      v-model="exercise.family_scene_adjustment_access"
    />

    <button @click="saveExercise">Save</button>

    <button @click="deleteExercise">Delete</button>
  </div>
</template>

<!-- 
interface TrainingBlockExercise {
  id: number;
  created_at: string;
  training_block_id: number;
  default_exercise_id: number;
  duration_seconds_goal: number;
  repetition_goal: number;
  focus_type: string;
  family_scene_adjustment_access: boolean;
  [key: string]: any;
} -->

<script setup lang="ts">
const supabase = useSupabaseClient();

const props = defineProps<{
  e: TrainingBlockExercise;
}>();

onMounted(() => {
  console.log("Exercise", props.e);
});
const exercise = reactive<TrainingBlockExercise>(props.e);

const saveExercise = () => {
  console.log("Saving exercise");
};

const deleteExercise = async () => {
  const { error } = await supabase
    .from("training_block_exercises")
    .delete()
    .eq("id", exercise.id);

  if (error) {
    console.error("Error deleting exercise", error);
    return;
  }

  console.log("Exercise deleted");
};
</script>

<style scoped>
#container {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
</style>
