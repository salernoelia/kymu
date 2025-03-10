<template>
  <div class="flex flex-col">
    <h1>{{}}</h1>
  </div>
</template>

<script setup lang="ts">
const route = useRoute();
const localePath = useLocalePath();
const supabase = useSupabaseClient();

const loadPatientData = async () => {
  const { data, error } = await supabase.from("families").select("*");

  if (error) {
    console.error("Error fetching patient data", error);
    return;
  }

  console.log("Patient data", data);
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
