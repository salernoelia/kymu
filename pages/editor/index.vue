<template>
  <div>
    <h1>{{ $t("unit-editor") }}</h1>

    <div class="editor-actions mb-4">
      <button
        class="create-unit-btn"
        @click="createNewUnit"
      >
        {{ $t("create-new-unit") || "Create New Unit" }}
      </button>
    </div>

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
const supabase = useSupabaseClient<Database>();
const editorStore = useEditorStore();

const units = ref<any[]>([]);
const selectedUnit = ref<null | any>(null);

onMounted(async () => {
  await loadTrainingUnits();
});

const loadTrainingUnits = async () => {
  let { data, error } = await supabase.from("units").select("*");
  if (data) {
    units.value = data;
  } else {
    console.error(error);
  }
};

const navigateToUnitEditor = () => {
  if (selectedUnit.value && selectedUnit.value !== null) {
    navigateTo(localePath(`/editor/${selectedUnit.value}`));
  }
};

const createNewUnit = () => {
  if (selectedUnit.value && selectedUnit.value !== null) {
    navigateTo(localePath(`/editor/${selectedUnit.value}?create=unit`));
  } else {
    // If no unit is selected, create a unique ID to use for a new unit
    const tempId = "new-" + Date.now();
    navigateTo(localePath(`/editor/${tempId}?create=unit`));
  }
};
</script>

<style scoped>
.editor-actions {
  margin-bottom: 1rem;
}

.create-unit-btn {
  background-color: #4caf50;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.2s;
}

.create-unit-btn:hover {
  background-color: #3e8e41;
}
</style>
