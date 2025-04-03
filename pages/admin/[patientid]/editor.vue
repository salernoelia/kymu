<template>
  <div>
    {{ units }}
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  title: "Kymu",
  layout: "admin-editor",
});

const supabase = useSupabaseClient();
const route = useRoute();
const localePath = useLocalePath();
const patientId = route.params.patientid;

// crud
const unit = useUnitCrud();

const units = await unit.get();
</script>
