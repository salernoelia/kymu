<script setup lang="ts">
const props = defineProps<{
  modelValue?: string | number;
  placeholder?: string;
  disabled?: boolean;
}>();

const emits = defineEmits<{
  (e: "update:modelValue", payload: string | number): void;
}>();
</script>

<template>
  <div class="relative w-full">
    <input
      :value="modelValue"
      @input="
        emits('update:modelValue', ($event.target as HTMLInputElement).value)
      "
      type="text"
      :placeholder="placeholder || 'Patient suchen..'"
      :disabled="disabled"
      :class="[
        'flex h-10 w-full rounded-lg border border-gray-200 bg-white px-3 py-2 text-sm',
        'placeholder:text-gray-500 focus-visible:outline-none focus-visible:ring-1',
        'focus-visible:ring-[var(--color-secondary-dark)] ',
        'disabled:cursor-not-allowed disabled:opacity-50',
        props.class,
      ]"
    />
  </div>
</template>
