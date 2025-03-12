<template>
  <div>
    <h1>{{ $t("unit-editor-title") }}</h1>
    <h3>{{ $t("unit-editor-description") }}</h3>
    <div>
      <div
        id="exercises"
        class="flex flex-row gap-4 overflow-x-auto"
      >
        <EditorUnit
          v-for="unit in units"
          :key="unit.id"
          :id="unit.id"
          :exercises="getExercisesForUnit(unit.id)"
          @drop="handleExerciseDrop"
          @click="() => selectunit(unit)"
        >
          <template #header>
            <h1>{{ unit.name }}</h1>
            <p>{{ unit.description }}</p>
          </template>
          <template
            v-for="exercise in getExercisesForUnit(unit.id)"
            :key="exercise.id"
            #[`exercise-${exercise.id}`]
          >
            <EditorUnitExercise
              :id="exercise.id"
              :unit-id="unit.id"
              :order-position="exercise.order_position"
              @dragstart="handleDragStart"
              @dragend="handleDragEnd"
              @click.stop="selectExercise(exercise)"
            >
              <h2>Exercise: {{ exercise.id }}</h2>
            </EditorUnitExercise>
          </template>
          <div
            id="create-exercise"
            class="flex flex-col items-center justify-center border rounded p-4 cursor-pointer hover:bg-gray-300"
            @click="createExercise"
          >
            <h2>Create Unit</h2>
          </div>
        </EditorUnit>
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

const selectedPatientID = computed(() => {
  const id = route.params.id?.toString();
  return id || null;
});

// ============ Unit ============

const getExercisesForUnit = (unitId: number) => {
  return units.find((u) => u.id === unitId)?.exercises || [];
};

// ============ Exercise ============

const selectExercise = (e: Tables<"exercises">) => {
  console.log("Selected exercise:", e.id);
  selectedExercise.value = e;
  sidebarVariant.value = SidebarVariant.Exercise;
  sidebarModel.value = true;
};

interface UnitsWithExercises extends Tables<"units"> {
  exercises: Tables<"exercises">[];
}

const units = reactive<UnitsWithExercises[]>([
  {
    id: 0,
    name: "",
    description: "",
    patient_uid: "",
    therapist_uid: "",
    exercises: [] as Tables<"exercises">[],
    map: function (
      arg0: (unit: Tables<"units">) => {
        title: string;
        description: string | null;
      }
    ): unknown {
      throw new Error("Function not implemented.");
    },
    created_at: "",
    exercises_index: null,
    is_template: false,
  },
]);

const draggingExercise = ref(null);
const dragInProgress = ref(false);
provide("dragInProgress", dragInProgress);
provide("draggingExerciseData", draggingExercise);

onMounted(async () => {
  await loadTrainingUnit();
});

const loadTrainingUnit = async () => {
  if (!selectedPatientID.value) {
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
      exercises_index,
      exercises(*)
    `
    )
    .eq("patient_uid", selectedPatientID.value);

  if (error) {
    console.error("Error loading training unit:", error);
    navigateTo(localePath(`/editor`));
    return;
  }

  if (data) {
    Object.assign(units, data);
    console.log("Loaded training unit", units);
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
