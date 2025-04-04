<template>
  <div class="flex flex-row gap-4">
    <EditorUnit
      v-for="unit in editorStore.units"
      :key="unit.id"
      :unit="unit"
    />
    <EditorSidebar>
      <EditorSidebarNewExercise
        v-if="editorStore.sidebarMode === 'newExercise'"
      />
      <EditorSidebarEditExercise
        v-if="editorStore.sidebarMode === 'editExercise'"
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
    editorStore.setUnits(unitsData);
  } catch (error) {
    console.error("Error fetching units:", error);
  }
});
</script>
