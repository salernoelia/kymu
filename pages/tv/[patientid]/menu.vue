<template>
  <div>
    <div class="units flex flex-row gap-4">
      <TvUnit
        v-if="tvStore.units"
        v-for="(unit, index) in unitsWithFocus"
        :focus="unit.focus"
        :unit
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { useTVStore } from "~/stores/tvStore";

definePageMeta({
  title: "Kymu",
  layout: "television",
});

const supabase = useSupabaseClient();
const localePath = useLocalePath();
const { remoteKey } = useRemoteControl();
const tvStore = useTVStore();

const selectedIndex = ref(0);

const route = useRoute();
const patientId = route?.params.patientid;

watch(
  () => remoteKey.value,
  (newKey) => {
    if (tvStore.units && tvStore.units.length > 1) {
      if (newKey === "right") {
        selectedIndex.value =
          (selectedIndex.value + 1) % (tvStore.units.length || 1);
      } else if (newKey === "left") {
        selectedIndex.value =
          (selectedIndex.value - 1 + tvStore.units.length) %
          tvStore.units.length;
      } else if (newKey === "ok") {
        const selectedUnit = tvStore.units[selectedIndex.value];
        if (selectedUnit) {
          navigateTo(localePath(`/tv/${patientId}/${selectedUnit.id}`));
        }
      }
    }
  }
);

const unitsWithFocus = computed(() => {
  if (!tvStore.units) return;
  return tvStore.units.map((unit, index) => ({
    ...unit,
    focus: index === selectedIndex.value,
  }));
});
</script>

<style scoped></style>
