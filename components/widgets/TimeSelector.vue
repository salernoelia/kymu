<script setup lang="ts">
interface Props {
  modelValue: string;
}

const timePeriods = [
  { label: "SL", value: "since-last" },
  { label: "W", value: "week" },
  { label: "M", value: "month" },
  { label: "6M", value: "six-months" },
];

const props = defineProps<Props>();

const emit = defineEmits<{
  (e: "update:modelValue", value: string): void;
}>();

const handleTabChange = (newValue: string) => {
  emit("update:modelValue", newValue);
};
</script>

<template>
  <div>
    <PrimitivesTab
      :tabs="timePeriods"
      :modelValue="modelValue"
      @update:modelValue="handleTabChange"
    />
  </div>
</template>
