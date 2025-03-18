<template>
  <div>
    <WidgetsBreadcumbs
      :breadcrumbs="[
        { path: '/patients', translationKey: 'patient-overview-title' },
        {
          path: `/patient/${route.params.id}`,
          translationKey: 'patient-info',
        },
        {
          path: `/patient/activity/${route.params.id}`,
          translationKey: 'activity-overview-title',
        },
      ]"
    />
  </div>
</template>

<script setup lang="ts">
const route = useRoute();
</script>

<style scoped></style>
