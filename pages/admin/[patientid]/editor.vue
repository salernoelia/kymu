<template>
  <div class="flex flex-row gap-4 overflow-x-auto">
    <EditorUnit
      v-for="unit in units"
      key="unit.id"
      :unit="unit"
    />
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
const unit = useUnitCrud();

// providers
const patientId = route.params.patientid;
provide("patientId", patientId);

const units: UnitWithDetails[] = await unit.getWithDetails();
console.log("units", units);
provide("units", units);
</script>
