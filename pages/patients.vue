<template>
  <div class="container mx-auto p-6">
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-semibold">Patients</h1>

      <div>
        <button
          @click="setView('list')"
          :class="getButtonClass('list')"
          class="px-4 py-2 rounded-l border"
        >
          List View
        </button>
        <button
          @click="setView('grid')"
          :class="getButtonClass('grid')"
          class="px-4 py-2 rounded-r border"
        >
          Grid View
        </button>
      </div>
    </div>

    <!-- views -->
    <div v-if="view === 'list'">
      <WidgetsPatientList
        :families
        @patientClick="(p) => navigateTo(localePath(`/patient/${p.id}`))"
      />
    </div>
    <div v-else-if="view === 'grid'">
      <WidgetsPatientGrid
        :families
        @patientClick="(p) => navigateTo(localePath(`/patient/${p.id}`))"
      />
    </div>

    <!-- popup -->
    <WidgetsPatientDetails
      v-if="selectedPatient"
      :patient="selectedPatient"
      @close="closeDetails"
    />
  </div>
</template>

<script setup lang="ts">
const supabase = useSupabaseClient();
const supabaseUser = useSupabaseUser();
const localePath = useLocalePath();

// import jsonData from "~/assets/data/data.json";
const families = ref();

const view = ref("list");
const selectedPatient = ref(null);

const setView = (newView: string) => {
  view.value = newView;
};

const closeDetails = () => {
  selectedPatient.value = null;
};

const getButtonClass = (targetView: string) => {
  return view.value === targetView
    ? "bg-blue-500 text-white"
    : "bg-white text-gray-700";
};

const loadFamilyData = async () => {
  if (!supabaseUser.value) {
    console.error("No user logged in");
    return;
  }
  const { data, error } = await supabase
    .from("families")
    .select("*")
    .eq("therapist_uid", supabaseUser.value?.id);

  if (error) {
    console.error("Error fetching patient data", error);
    return;
  }

  families.value = data;

  console.log("Patient data", data);
};

onMounted(async () => {
  await loadFamilyData();
});
</script>
