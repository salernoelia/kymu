<template>
  <div class="flex flex-col gap-4 w-full h-full">
    <NavigationBreadcrumbs
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
    <!-- Header -->
    <div
      id="patient-info"
      class="flex justify-between w-full p-1"
    >
      <h2>{{ $t("training-data-title") }}</h2>
      <PrimitivesButton
        variant="outline"
        icon-right="ic:outline-file-download"
      >
        {{ $t("download-register") }}
      </PrimitivesButton>
    </div>

    <!-- Content container -->
    <div class="w-full h-full flex flex-row gap-4 overflow-hidden">
      <!-- Entire left side: Activity Data -->
      <div class="flex flex-col w-2/5 gap-4 border rounded p-4 bg-white">
        <div
          class="container-header flex flex-row justify-between align-center"
        >
          <h2>{{ $t("activity") }}</h2>
          <PrimitivesButton
            variant="primary"
            @click="
              navigateTo(localePath(`/patient/activity/${route.params.id}`))
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
          <div class="px-4">
            <UiCalendar
              v-model="date"
              :weekday-format="'short'"
              class="rounded-md"
            />
          </div>
        </div>
        <!-- left-bottom -->
        <PrimitivesDivider orientation="horizontal" />

        <h2>Undefined</h2>
      </div>

      <!-- Entire right side: Training Data -->
      <div class="flex flex-col w-3/5 gap-4 h-full">
        <!-- Graph Component-->
        <PrimitivesContainer
          variant="white"
          :interactive="false"
          class="flex-grow"
        >
          <!-- Header with title and buttonsw -->
          <div class="flex justify-between mb-4">
            <h2>{{ $t("progress") }}</h2>
            <div class="flex gap-4">
              <WidgetsTimeSelector v-model="timeView" />
              <PrimitivesButton
                variant="primary"
                @click="
                  navigateTo(localePath(`/patient/activity/${route.params.id}`))
                "
              >
                {{ $t("details") }}
              </PrimitivesButton>
            </div>
          </div>

          <!-- Content area with stats and graph -->
          <div class="flex flex-1 gap-4">
            <!-- left -->
            <div class="pr-4">
              <h3>{{ $t("monthly-acitivty") }}</h3>
              <div class="flex flex-col gap-2 mt-2">
                <div class="flex flex-col">
                  <h3>14 min.</h3>
                  <p>{{ $t("trained-today") }}</p>
                </div>
              </div>
            </div>

            <!-- graph placeholder -->
            <div class="flex-grow">
              <PrimitivesContainer
                variant="white"
                :interactive="false"
                class="w-full flex items-center justify-center text-gray-400"
              >
                <ChartsActivity :time-period="timeView" />
              </PrimitivesContainer>
            </div>
          </div>
        </PrimitivesContainer>

        <!-- Feedback Component -->
        <PrimitivesContainer
          variant="white"
          :interactive="false"
        >
          <!-- Header with title and button -->
          <div class="flex justify-between mb-4">
            <h2>{{ $t("feedback") }}</h2>
            <PrimitivesButton
              variant="primary"
              @click="
                navigateTo(localePath(`/patient/activity/${route.params.id}`))
              "
            >
              {{ $t("details") }}
            </PrimitivesButton>
          </div>

          <!-- Content area with stats and scale -->
          <div class="flex justify-between gap-4">
            <div>
              <div class="flex justify-between">
                <div>
                  <h3>Chart placeholder</h3>
                  <p class="opacity-50 font-extralight">
                    {{ $t("fun-feedback") }}
                  </p>
                </div>
                <div>
                  <h3>+1.2</h3>
                  <p class="opacity-50 font-extralight">{{ $t("delta") }}</p>
                </div>
              </div>
              <ChartsBar />
            </div>
            <div>
              <div class="flex justify-between">
                <div>
                  <h3>Chart placeholder</h3>
                  <p class="opacity-50 font-extralight">
                    {{ $t("pain-feedback") }}
                  </p>
                </div>
                <div>
                  <h3>-0.2</h3>
                  <p class="opacity-50 font-extralight">{{ $t("delta") }}</p>
                </div>
              </div>
              <ChartsBar />
            </div>
          </div>
        </PrimitivesContainer>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute();
const timeView = ref("month");
const localePath = useLocalePath();

import {
  type DateValue,
  getLocalTimeZone,
  today,
} from "@internationalized/date";
import { type Ref, ref } from "vue";

const date = ref(today(getLocalTimeZone())) as Ref<DateValue>;
</script>

<style scoped></style>
