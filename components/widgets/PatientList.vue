<template>
  <div class="overflow-hidden rounded-lg border border-gray-200">
    <table class="min-w-full bg-white border-collapse">
      <thead class="bg-gray-50 text-gray-500">
        <tr>
          <th class="py-3 px-4 text-left">Patient Name</th>
          <th class="py-3 px-4 text-left">Condition</th>
          <th class="py-3 px-4 text-left">Caregiver Name</th>
          <th class="py-3 px-4 text-left">Date Added</th>
        </tr>
      </thead>

      <!-- content -->
      <tbody>
        <tr
          v-for="p in families"
          :key="p.id"
          @click="() => emits('patientClick', p)"
          class="border-b cursor-pointer hover:bg-gray-100"
        >
          <td class="py-6 px-4">
            {{ p.patient_first_name }} {{ p.patient_last_name }}
          </td>
          <td class="py-3 px-4">
            {{ p.patient_condition || "DMD Phase 1" }}
            {{ p.condition_detail || "" }}
          </td>
          <td class="py-3 px-4">
            {{ p.caregiver_first_name }} {{ p.caregiver_last_name }}
          </td>
          <td class="py-3 px-4">
            {{ formatDate(p.created_at) }}
          </td>
        </tr>

        <!-- empty -->
        <tr v-if="!families || families.length === 0">
          <td colspan="4" class="py-6 px-4 text-center text-gray-500">
            No patients found
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup lang="ts">
const props = defineProps(["families"]);
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
