<template>
  <Transition
    appear
    v-if="!isLoadingPage"
  >
    <div class="editor-container">
      <div class="editor-container">
        <NavigationBreadcrumbs
          :breadcrumbs="[
            {
              path: '/admin/patients',
              translationKey: 'patient-overview-title',
            },
            {
              path: `/admin/${route.params.patientid}`,
              translationKey: 'patient-info',
            },
            {
              path: `/admin/${route.params.patientid}/editor/`,
              translationKey: 'unit-editor-title',
            },
          ]"
        />
        <div
          id="patient-info"
          class="flex justify-between w-full p-1"
        >
          <h1 class="text-2xl font-bold">{{ $t("unit-editor-title") }}</h1>
        </div>
        <div
          id="exercises"
          class="exercises-container"
        >
          <EditorUnit
            v-for="unit in store.units"
            :key="unit.id"
            :id="unit.id.toString()"
            :data-unit-id="unit.id"
            :exercises="store.getExercisesForUnit(unit.id.toString())"
            :startAssessment="getUnitStartAssessment(unit)"
            :endAssessment="getUnitEndAssessment(unit)"
            @drop="store.handleExerciseDrop"
            @add-assessment="onAddAssessment"
            class="z-20"
          >
            <template #header>
              <div class="flex justify-between items-center">
                <h3>{{ unit.name }}</h3>
                <div class="flex flex-row gap-1">
                  <Icon
                    class="icon-single cursor-pointer"
                    name="material-symbols-light:add-circle-outline-rounded"
                    @click="() => onAddClick(unit.id.toString())"
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

            <!-- Start Assessment -->
            <template
              v-if="unit.start_assessment_id"
              #start-assessment
            >
              <EditorUnitAssessment
                :id="unit.start_assessment_id"
                :assessment="getAssessmentById(unit.start_assessment_id)!"
                position="start"
                v-if="getAssessmentById(unit.start_assessment_id)"
              >
                <h4>
                  {{
                    getAssessmentById(unit.start_assessment_id)?.name ||
                    "Initial Assessment"
                  }}
                </h4>
              </EditorUnitAssessment>
            </template>

            <!-- Exercises -->
            <template
              v-for="exercise in store.getExercisesForUnit(unit.id.toString())"
              :key="exercise.id"
              #[`exercise-${exercise.id}`]
            >
              <EditorUnitExercise
                :id="exercise.id"
                :unit-id="unit.id.toString()"
                :exercise="exercise"
                :order-position="store.getExercisePosition(unit, exercise.id)"
              >
                <h4>{{ exercise.name || `Exercise ${exercise.id}` }}</h4>
                <p>{{ exercise.description }}</p>

                <p>
                  {{ exercise.repetitions_goal }} repetitions /
                  {{ exercise.duration_seconds_goal }} seconds
                </p>
              </EditorUnitExercise>
            </template>

            <!-- End Assessment -->
            <template
              v-if="unit.end_assessment_id"
              #end-assessment
            >
              <EditorUnitAssessment
                :id="unit.end_assessment_id"
                :assessment="getAssessmentById(unit.end_assessment_id)!"
                position="end"
              >
                <h4>
                  {{
                    getAssessmentById(unit.end_assessment_id)?.name ||
                    "Final Assessment"
                  }}
                </h4>
              </EditorUnitAssessment>
            </template>
          </EditorUnit>

          <div class="vertical-div" />

          <!-- Add Unit button -->
          <div
            id="create-unit"
            class="unit-block flex flex-col items-center justify-center border rounded p-4 cursor-pointer hover:bg-gray-300 mt-6"
            @click="onAddUnitClick"
          >
            <Icon
              class="icon-single mb-2"
              name="material-symbols-light:add-circle-outline-rounded"
            />
            <h3>Create New Unit</h3>
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
        <template
          v-if="
            store.sidebarVariant === 'assessment' && store.selectedAssessment
          "
        >
          <EditorSidebarAssessment />
        </template>
        <template v-if="store.sidebarVariant === 'type-selector'">
          <EditorTypeSelector @select="onTypeSelected" />
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
  </Transition>
  <div
    v-else
    class="flex items-center justify-center h-full"
  >
    <Icon
      name="svg-spinners:180-ring"
      size="3rem"
    />
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  title: "Kymu",
  layout: "admin",
});

const route = useRoute();
const store = useEditorStore();

const isLoadingPage = ref(true);

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

async function reloadAssessments() {
  const supabase = useSupabaseClient<Database>();
  const { data, error } = await supabase.from("assessments").select("*");

  if (!error && data) {
    assessments.value = data;
    return data;
  } else if (error) {
    console.error("Error loading assessments:", error);
  }
  return [];
}

const selectedPatientID = computed(() => {
  const id = route.params.patientid?.toString();
  return id || null;
});

const templateSelectorType = ref<"exercise" | "unit">("unit");
const templateSelectorUnitId = ref<string | null>(null);
const assessmentPosition = ref<"start" | "end">("start");

provide("dragInProgress", toRef(store, "dragInProgress"));
provide("draggingExerciseData", toRef(store, "draggingExercise"));

