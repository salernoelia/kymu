<template>
  <input
    :type="type"
    :placeholder="placeholder || 'Patient suchen..'"
    :disabled="disabled"
    :value="modelValue"
    @input="
      $emit('update:modelValue', ($event.target as HTMLInputElement).value)
    "
    :class="[
      'flex h-10 w-full rounded-lg border text-sm',
      'placeholder:text-gray-500 focus-visible:outline-none focus-visible:ring-1',
      'disabled:cursor-not-allowed disabled:opacity-50',
      variantClasses,
    ]"
  />
</template>

<script setup lang="ts">
const props = defineProps({
  modelValue: {
    type: [String, Number],
    default: "",
  },
  placeholder: {
    type: String,
    default: "Patient suchen..",
  },
  disabled: {
    type: Boolean,
    default: false,
  },
  type: {
    type: String,
    default: "text",
    validator: (value: string) => ["text", "email", "password"].includes(value),
  },
  variant: {
    type: String,
    default: "default",
    validator: (value: string) =>
      ["default", "outline", "filled", "ghost", "error"].includes(value),
  },
});

defineEmits(["update:modelValue"]);

const variantClasses = computed(() => {
  switch (props.variant) {
    case "outline":
      return "border-primary bg-transparent px-3 py-2 focus-visible:ring-primary";
    case "filled":
      return "border-transparent bg-surface-container px-3 py-2 focus-visible:ring-primary";
    case "ghost":
      return "border-transparent bg-transparent px-3 py-2 focus-visible:ring-primary";
    default:
      return "border-gray-400 bg-white px-3 py-2 focus-visible:ring-secondary";
    case "error":
      return "border-red-500 bg-red-50 px-3 py-2 focus-visible:ring-red-500";
  }
});
</script>
