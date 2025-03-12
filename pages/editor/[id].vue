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
          v-for="unit in store.units"
          :key="unit.id"
          :id="unit.id"
          :exercises="store.getExercisesForUnit(unit.id)"
          @drop="store.handleExerciseDrop"
        >
          <template #header>
            <div class="flex justify-between items-center">
              <h2>{{ unit.name }}</h2>
              <div class="flex flex-row gap-1">
                <Icon
                  class="icon-single cursor-pointer"
                  name="material-symbols-light:add-circle-outline-rounded"
                  @click="() => store.createExercise(unit.id)"
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
            v-for="exercise in store.getExercisesForUnit(unit.id)"
            :key="exercise.id"
            #[`exercise-${exercise.id}`]
          >
            <EditorUnitExercise
              :id="exercise.id"
              :unit-id="unit.id"
              :order-position="store.getExercisePosition(unit, exercise.id)"
              @click.stop="store.selectExercise(exercise)"
            >
              <h2>{{ exercise.name || `Exercise ${exercise.id}` }}</h2>
            </EditorUnitExercise>
          </template>
          <div
            id="create-exercise"
            class="flex flex-col items-center justify-center border rounded p-4 cursor-pointer hover:bg-gray-300"
            @click="() => store.createExercise(unit.id)"
          >
            <h2>Create Exercise</h2>
          </div>
        </EditorUnit>
      </div>
    </div>
    <EditorSidebar
      v-model="store.sidebarOpen"
      :title="store.sidebarTitle"
      width="400px"
    >
      <template
        v-if="store.sidebarVariant === 'exercise' && store.selectedExercise"
      >
        <EditorSidebarExercise />
      </template>
      <template v-if="store.sidebarVariant === 'unit' && store.selectedUnit">
        <EditorSidebarUnit />
      </template>
    </EditorSidebar>
  </div>
</template>

<script setup lang="ts">
const route = useRoute();
const store = useEditorStore();

const selectedPatientID = computed(() => {
  const id = route.params.id?.toString();
  return id || null;
});

provide("dragInProgress", toRef(store, "dragInProgress"));
provide("draggingExerciseData", toRef(store, "draggingExercise"));

onMounted(async () => {
  store.setSelectedPatientId(selectedPatientID.value);
  await store.loadTrainingUnit();
});

watch(selectedPatientID, async (newId) => {
  store.setSelectedPatientId(newId);
  await store.loadTrainingUnit();
});
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
