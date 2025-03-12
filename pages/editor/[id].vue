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
        >
          <template #header>
            <div class="flex justify-between items-center">
              <h2>{{ unit.name }}</h2>
              <div class="flex flex-row gap-1">
                <Icon
                  class="icon-single cursor-pointer"
                  name="material-symbols-light:add-circle-outline-rounded"
                  @click="() => selectUnit(unit)"
                />
                <Icon
                  class="icon-single cursor-pointer"
                  name="material-symbols-light:edit-square-outline"
                  @click="() => selectUnit(unit)"
                />
              </div>
            </div>

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
              :order-position="getExercisePosition(unit, exercise.id)"
              @dragstart="handleDragStart"
              @dragend="handleDragEnd"
              @click.stop="selectExercise(exercise)"
            >
              <h2>{{ exercise.name || `Exercise ${exercise.id}` }}</h2>
            </EditorUnitExercise>
          </template>
          <div
            id="create-exercise"
            class="flex flex-col items-center justify-center border rounded p-4 cursor-pointer hover:bg-gray-300"
            @click="() => createExercise(unit.id)"
          >
            <h2>Create Exercise</h2>
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
          :supabase="supabase"
          @update="loadTrainingUnit"
        />
      </template>
      <template v-if="sidebarVariant === SidebarVariant.Unit && selectedUnit">
        <EditorSidebarUnit
          :u="selectedUnit"
          :supabase="supabase"
          @update:unit="handleUnitUpdate"
          @refresh="loadTrainingUnit"
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
const selectedUnit = ref<UnitsWithExercises | null>(null);

enum SidebarVariant {
  Exercise = "exercise",
  Unit = "unit",
}
const sidebarVariant = ref<SidebarVariant>(SidebarVariant.Exercise);

const sidebarTitle = computed(() => {
  if (sidebarVariant.value === SidebarVariant.Exercise) {
    return "Exercise Details";
  }
  if (sidebarVariant.value === SidebarVariant.Unit) {
    return "Unit Details";
  }
  return "Details";
});

const selectedPatientID = computed(() => {
  const id = route.params.id?.toString();
  return id || null;
});

// ============ Unit ============

const getExercisesForUnit = (unitId: number) => {
  const unit = units.find((u) => u.id === unitId);
  if (!unit || !unit.exercises) return [];

  // Sort exercises according to exercises_index
  if (unit.exercises_index) {
    return [...unit.exercises].sort((a, b) => {
      const aIndex = unit.exercises_index?.indexOf(a.id) ?? -1;
      const bIndex = unit.exercises_index?.indexOf(b.id) ?? -1;
      return aIndex - bIndex;
    });
  }
  return unit.exercises;
};

const getExercisePosition = (unit: UnitsWithExercises, exerciseId: number) => {
  if (!unit.exercises_index) return 0;
  return unit.exercises_index.indexOf(exerciseId);
};

const selectUnit = (unit: UnitsWithExercises) => {
  console.log("Selected unit:", unit.id);
  selectedUnit.value = unit;
  sidebarVariant.value = SidebarVariant.Unit;
  sidebarModel.value = true;
};

const handleUnitUpdate = (updatedUnit: UnitsWithExercises) => {
  const index = units.findIndex((u) => u.id === updatedUnit.id);
  if (index !== -1) {
    units[index] = { ...updatedUnit };
  }
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

const units = reactive<UnitsWithExercises[]>([]);

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
      is_template,
      exercises(*)
    `
    )
    .eq("patient_uid", selectedPatientID.value);

  if (error) {
    console.error("Error loading training units:", error);
    navigateTo(localePath(`/editor`));
    return;
  }

  if (data) {
    units.splice(0, units.length, ...data);
    console.log("Loaded training units", units);
  }
};

const createExercise = async (unitId: number) => {
  const unit = units.find((u) => u.id === unitId);
  if (!unit) {
    console.error("Unit not found");
    return;
  }

  const { data, error } = await supabase
    .from("exercises")
    .insert([
      {
        name: "New Exercise",
        default_exercise_id: 1, // Default value
        training_unit_id: unitId,
        focus_type: "strength",
        family_scene_adjustment_access: false,
        therapist_uid: supabaseUser.value?.id || "",
      },
    ])
    .select();

  if (error) {
    console.error("Error creating exercise:", error);
    return;
  }

  if (data && data[0]) {
    // Update the unit's exercises_index
    const newExerciseId = data[0].id;
    const updatedExercisesIndex = [
      ...(unit.exercises_index || []),
      newExerciseId,
    ];

    const { error: updateError } = await supabase
      .from("units")
      .update({
        exercises_index: updatedExercisesIndex,
      })
      .eq("id", unitId);

    if (updateError) {
      console.error("Error updating unit's exercises_index:", updateError);
    }
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
  sourceUnitId,
  targetUnitId,
  newPosition,
}: {
  exerciseId: number;
  sourceUnitId: number;
  targetUnitId: number;
  newPosition: number;
}) => {
  const sourceUnit = units.find((u) => u.id === sourceUnitId);
  const targetUnit = units.find((u) => u.id === targetUnitId);

  if (!sourceUnit || !targetUnit) {
    console.error("Source or target unit not found");
    return;
  }

  try {
    // 1. Remove from source unit's exercises_index
    const sourceExercisesIndex = [...(sourceUnit.exercises_index || [])];
    const exerciseIndex = sourceExercisesIndex.indexOf(exerciseId);
    if (exerciseIndex !== -1) {
      sourceExercisesIndex.splice(exerciseIndex, 1);
    }

    // 2. Add to target unit's exercises_index
    const targetExercisesIndex = [...(targetUnit.exercises_index || [])];
    targetExercisesIndex.splice(newPosition, 0, exerciseId);

    // 3. Update source unit
    if (sourceUnitId !== targetUnitId) {
      await supabase
        .from("units")
        .update({
          exercises_index: sourceExercisesIndex,
        })
        .eq("id", sourceUnitId);

      // Update the exercise's training_unit_id
      await supabase
        .from("exercises")
        .update({
          training_unit_id: targetUnitId,
        })
        .eq("id", exerciseId);
    }

    // 4. Update target unit
    await supabase
      .from("units")
      .update({
        exercises_index: targetExercisesIndex,
      })
      .eq("id", targetUnitId);

    await loadTrainingUnit();
  } catch (err) {
    console.error("Error saving position:", err);
    await loadTrainingUnit();
  } finally {
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
