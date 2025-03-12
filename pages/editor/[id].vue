<template>
  <div>
    <h1>Unit Editor for unit {{ unit.name }}</h1>
    <h3>{{ unit.description }}</h3>
    <div>
      <div
        id="exercises"
        class="flex flex-row gap-4 overflow-x-auto"
      >
        <EditorUnitExercise
          v-for="exercise in unit.exercises"
          :key="exercise.id"
          :id="exercise.id"
          :block-id="unit.id"
          :order-position="exercise.order_position"
          @dragstart="handleDragStart"
          @dragend="handleDragEnd"
          @click.stop="selectExercise(exercise)"
        >
          <h2>Exercise: {{ exercise.id }}</h2>
        </EditorUnitExercise>
      </div>

      <div
        id="create-exercise"
        class="flex flex-col items-center justify-center border rounded p-4 cursor-pointer hover:bg-gray-300"
        @click="createExercise"
      >
        <h2>Create Exercise</h2>
      </div>
    </div>
    <EditorSidebar
      v-model="sidebarModel"
      :title="sidebarTitle"
      width="400px"
    >
      <template
        v-if="sidebarVariant === SidebarVariant.Exercise && selectedExercise"
      >
        <EditorSidebarExercise
          :e="selectedExercise"
          :supabase
          @update="loadTrainingUnit"
        />
      </template>
    </EditorSidebar>
  </div>
</template>

<script setup lang="ts">
const supabaseUser = useSupabaseUser();
const localePath = useLocalePath();
const route = useRoute();
const supabase = useSupabaseClient<Database>();
const { updateExercisePosition } = useTrainingUnitMovable();
const sidebarModel = ref(false);
const selectedExercise = ref<Tables<"exercises"> | null>(null);

enum SidebarVariant {
  Exercise = "exercise",
}
const sidebarVariant = ref<SidebarVariant>(SidebarVariant.Exercise);

const sidebarTitle = computed(() => {
  if (sidebarVariant.value === SidebarVariant.Exercise) {
    return "Exercise Details";
  }
  return "Details";
});

const selectedUnitID = computed(() => {
  const id = Number(route.params.id);
  return isNaN(id) ? null : id;
});

// ============ Exercise ============

const selectExercise = (e: Tables<"exercises">) => {
  console.log("Selected exercise:", e.id);
  selectedExercise.value = e;
  sidebarVariant.value = SidebarVariant.Exercise;
  sidebarModel.value = true;
};

const unit = reactive({
  id: 0,
  name: "",
  description: "",
  patient_uid: "",
  therapist_uid: "",
  exercises: [] as Tables<"exercises">[],
});

const draggingExercise = ref(null);
const dragInProgress = ref(false);
provide("dragInProgress", dragInProgress);
provide("draggingExerciseData", draggingExercise);

onMounted(async () => {
  await loadTrainingUnit();
});

const loadTrainingUnit = async () => {
  if (!selectedUnitID.value) {
    navigateTo(localePath(`/editor`));
    return;
  }

  const { data, error } = await supabase
    .from("units")
    .select(
      `
      id, 
      created_at, 
      name, 
      description, 
      patient_uid, 
      therapist_uid, 
      exercises(*)
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
    if (data.exercises) {
      data.exercises.sort((a, b) => a.order_position - b.order_position);
    }

    Object.assign(unit, data);

    if (selectedExercise.value) {
      const updatedExercise = unit.exercises.find(
        (e) => e.id === selectedExercise.value?.id
      );
      selectedExercise.value = updatedExercise || null;
    }
  }
};

const createExercise = async () => {
  const { data, error } = await supabase
    .from("exercises")
    .insert([
      {
        name: "New Exercise",
        description: "New Exercise Description",
        unit_id: unit.id,
        order_position: unit.exercises.length + 1,
        therapist_uid: supabaseUser.value?.id || "",
      },
    ])
    .select();

  if (error) {
    console.error("Error creating exercise:", error);
    return;
  }

  await loadTrainingUnit();
};

// ============ Drag and Drop ============

const handleDragStart = (data: any) => {
  draggingExercise.value = data;
  dragInProgress.value = true;
};

const handleDragEnd = () => {
  draggingExercise.value = null;
  dragInProgress.value = false;
};

const handleExerciseDrop = async ({
  exerciseId,
  newPosition,
}: {
  exerciseId: number;
  newPosition: number;
}) => {
  const result = await updateExercisePosition(unit, exerciseId, newPosition);

  if (!result) return;

  try {
    const { error } = await supabase
      .from("exercises")
      .update({
        order_position: newPosition,
      })
      .eq("id", exerciseId);

    if (error) {
      console.error("Error updating exercise position:", error);
      await loadTrainingUnit();
    }
    dragInProgress.value = false;
  } catch (err) {
    console.error("Error saving position:", err);
    await loadTrainingUnit();
    dragInProgress.value = false;
  }
};
</script>

<style scoped lang="scss">
#exercises {
  display: flex;
  flex-direction: row;
  gap: 1rem;
  overflow-x: auto;
  max-width: 100%;
}
</style>
