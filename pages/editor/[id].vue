<template>
  <div>
    <h1>Unit Editor for unit {{ unit.name }}</h1>
    <h3>{{ unit.description }}</h3>
    <div class="unit-blocks">
      <EditorUnitBlock
        v-for="block in unit.training_blocks"
        :key="block.id"
      >
        <h1>{{ block.name }}</h1>
        <p>{{ block.description }}</p>
        <EditorExercise
          v-for="exercise in unit.training_block_exercises.filter(
            (ex) => ex.training_block_id === block.id
          )"
          :key="exercise.id"
        >
          <h2>Exercise: {{ exercise.id }}</h2>
        </EditorExercise>
      </EditorUnitBlock>
    </div>
  </div>
</template>

<script setup lang="ts">
const localePath = useLocalePath();
const route = useRoute();
const supabase = useSupabaseClient();
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

  console.log(data);

  if (error) {
    console.error("Error loading training unit:", error);
    navigateTo(localePath(`/editor`));
    return;
  }

  if (data) {
    Object.assign(unit, data);
  }
};
</script>

<style scoped lang="scss">
.unit-blocks {
  display: flex;
  flex-direction: row;
  gap: 1rem;
  overflow-x: auto;
}
</style>
