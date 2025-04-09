<template>
  <div>
    <div class="units flex flex-row">
      <TvUnit
        v-for="(unit, index) in unitsWithFocus"
        :key="index"
        :title="unit.title"
        :description="unit.description"
        :focus="unit.focus"
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

const units = [
  {
    Id: "5b238ad8-7da1-43f9-990b-1e4dedb72a82",
    title: "Unit 1",
    description: "Description for Unit 1",
  },
  {
    Id: "ae19bcfe-7fd5-4384-8d45-628e11bf8a2d",
    title: "Unit 2",
    description: "Description for Unit 2",
  },
  {
    Id: "7ec96432-1adf-499c-9680-3b3f702b8c57",
    title: "Unit 3",
    description: "Description for Unit 3",
  },
];

const unitsWithFocus = computed(() => {
  return units.map((unit, index) => ({
    ...unit,
    focus: index === selectedIndex.value,
  }));
});

watch(
  () => remoteKey.value,
  (newKey) => {
    if (newKey === "right") {
      selectedIndex.value = (selectedIndex.value + 1) % units.length;
    } else if (newKey === "left") {
      selectedIndex.value =
        (selectedIndex.value - 1 + units.length) % units.length;
    } else if (newKey === "ok") {
      const selectedUnit = units[selectedIndex.value];
      if (selectedUnit) {
        navigateTo(localePath(`/tv/${selectedUnit.Id}`));
      }
    }
  }
);

onMounted(async () => {
  const unitsData = await unitCrud.getWithDetails();
  console.log(unitsData);
});
</script>

<style scoped></style>
