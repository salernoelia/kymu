<template>
  <div>
    <h1>{{ $t("unit-editor") }}</h1>
    <select v-model="selectedUnit">
      <option value="null">{{ $t("unit-select-placeholder") }}</option>
      <option
        v-for="unit in units"
        :key="unit.id"
        :value="unit.id"
      >
        {{ unit.name }}
      </option>
    </select>
    <button @click="navigateToUnitEditor">Load Unit</button>
  </div>
</template>

<script setup lang="ts">
const { locale } = useI18n();
const localePath = useLocalePath();
const supabase = useSupabaseClient();

const units = ref<any[]>([]);
const selectedUnit = ref<null | any>(null);

onMounted(async () => {
  await loadTrainingUnits();
});

const loadTrainingUnits = async () => {
  let { data, error } = await supabase.from("training_units").select("*");
  if (data) {
    units.value = data;
  } else {
    console.error(error);
  }
};

const navigateToUnitEditor = () => {
  if (selectedUnit.value && selectedUnit.value !== null) {
    console.log("selected", selectedUnit.value);
    navigateTo(localePath(`/editor/${selectedUnit.value}`));
  }
};
</script>

<style scoped></style>
