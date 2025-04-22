<template>
  <div>
    <div class="units flex flex-row gap-4">
      <TvUnit
        v-if="units"
        v-for="(unit, index) in unitsWithFocus"
        :focus="unit.focus"
        :unit
      />
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  title: "Kymu",
  layout: "television",
});

const supabase = useSupabaseClient();
const localePath = useLocalePath();
const { remoteKey } = useRemoteControl();
const unitCrud = useUnitCrud();
const selectedIndex = ref(0);

const route = useRoute();
const patientId = route?.params.patientid;

const units = ref<UnitWithDetails[]>();

watch(
  () => remoteKey.value,
  (newKey) => {
    if (units.value && units.value.length > 1) {
      if (newKey === "right") {
        selectedIndex.value =
          (selectedIndex.value + 1) % (units.value?.length || 1);
      } else if (newKey === "left") {
        selectedIndex.value =
          (selectedIndex.value - 1 + units.value.length) % units.value.length;
      } else if (newKey === "ok") {
        const selectedUnit = units.value?.[selectedIndex.value];
        if (selectedUnit) {
          navigateTo(localePath(`/tv/${patientId}/${selectedUnit.id}`));
        }
      }
    }
  }
);

const unitsWithFocus = computed(() => {
  if (!units.value) return;
  return units.value.map((unit, index) => ({
    ...unit,
    focus: index === selectedIndex.value,
  }));
});

onMounted(async () => {
  units.value = await unitCrud.getWithDetails();

  console.log(units.value);
});
</script>

<style scoped></style>
