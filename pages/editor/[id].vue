<template>
  <div>
    <h1>Unit Editor for unit {{ unit.name }}</h1>
    <h3>{{ unit.description }}</h3>
    <div class="unit-blocks">
      <EditorUnitBlock
        v-for="block in unit.training_blocks"
        :key="block.id"
        :id="block.id"
        :exercise-count="getExercisesForBlock(block.id).length"
        @drop="handleExerciseDrop"
      >
        <template #header>
          <h1>{{ block.name }}</h1>
          <p>{{ block.description }}</p>
        </template>

        <template #exercises>
          <EditorUnitExercise
            v-for="exercise in getExercisesForBlock(block.id)"
            :key="exercise.id"
            :id="exercise.id"
            :block-id="block.id"
            :order-position="exercise.order_position"
            @dragstart="handleDragStart"
            @dragend="handleDragEnd"
          >
            <h2>Exercise: {{ exercise.id }}</h2>
          </EditorUnitExercise>
        </template>
      </EditorUnitBlock>
    </div>
  </div>
</template>

<script setup lang="ts">
const localePath = useLocalePath();
const route = useRoute();
const supabase = useSupabaseClient();
const { updateExercisePosition } = useTrainingUnitMovable();

const selectedUnitID = computed(() => {
  const id = Number(route.params.id);
  return isNaN(id) ? null : id;
});

const unit = reactive<TrainingUnit>({
  id: 0,
  name: "",
  description: "",
  created_at: "",
  patient_uid: "",
  therapist_uid: "",
  training_blocks: [],
  training_block_exercises: [],
});

const draggingExercise = ref(null);

onMounted(async () => {
  await loadTrainingUnit();
});

const loadTrainingUnit = async () => {
  if (!selectedUnitID.value) {
    navigateTo(localePath(`/editor`));
    return;
  }

  const { data, error } = await supabase
    .from("training_units")
    .select(
      `
      id, 
      created_at, 
      name, 
      description, 
      patient_uid, 
      therapist_uid, 
      training_blocks(*),
      training_block_exercises(*)
    `
    )
    .eq("id", selectedUnitID.value)
    .single();

  if (error) {
    console.error("Error loading training unit:", error);
    navigateTo(localePath(`/editor`));
    return;
  }

  if (data) {
    // Sort exercises by order_position
    if (data.training_block_exercises) {
      data.training_block_exercises.sort(
        (a, b) => a.order_position - b.order_position
      );
    }

    Object.assign(unit, data);
  }
};

// Helper to get exercises for a specific block, sorted by position
const getExercisesForBlock = (blockId) => {
  return unit.training_block_exercises
    .filter((ex) => ex.training_block_id === blockId)
    .sort((a, b) => a.order_position - b.order_position);
};

const handleDragStart = (data) => {
  draggingExercise.value = data;
};

const handleDragEnd = () => {
  draggingExercise.value = null;
};

const handleExerciseDrop = async ({
  exerciseId,
  sourceBlockId,
  targetBlockId,
  newPosition,
}) => {
  // Update the local UI state
  const result = await updateExercisePosition(
    unit,
    exerciseId,
    targetBlockId,
    newPosition
  );

  if (!result) return;

  // Send the update to the server
  try {
    const { error } = await supabase
      .from("training_block_exercises")
      .update({
        training_block_id: targetBlockId,
        order_position: newPosition,
      })
      .eq("id", exerciseId);

    if (error) {
      console.error("Error updating exercise position:", error);
      // Reload the unit to restore the correct state
      await loadTrainingUnit();
    }
  } catch (err) {
    console.error("Error saving position:", err);
    await loadTrainingUnit();
  }
};
</script>

<style scoped lang="scss">
.unit-blocks {
  display: flex;
  flex-direction: row;
  gap: 1rem;
  overflow-x: auto;
  padding: 1rem 0;
}
</style>
