<template>
  <div>
    <div class="flex justify-between space-x-4">
      <div class="flex flex-col align-top basis-1/4">
        <h1 class="text-2xl font-bold">{{ $t("patient-overview") }}</h1>
        <div
          class="border border-gray-200 mt-2 h-64 flex align-center justify-center rounded-md"
        >
          <!-- filtering component -->
          <p>Filter</p>
        </div>
        <div>
          <!-- sync calendar -->
        </div>
      </div>
      <div class="basis-3/4">
        <div class="flex space-x-4 justify-between">
          <div class="w-72">
            <PrimitivesSearch
              v-model="searchQuery"
              :placeholder="$t('patient-search-placeholder')"
              size="md"
            />
          </div>

          <div class="flex space-x-4">
            <PrimitivesButton
              variant="primary"
              @click="navigateTo(localePath('/patient/new'))"
            >
              {{ $t("add") }}
            </PrimitivesButton>
            <PrimitivesButton
              variant="secondary"
              @click="navigateTo(localePath('/patient/new'))"
            >
              {{ $t("download-register") }}
            </PrimitivesButton>

            <PrimitivesTab
              :tabs="[
                { label: $t('list-view'), value: 'list' },
                { label: $t('grid-view'), value: 'grid' },
              ]"
              v-model="view"
              variant="default"
            />
          </div>
        </div>
        <div class="mt-4">
          <!-- views -->
          <div v-if="view === 'list'">
            <WidgetsPatientList
              :families="filteredFamilies"
              @patientClick="(p) => navigateTo(localePath(`/patient/${p.uid}`))"
            />
          </div>
          <div v-else-if="view === 'grid'">
            <WidgetsPatientGrid
              :families="filteredFamilies"
              @patientClick="(p) => navigateTo(localePath(`/patient/${p.uid}`))"
            />
          </div>
        </div>
      </div>
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
const supabaseUser = useSupabaseUser();
const supabase = useSupabaseClient();
const localePath = useLocalePath();

const searchQuery = ref("");
const families = ref<Tables<"families">[]>([]);
const view = ref("list");
const selectedPatient = ref(null);

// Filtering basedon query
const filteredFamilies = computed(() => {
  if (!searchQuery.value.trim()) {
    return families.value;
  }

  const query = searchQuery.value.toLowerCase().trim();
  return families.value.filter((family) => {
    return (
      family.patient_first_name?.toLowerCase().includes(query) ||
      family.patient_last_name?.toLowerCase().includes(query) ||
      family.caregiver_first_name?.toLowerCase().includes(query) ||
      family.caregiver_last_name?.toLowerCase().includes(query)
    );
  });
});

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

  if (!data) {
    console.error("No data found");
    return;
  }

  families.value = data;
};

onMounted(async () => {
  await loadFamilyData();
});
</script>
