<template>
  <div>
    <h1>Unit Editor for unit {{ unit.name }}</h1>
    <h3>{{ unit.description }}</h3>
    <div>
      <div
        id="blocks"
        class="flex flex-row gap-4 overflow-x-auto"
      >
        <EditorUnitBlock
          v-for="block in unit.blocks"
          :key="block.id"
          :id="block.id"
          :exercises="getExercisesForBlock(block.id)"
          @drop="handleExerciseDrop"
          @click="() => selectBlock(block)"
        >
          <template #header>
            <h1>{{ block.name }}</h1>
            <p>{{ block.description }}</p>
          </template>

          <template
            v-for="exercise in getExercisesForBlock(block.id)"
            :key="exercise.id"
            #[`exercise-${exercise.id}`]
          >
            <EditorUnitExercise
              :id="exercise.id"
              :block-id="block.id"
              :order-position="exercise.order_position"
              @dragstart="handleDragStart"
              @dragend="handleDragEnd"
              @click.stop="selectExercise(exercise)"
            >
              <h2>Exercise: {{ exercise.id }}</h2>
            </EditorUnitExercise>
          </template>
        </EditorUnitBlock>
      </div>

      <div
        id="create-block"
        class="flex flex-col items-center justify-center border rounded p-4 cursor-pointer hover:bg-gray-300"
        @click="createBlock"
      >
        <h2>Create block</h2>
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
      <template
        v-else-if="sidebarVariant === SidebarVariant.Block && selectedBlock"
      >
        <EditorSidebarBlock
          :b="selectedBlock"
          :supabase
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
const selectedExercise = ref<Tables<"block_exercises"> | null>(null);
const selectedBlock = ref<Tables<"blocks"> | null>(null);

enum SidebarVariant {
  Exercise = "exercise",
  Block = "block",
}
const sidebarVariant = ref<SidebarVariant>(SidebarVariant.Exercise);

const sidebarTitle = computed(() => {
  if (sidebarVariant.value === SidebarVariant.Exercise) {
    return "Exercise Details";
  } else if (sidebarVariant.value === SidebarVariant.Block) {
    return "Block Details";
  }
  return "Details";
});

const selectedUnitID = computed(() => {
  const id = Number(route.params.id);
  return isNaN(id) ? null : id;
});

// ============ Exercise ============

const selectExercise = (e: Tables<"block_exercises">) => {
  console.log("Selected exercise:", e.id);
  selectedExercise.value = e;
  selectedBlock.value = null;
  sidebarVariant.value = SidebarVariant.Exercise;
  sidebarModel.value = true;
};

const unit = reactive({
  id: 0,
  name: "",
  description: "",
  patient_uid: "",
  therapist_uid: "",
  blocks: [] as Tables<"blocks">[],
  block_exercises: [] as Tables<"block_exercises">[],
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
      blocks(*),
      block_exercises(*)
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
    if (data.block_exercises) {
      data.block_exercises.sort((a, b) => a.order_position - b.order_position);
    }

    Object.assign(unit, data);

    if (selectedExercise.value) {
      const updatedExercise = unit.block_exercises.find(
        (e) => e.id === selectedExercise.value?.id
      );
      selectedExercise.value = updatedExercise || null;
    }

    if (selectedBlock.value) {
      const updatedBlock = unit.blocks.find(
        (b) => b.id === selectedBlock.value?.id
      );
      selectedBlock.value = updatedBlock || null;
    }
  }
};

const getExercisesForBlock = (blockId: number) => {
  return unit.block_exercises
    .filter((ex) => ex.block_id === blockId)
    .sort((a, b) => a.order_position - b.order_position);
};

// ============ Block ============

const selectBlock = (b: Tables<"blocks">) => {
  console.log("Selected block:", b.id);
  selectedBlock.value = b;
  selectedExercise.value = null;
  sidebarVariant.value = SidebarVariant.Block;
  sidebarModel.value = true;
};

const createBlock = async () => {
  const { data, error } = await supabase
    .from("blocks")
    .insert([
      {
        name: "New Block",
        description: "New Block Description",
        unit_id: unit.id,
        order_position: unit.blocks.length + 1,
        therapist_uid: supabaseUser.value?.id || "",
      },
    ])
    .select();

  if (error) {
    console.error("Error creating block:", error);
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
  sourceBlockId,
  targetBlockId,
  newPosition,
}: {
  exerciseId: number;
  sourceBlockId: number;
  targetBlockId: number;
  newPosition: number;
}) => {
  const result = await updateExercisePosition(
    unit,
    exerciseId,
    targetBlockId,
    newPosition
  );

  if (!result) return;

  try {
    const { error } = await supabase
      .from("block_exercises")
      .update({
        block_id: targetBlockId,
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
#blocks {
  display: flex;
  flex-direction: row;
  gap: 1rem;
  overflow-x: auto;
  max-width: 100%;
}
</style>
