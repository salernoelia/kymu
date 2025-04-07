<template>
  <div>
    <div
      v-if="patients && patients.length > 0"
      class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6"
    >
      <PrimitivesContainer
        v-for="p in patients"
        :key="p.id"
        variant="white"
        :interactive="true"
        @click="() => emits('patientClick', p)"
      >
        <h3 class="font-medium text-lg mb-4">
          {{ p.patient_first_name }} {{ p.patient_last_name }}
        </h3>

        <div class="space-y-3 text-sm">
          <div class="flex space-x-4">
            <div class="flex flex-col">
              <span class="text-gray-500">{{ $t("patient-diagnosis") }}</span>
              <span>{{ p.patient_condition || "DMD Phase 1" }}</span>
            </div>
            <div class="flex flex-col">
              <span class="text-gray-500">{{
                $t("patient-diagnosis-details")
              }}</span>
              <span>{{ p.condition_detail || "" }}</span>
            </div>
          </div>

          <div class="flex flex-col">
            <span class="text-gray-500">{{ $t("caregiver") }}</span>
            <span
              >{{ p.caregiver_first_name }} {{ p.caregiver_last_name }}</span
            >
          </div>

          <div class="flex flex-col">
            <span class="text-gray-500">{{ $t("patient-created-at") }}</span>
            <span>{{ formatDate(p.created_at) }}</span>
          </div>
        </div>
      </PrimitivesContainer>
    </div>
    <PrimitivesContainer
      v-if="!patients || patients.length === 0"
      variant="white"
      class="text-center text-gray-500"
    >
      No patients found
    </PrimitivesContainer>
  </div>
</template>

<script setup lang="ts">
const props = defineProps(["patients"]);
const emits = defineEmits(["patientClick"]);

function formatDate(dateString: string): string {
  if (!dateString) return "";

  const date = new Date(dateString);
  return new Intl.DateTimeFormat("en-GB", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
  }).format(date);
}
</script>
