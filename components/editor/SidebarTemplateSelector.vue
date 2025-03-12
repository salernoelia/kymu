<template>
  <div class="template-selector">
    <h2>{{ title }}</h2>

    <div class="template-options">
      <button
        class="template-option create-new"
        @click="selectBlank"
      >
        <div class="template-icon">
          <Icon
            name="material-symbols-light:add-circle-outline-rounded"
            size="2rem"
          />
        </div>
        <div class="template-info">
          <h3>Create from scratch</h3>
          <p>Start with a blank {{ type }}</p>
        </div>
      </button>

      <div class="templates-list">
        <h3>Or select from templates:</h3>

        <div
          v-if="loading"
          class="loading"
        >
          Loading templates...
        </div>

        <div
          v-else-if="!hasTemplates"
          class="no-templates"
        >
          No templates available
        </div>

        <button
          v-for="template in templates"
          :key="template.id"
          class="template-option"
          @click="selectTemplate(template.id)"
        >
          <div class="template-icon">
            <Icon
              :name="getIconForTemplate(template)"
              size="2rem"
            />
          </div>
          <div class="template-info">
            <h3>{{ template.name || "Unnamed Template" }}</h3>
            <p>{{ template.description || `Template ${template.id}` }}</p>
          </div>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  type: "exercise" | "unit";
  unitId?: string | null;
}>();

const emit = defineEmits<{
  (
    e: "select-template",
    data: { templateId?: string; type: "exercise" | "unit" }
  ): void;
}>();

const store = useEditorStore();
const loading = ref(true);
const templates = ref<any[]>([]);

const title = computed(() => {
  return `Create new ${props.type === "unit" ? "training unit" : "exercise"}`;
});

const hasTemplates = computed(() => {
  return templates.value && templates.value.length > 0;
});

onMounted(async () => {
  try {
    await loadTemplates();
  } catch (error) {
    console.error("Error loading templates:", error);
    loading.value = false;
  }
});

const loadTemplates = async () => {
  loading.value = true;

  try {
    // Force refresh of templates
    await store.loadTemplates();

    console.log("Templates loaded", {
      exercises: store.exerciseTemplates.length,
      units: store.unitTemplates.length,
    });

    // Copy template arrays to avoid reactivity issues
    if (props.type === "exercise") {
      templates.value = [...store.exerciseTemplates];
    } else {
      templates.value = [...store.unitTemplates];
    }

    console.log(`Loaded ${templates.value.length} ${props.type} templates`);
  } catch (error) {
    console.error(`Error loading ${props.type} templates:`, error);
  } finally {
    loading.value = false;
  }
};

const getIconForTemplate = (template: any) => {
  if (props.type === "exercise") {
    // Different icons based on focus type
    const focusType = template.focus_type;
    if (focusType === "strength") return "material-symbols:fitness-center";
    if (focusType === "mobility") return "material-symbols:directions-run";
    if (focusType === "balance") return "material-symbols:balance";
    if (focusType === "coordination") return "material-symbols:psychology";
    return "material-symbols:description";
  } else {
    return "material-symbols:playlist-add-check";
  }
};

const selectBlank = () => {
  emit("select-template", { type: props.type });
};

const selectTemplate = (templateId: string) => {
  if (!templateId) {
    console.error("Template ID is undefined or null");
    return;
  }
  emit("select-template", { templateId, type: props.type });
};
</script>

<style scoped>
.template-selector {
  padding: 1rem;
  height: 100%;
  overflow-y: auto;
}

h2 {
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  color: #333;
}

.template-options {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.templates-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.templates-list h3 {
  font-size: 1.2rem;
  color: #555;
  margin-bottom: 0.5rem;
}

.template-option {
  display: flex;
  align-items: center;
  width: 100%;
  padding: 1rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  transition: all 0.2s ease;
  text-align: left;
  background-color: #fff;
  cursor: pointer;
}

.template-option:hover {
  border-color: #4caf50;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.template-option.create-new {
  background-color: #f9f9f9;
  border: 2px dashed #ccc;
}

.template-option.create-new:hover {
  background-color: #f0f9f0;
  border-color: #4caf50;
}

.template-icon {
  margin-right: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 50px;
  flex-shrink: 0;
  color: #555;
}

.template-info {
  flex: 1;
  overflow: hidden;
}

.template-info h3 {
  font-size: 1.1rem;
  margin: 0 0 0.25rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.template-info p {
  font-size: 0.9rem;
  color: #666;
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.loading,
.no-templates {
  padding: 1rem;
  text-align: center;
  color: #666;
  background-color: #f9f9f9;
  border-radius: 8px;
  border: 1px solid #eee;
}
</style>
