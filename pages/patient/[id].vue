<template>
  <div
    class="flex flex-row gap-4"
    v-if="f"
  >
    <div
      id="patient-info"
      class="flex flex-col border rounded p-4"
    >
      <h2>{{ $t("patient-info") }}</h2>
      <h3>
        {{ $t("patient") }}: {{ f.patient_last_name }}
        {{ f.patient_first_name }}
      </h3>
      <h3>
        {{ $t("caregiver") }}: {{ f.caregiver_last_name }}
        {{ f.caregiver_first_name }}
      </h3>

      <h3>{{ $t("patient-description") }}</h3>
    </div>
    <div
      id="units"
      class="flex flex-col border rounded p-4"
      v-if="f.units && f.units.length > 0"
    >
      <h2>{{ $t("patient-units") }}</h2>

      <WidgetsVerticalCarousell
        v-if="f.units && f.units.length > 0"
        @current-slide="
          (i) =>
            f?.units?.[i]?.id &&
            navigateTo(localePath(`/editor/${route.params.id}`))
        "
        :initialSlide="0"
        :slides="slidesFromUnits(f.units)"
      />
    </div>

    <div
      id="progress"
      class="flex flex-col border rounded p-4"
    >
      <h1>{{ $t("patient-progress") }}</h1>
      <ChartsBar
        :data="barChartData"
        title="Monthly Sales"
        :width="400"
        :height="300"
        barColor="#3498db"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import type { QueryData } from "@supabase/supabase-js";

const route = useRoute();
const localePath = useLocalePath();
const supabase = useSupabaseClient<Database>();

const slidesFromUnits = (units: Tables<"units">[]): Slide[] => {
  return units.map((unit: Tables<"units">) => {
    return {
      title: unit.name,
      description: unit.description || "",
    };
  });
};

if (!route.params.id) {
  navigateTo(localePath("/patients"));
  throw new Error("No patient ID provided");
}

const familiesWithFkeyQuery = supabase
  .from("families")
  .select(
    `
    *,
    units(*)
  `
  )
  .eq("uid", route.params.id.toString())
  .single();

const f = ref<QueryData<typeof familiesWithFkeyQuery>>();

const loadPatientData = async () => {
  const { data, error } = await familiesWithFkeyQuery;

  if (error) {
    console.error("Error fetching patient data", error);
    return;
  }

  f.value = data;
};

onMounted(async () => {
  await loadPatientData();
});

const pieChartData = ref([
  { name: "Marketing", value: 300 },
  { name: "Development", value: 500 },
  { name: "Research", value: 200 },
  { name: "Operations", value: 250 },
  { name: "Administration", value: 150 },
]);

const bubbleData = ref([
  { name: "Research", value: 85, category: "Development" },
  { name: "Design", value: 65, category: "Development" },
  { name: "Testing", value: 45, category: "QA" },
  { name: "Deployment", value: 30, category: "Operations" },
  { name: "Marketing", value: 55, category: "Business" },
  { name: "Analysis", value: 40, category: "Business" },
  { name: "Support", value: 25, category: "Operations" },
]);

const barChartData = ref([
  { name: "Jan", value: 45 },
  { name: "Feb", value: 23 },
  { name: "Mar", value: 56 },
  { name: "Apr", value: 78 },
  { name: "May", value: 42 },
]);

// to demonstrate animation on data updates
// setTimeout(() => {
//   barChartData.value = [
//     { name: "Jan", value: 65 },
//     { name: "Feb", value: 59 },
//     { name: "Mar", value: 80 },
//     { name: "Apr", value: 55 },
//     { name: "May", value: 40 },
//   ];
// }, 3000);
</script>

<style scoped></style>
