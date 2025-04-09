<template>
  <div class="flex flex-row gap-4">
    <EditorUnit
      v-for="unit in editorStore.units"
      :key="unit.id"
      :unit="unit"
    />
    <EditorCardNewUnit @click="editorStore.openTemplateOrNewUnitSidebar()" />
    <EditorSidebar>
      <EditorSidebarTemplateOrNewUnit
        v-if="editorStore.sidebarMode === 'templateOrNewUnit'"
      />
      <EditorSidebarNewExercise
        v-if="editorStore.sidebarMode === 'newExercise'"
      />
      <EditorSidebarEditExercise
        v-if="editorStore.sidebarMode === 'editExercise'"
      />
      <EditorSidebarNewAssessment
        v-if="editorStore.sidebarMode === 'newAssessment'"
      />
      <EditorSidebarEditAssessment
        v-if="editorStore.sidebarMode === 'editAssessment'"
      />
      <EditorSidebarNewUnit v-if="editorStore.sidebarMode === 'newUnit'" />
      <EditorSidebarEditUnit v-if="editorStore.sidebarMode === 'editUnit'" />
      <EditorSidebarTemplateOrNewExercise
        v-if="editorStore.sidebarMode === 'templateOrNewExercise'"
      />
      <EditorSidebarTemplateOrNewAssessment
        v-if="editorStore.sidebarMode === 'templateOrNewAssessment'"
      />
    </EditorSidebar>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  title: "Kymu",
  layout: "admin-editor",
});

// composables
const supabase = useSupabaseClient();
const route = useRoute();
const localePath = useLocalePath();
const unitCrud = useUnitCrud();
const exerciseCrud = useExerciseCrud();
const editorStore = useEditorStore();

// providers
const patientId = route.params.patientid;
provide("patientId", patientId);

onMounted(async () => {
  try {
    const unitsData = await unitCrud.getWithDetails();
    console.log(unitsData);
    editorStore.setUnits(unitsData);
    editorStore.isEditorLoaded = true;
  } catch (error) {
    console.error("Error fetching units:", error);
  }
});
</script>
