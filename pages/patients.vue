<template>
  <div v-if="isLoadingPage">
    <div class="flex justify-between space-x-4 p-4">
      <div class="flex flex-col align-top gap-4 w-1/4">
        <h1 class="text-2xl font-bold">{{ $t("patient-overview") }}</h1>
        <div
          class="border border-gray-200 h-64 flex flex-col align-start justify-start gap-2 rounded-md p-4"
        >
          <!-- filtering component -->
          <h3>Filters</h3>
          <div class="flex flex-col gap-4">
            <p>Age {{ sliderAgeValue }}</p>
            <UiSlider
              v-model="sliderAgeValue"
              :min="8"
              :max="45"
              :step="1"
              :class="['w-full']"
            />
          </div>
        </div>
        <div>
          <!-- filtering component -->
          <UiCalendar
            v-model="date"
            :weekday-format="'short'"
            class="rounded-md border w-full"
          />
        </div>
        <div>
          <!-- sync calendar -->
        </div>
      </div>
      <div class="flex flex-col gap-4 w-3/4">
        <div class="flex gap-4 justify-between">
          <div class="max-w-96">
            <PrimitivesSearch
              v-model="searchQuery"
              :placeholder="$t('patient-search-placeholder')"
              size="md"
            />
          </div>

          <div class="flex gap-4">
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
        <div>
          <!-- views -->
          <div v-if="view === 'list'">
            <PatientList
              :families="filteredFamilies"
              @patientClick="(p) => navigateTo(localePath(`/patient/${p.uid}`))"
            />
          </div>
          <div v-else-if="view === 'grid'">
            <PatientGrid
              :families="filteredFamilies"
              @patientClick="(p) => navigateTo(localePath(`/patient/${p.uid}`))"
            />
          </div>
        </div>
      </div>
    </div>

    <!-- popup -->
    <PatientDetails
      v-if="selectedPatient"
      :patient="selectedPatient"
      @close="closeDetails"
    />
  </div>
  <div
    v-else
    class="flex items-center justify-center h-full"
  >
    <Icon
      name="svg-spinners:180-ring"
      size="3rem"
    />
  </div>
</template>

<script setup lang="ts">
import {
  type DateValue,
  getLocalTimeZone,
  today,
} from "@internationalized/date";

const supabase = useSupabaseClient();
const supabaseUser = useSupabaseUser();
const localePath = useLocalePath();

const searchQuery = ref("");
const families = ref<Tables<"families">[]>([]);
const view = ref("list");
const selectedPatient = ref(null);
const date = ref(today(getLocalTimeZone())) as Ref<DateValue>;
const sliderAgeValue = ref([17]);
const isLoadingPage = ref(false);

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
  isLoadingPage.value = true;
});
</script>