const assessments = ref<Tables<"assessments">[]>([]);

onMounted(async () => {
  await store.loadTemplates();

  store.setSelectedPatientId(selectedPatientID.value);
  await store.loadTrainingUnit();
  await loadAssessments();
  await loadExercisesForUnits(); // Add this line

  if (route.query.create === "unit") {
    onAddUnitClick();
  }

  isLoadingPage.value = false;
});

async function loadExercisesForUnits() {
  if (!store.units.length) return;

  const unitIds = store.units.map((unit) => unit.id);
  const supabase = useSupabaseClient<Database>();

  for (const unit of store.units) {
    if (!unit.exercises_index || unit.exercises_index.length === 0) continue;

    const { data, error } = await supabase
      .from("exercises")
      .select("*")
      .in("id", unit.exercises_index);

    if (error) {
      console.error("Error loading exercises for unit", unit.id, error);
    } else if (data) {
      const sortedExercises = [...data].sort((a, b) => {
        const aIndex = unit.exercises_index?.indexOf(a.id) ?? -1;
        const bIndex = unit.exercises_index?.indexOf(b.id) ?? -1;
        return aIndex - bIndex;
      });

      unit.exercises = sortedExercises;
    }
  }
}

async function loadAssessments() {
  const supabase = useSupabaseClient<Database>();
  const { data, error } = await supabase.from("assessments").select("*");

  if (!error && data) {
    assessments.value = data;
  } else if (error) {
    console.error("Error loading assessments:", error);
  }
}

function getAssessmentById(id: string) {
  return assessments.value.find((assessment) => assessment.id === id);
}

function getUnitStartAssessment(unit: Tables<"units">) {
  if (!unit.start_assessment_id) return null;
  const assessment = getAssessmentById(unit.start_assessment_id);
  return assessment || null;
}

function getUnitEndAssessment(unit: Tables<"units">) {
  if (!unit.end_assessment_id) return null;
  const assessment = getAssessmentById(unit.end_assessment_id);
  return assessment || null;
}

watch(selectedPatientID, async (newId) => {
  store.setSelectedPatientId(newId);
  await store.loadTrainingUnit();
  await loadAssessments();
  await loadExercisesForUnits();
});

const onAddClick = (unitId: string) => {
  if (!unitId) {
    console.error("Unit ID is undefined");
    return;
  }

  templateSelectorUnitId.value = unitId;
  store.sidebarVariant = "type-selector";
  sidebarTitle.value = "Add to Unit";
  sidebarOpen.value = true;
};

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

const onAddAssessment = ({
  unitId,
  position,
}: {
  unitId: string;
  position: "start" | "end";
}) => {
  // Set the assessment position for reference
  assessmentPosition.value = position;
  templateSelectorUnitId.value = unitId;

  // Find the target unit and store it for reference
  const targetUnit = store.units.find((u) => u.id.toString() === unitId);
  if (targetUnit) {
    // Initialize the new assessment with the correct unit reference
    store.initializeNewAssessment(unitId, position);

    sidebarTitle.value = `Create ${
      position === "start" ? "Start" : "End"
    } Assessment`;
    sidebarOpen.value = true;
  } else {
    console.error("Target unit not found:", unitId);
  }
};

const onTypeSelected = (type: "exercise" | "assessment") => {
  if (type === "exercise") {
    onAddExerciseClick(templateSelectorUnitId.value!);
  } else if (type === "assessment") {
    sidebarTitle.value = "Select Assessment Position";

    onAddAssessment({
      unitId: templateSelectorUnitId.value!,
      position: "start",
    });
  }
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
  reloadAssessments,
  assessments,
});
</script>

<style scoped lang="scss">
.editor-container {
  display: flex;
  flex-direction: column;
  height: 100%;
  width: 100%;
  overflow: hidden;
}

.header {
  flex-shrink: 0;
}

.exercises-container {
  display: flex;
  flex-direction: row;
  gap: 1rem;
  overflow-x: auto;
  overflow-y: hidden;
  flex: 1;
  padding: 0 1rem 1rem;
  margin-bottom: 1rem;

  & > *:not(:last-child) {
    position: relative;

    &::after {
      content: "";
      position: absolute;
      right: -0.5rem;
      height: 100%;
      top: 0.75rem;
      padding-bottom: 0.75rem;
      width: 1px;
      background-color: var(--color-Gray-300);
    }
  }
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

:deep(.highlight-new) {
  animation: highlight-pulse 2s ease-in-out;
  border: 2px solid #3b82f6 !important;
  box-shadow: 0 0 15px rgba(59, 130, 246, 0.5);
}

@keyframes highlight-pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.7);
  }
  70% {
    box-shadow: 0 0 0 10px rgba(59, 130, 246, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(59, 130, 246, 0);
  }
}

.v-enter-active,
.v-leave-active {
  transition: all 0.4s ease-in-out;

  filter: blur(0);
}

.v-enter-from,
.v-leave-to {
  opacity: 0;
  filter: blur(4px);
}
</style>
