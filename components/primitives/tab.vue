<script setup lang="ts">
interface Tab {
  label: string;
  value: string;
}

const props = defineProps<{
  tabs: Tab[];
  modelValue: string;
}>();

const emit = defineEmits<{
  (e: "update:modelValue", value: string): void;
}>();

const selectTab = (value: string) => {
  emit("update:modelValue", value);
};

const containerClasses = {
  flex: true,
  "overflow-hidden": true,
  border: true,
  "rounded-lg": true,
};

const getTabClasses = (tabValue: string) => {
  const isActive = props.modelValue === tabValue;
  //active/inactive
  return {
    "transition-colors": true,
    "font-medium": true,
    "px-4": true,
    "py-2": true,
    "rounded-lg": true,
    "text-sm": true,
    "bg-white": isActive,
    border: isActive,
    "text-black": isActive,
    "text-gray-700": !isActive,
    "hover:bg-gray-100": !isActive,
  };
};
</script>

<template>
  <div :class="containerClasses">
    <button
      v-for="tab in tabs"
      :key="tab.value"
      @click="selectTab(tab.value)"
      :class="getTabClasses(tab.value)"
    >
      {{ tab.label }}
    </button>
  </div>
</template>
