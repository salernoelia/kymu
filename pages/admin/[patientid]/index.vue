<template>
  <div
    class="flex flex-col gap-4 w-full h-full"
    v-if="isLoadingPage"
  >
    <NavigationBreadcrumbs
      :breadcrumbs="[
        { path: '/admin/patients', translationKey: 'patient-overview-title' },
        {
          path: `/admin/${route.params.patientid}`,
          translationKey: 'patient-info',
        },
      ]"
    />
    <div
      id="patient-info"
      class="flex justify-between w-full p-1"
    >
      <h1 class="text-2xl font-bold">{{ $t("patient-info") }}</h1>
    </div>
    <div class="w-full h-full flex flex-row gap-4 overflow-hidden">
      <!-- left -->
      <div class="flex flex-col gap-4 w-full h-full">
        <!-- top-reft -->
        <div
          id="patient-info"
          class="flex flex-col w-full h-1/2 border rounded p-4 bg-white"
          v-if="f"
        >
          <h2>{{ $t("patient-details") }}</h2>
          <p>
            {{ $t("patient") }}: {{ f.patient_last_name }}
            {{ f.patient_first_name }}
          </p>
          <p>
            {{ $t("caregiver") }}: {{ f.caregiver_last_name }}
            {{ f.caregiver_first_name }}
          </p>

          <p>{{ $t("patient-description") }}</p>
        </div>

        <!-- bottom-left -->
        <div
          id="units"
          class="flex flex-col border rounded p-4 w-full h-1/2 bg-white gap-4"
        >
          <div
            class="container-header flex flex-row justify-between align-center"
            v-if="f && f.units && f.units.length > 0"
          >
            <h2>{{ $t("patient-units") }}</h2>
            <PrimitivesButton
              variant="primary"
              @click="
                navigateTo(
                  localePath(`/admin/${route.params.patientid}/editor`)
                )
              "
            >
              {{ $t("unit-editor-title") }}
            </PrimitivesButton>
          </div>

          <WidgetsVerticalCarousell
            v-if="f && f.units && f.units.length > 0"
            @current-slide="
              (i) =>
                f?.units?.[i]?.id &&
                navigateTo(
                  localePath(`/admin/${route.params.patientid}/editor`)
                )
            "
            :initialSlide="0"
            :slides="slidesFromUnits(f.units)"
            class="w-full h-full"
          />
        </div>
      </div>

      <!-- right -->
      <div
        class="flex flex-col w-full h-full border rounded p-4 bg-white gap-4 overflow-hidden"
      >
        <!-- right-top -->
        <div
          class="container-header flex flex-row justify-between align-center"
        >
          <h2>{{ $t("activity") }}</h2>
          <PrimitivesButton
            variant="primary"
            @click="
              navigateTo(
                localePath(`/admin/${route.params.patientid}/activity`)
              )
            "
          >
            {{ $t("activity-details") }}
          </PrimitivesButton>
        </div>

        <div class="flex flex-row justify-between border rounded p-4 bg-white">
          <div class="flex flex-col gap-2">
            <h3>{{ $t("monthly-acitivty") }}</h3>
            <div class="flex flex-col">
              <h3>14 min.</h3>
              <p>{{ $t("trained-today") }}</p>
            </div>
            <div class="flex flex-col">
              <h3>14 min.</h3>
              <p>{{ $t("trained-today") }}</p>
            </div>
            <div class="flex flex-col">
              <h3>14 min.</h3>
              <p>{{ $t("trained-today") }}</p>
            </div>
            <div class="flex flex-col">
              <h3>14 min.</h3>
              <p>{{ $t("trained-today") }}</p>
            </div>
          </div>
          <UiCalendar
            v-model="date"
            :weekday-format="'short'"
            class="rounded-md border"
          />
        </div>
        <!-- right-bottom -->
        <div class="h-full flex flex-col gap-4">
          <PrimitivesDivider orientation="horizontal" />
          <AreaChart
            :data="data"
            index="name"
            :categories="['total', 'predicted']"
            class="w-full h-[250px]"
          />
        </div>
      </div>
    </div>
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
import { AreaChart } from "@/components/ui/chart-area";

const route = useRoute();
const localePath = useLocalePath();
const supabase = useSupabaseClient<Database>();
import type { QueryData } from "@supabase/supabase-js";

const date = ref(today(getLocalTimeZone())) as Ref<DateValue>;
const isLoadingPage = ref(false);

const slidesFromUnits = (units: Tables<"units">[]): Slide[] => {
  return units.map((unit: Tables<"units">) => {
    return {
      title: unit.name,
      description: unit.description || "",
    };
  });
};

if (!route.params.patientid) {
  navigateTo(localePath("/admin/patients"));
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
  .eq("uid", route.params.patientid.toString())
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
  isLoadingPage.value = true;
});

const barChartData = ref([
  { name: "Jan", value: 45 },
  { name: "Feb", value: 23 },
  { name: "Mar", value: 56 },
  { name: "Apr", value: 78 },
  { name: "May", value: 42 },
]);

const data = [
  {
    name: "Jan",
    total: Math.floor(Math.random() * 2000) + 500,
    predicted: Math.floor(Math.random() * 2000) + 500,
  },
  {
    name: "Feb",
    total: Math.floor(Math.random() * 2000) + 500,
    predicted: Math.floor(Math.random() * 2000) + 500,
  },
  {
    name: "Mar",
    total: Math.floor(Math.random() * 2000) + 500,
    predicted: Math.floor(Math.random() * 2000) + 500,
  },
  {
    name: "Apr",
    total: Math.floor(Math.random() * 2000) + 500,
    predicted: Math.floor(Math.random() * 2000) + 500,
  },
  {
    name: "May",
    total: Math.floor(Math.random() * 2000) + 500,
    predicted: Math.floor(Math.random() * 2000) + 500,
  },
  {
    name: "Jun",
    total: Math.floor(Math.random() * 2000) + 500,
    predicted: Math.floor(Math.random() * 2000) + 500,
  },
  {
    name: "Jul",
    total: Math.floor(Math.random() * 2000) + 500,
    predicted: Math.floor(Math.random() * 2000) + 500,
  },
];
</script>

<style scoped></style>
