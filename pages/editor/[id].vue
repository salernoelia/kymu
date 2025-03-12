<template>
  <div>
    <h1>{{ $t("unit-editor-title") }}</h1>
    <h3>{{ $t("unit-editor-description") }}</h3>
    <div>
      <div
        id="exercises"
        class="flex flex-row gap-4 h-full overflow-x-auto"
      >
        <EditorUnit
          v-for="unit in store.units"
          :key="unit.id"
          :id="unit.id.toString()"
          :data-unit-id="unit.id"
          :exercises="store.getExercisesForUnit(unit.id.toString())"
          @drop="store.handleExerciseDrop"
        >
          <template #header>
            <div class="flex justify-between items-center">
              <h2>{{ unit.name }}</h2>
              <div class="flex flex-row gap-1">
                <Icon
                  class="icon-single cursor-pointer"
                  name="material-symbols-light:add-circle-outline-rounded"
                  @click="() => onAddExerciseClick(unit.id.toString())"
                />
                <Icon
                  class="icon-single cursor-pointer"
                  name="material-symbols-light:edit-square-outline"
                  @click="() => store.selectUnit(unit)"
                />
              </div>
            </div>

            <p>{{ unit.description }}</p>
          </template>
          <template
            v-for="exercise in store.getExercisesForUnit(unit.id.toString())"
            :key="exercise.id"
            #[`exercise-${exercise.id}`]
          >
            <EditorUnitExercise
              :id="exercise.id"
              :unit-id="unit.id.toString()"
              :order-position="store.getExercisePosition(unit, exercise.id)"
              @click.stop="store.selectExercise(exercise)"
            >
              <h2>{{ exercise.name || `Exercise ${exercise.id}` }}</h2>
            </EditorUnitExercise>
          </template>
          <div
            id="create-exercise"
            class="flex flex-col items-center justify-center border rounded p-4 cursor-pointer hover:bg-gray-300"
            @click="() => onAddExerciseClick(unit.id.toString())"
          >
            <h2>Create Exercise</h2>
          </div>
        </EditorUnit>

        <!-- Add Unit button -->
        <div
          id="create-unit"
          class="unit-block flex flex-col items-center justify-center border rounded p-4 cursor-pointer hover:bg-gray-300"
          @click="onAddUnitClick"
        >
          <Icon
            class="icon-single text-4xl mb-2"
            name="material-symbols-light:add-circle-outline-rounded"
          />
          <h2>Create New Unit</h2>
        </div>
      </div>
    </div>
    <EditorSidebar
      v-model="sidebarOpen"
      :title="sidebarTitle"
      width="50%"
    >
      <template
        v-if="store.sidebarVariant === 'exercise' && store.selectedExercise"
      >
        <EditorSidebarExercise />
      </template>
      <template v-if="store.sidebarVariant === 'unit' && store.selectedUnit">
        <EditorSidebarUnit @create-exercise="onUnitCreateExercise" />
      </template>
      <template v-if="store.sidebarVariant === 'template-selector'">
        <EditorSidebarTemplateSelector
          :type="templateSelectorType"
          :unit-id="templateSelectorUnitId"
          @select-template="onTemplateSelected"
        />
      </template>
    </EditorSidebar>
  </div>
</template>

<script setup lang="ts">
const route = useRoute();
const store = useEditorStore();

const sidebarOpen = ref(false);
const sidebarTitle = ref("Details");

watch(
  () => store.sidebarOpen,
  (val) => {
    sidebarOpen.value = val;
  }
);

watch(sidebarOpen, (val) => {
  store.sidebarOpen = val;
});

const selectedPatientID = computed(() => {
  const id = route.params.id?.toString();
  return id || null;
});

const templateSelectorType = ref<"exercise" | "unit">("unit");
const templateSelectorUnitId = ref<string | null>(null);

provide("dragInProgress", toRef(store, "dragInProgress"));
provide("draggingExerciseData", toRef(store, "draggingExercise"));

onMounted(async () => {
  await store.loadTemplates();

  store.setSelectedPatientId(selectedPatientID.value);
  await store.loadTrainingUnit();

  if (route.query.create === "unit") {
    onAddUnitClick();
  }
});

watch(selectedPatientID, async (newId) => {
  store.setSelectedPatientId(newId);
  await store.loadTrainingUnit();
});

const onAddExerciseClick = (unitId: string) => {
  if (!unitId) {
    console.error("Unit ID is undefined");
    return;
  }

  templateSelectorType.value = "exercise";
  templateSelectorUnitId.value = unitId;

  store.sidebarVariant = "template-selector";
  store.sidebarMode = "create";

  sidebarTitle.value = "Create New Exercise";
  sidebarOpen.value = true;
};

const onAddUnitClick = () => {
  templateSelectorType.value = "unit";

  store.sidebarVariant = "template-selector";
  store.sidebarMode = "create";

  sidebarTitle.value = "Create New Unit";
  sidebarOpen.value = true;
};

const onUnitCreateExercise = (unitId: string) => {
  nextTick(() => {
    onAddExerciseClick(unitId);
  });
};

const onTemplateSelected = (data: {
  templateId?: string;
  type: "exercise" | "unit";
}) => {
  console.log("Template selected:", data);

  if (data.type === "exercise" && templateSelectorUnitId.value) {
    if (data.templateId) {
      store.createExerciseFromTemplate(
        templateSelectorUnitId.value,
        data.templateId
      );
    } else {
      store.initializeNewExercise(templateSelectorUnitId.value);
    }
  } else if (data.type === "unit") {
    if (data.templateId) {
      store.initializeNewUnitFromTemplate(data.templateId);
    } else {
      store.initializeNewUnit();
    }
  }
};

defineExpose({
  openCreateExerciseModal: onAddExerciseClick,
  openCreateUnitModal: onAddUnitClick,
});
</script>

<style scoped lang="scss">
#exercises {
  display: flex;
  flex-direction: row;
  gap: 1rem;
  overflow-x: auto;
  max-width: 100%;
  height: 100%;
}

#create-unit {
  min-width: 250px;
  min-height: 250px;
  justify-content: center;
  border: 2px dashed #ccc;
  transition: all 0.3s ease;

  &:hover {
    border-color: #4caf50;
    background-color: rgba(76, 175, 80, 0.1);
  }
}

.unit-block {
  border: 1px solid #ccc;
  padding: 1rem;
  margin: 1rem 0;
  width: 400px;
  background-color: #ffffff;
  border-radius: 8px;
  transition: all 0.3s ease;
}
</style>
