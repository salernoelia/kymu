<script setup lang="ts">
interface Props {
  variant?: "primary" | "secondary" | "icon" | "text";
  disabled?: boolean;
  iconRight?: string;
  size?: "md";
}

const props = withDefaults(defineProps<Props>(), {
  variant: "primary",
  size: "md",
  disabled: false,
  iconLeft: "",
  iconRight: "",
});

const emit = defineEmits<{
  (e: "click", event: MouseEvent): void;
}>();

const buttonClasses = computed(() => {
  return {
    // base
    "inline-flex items-center justify-center rounded-lg font-medium transition-colors":
      true,
    "focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2": true,
    "disabled:opacity-50 disabled:pointer-events-none": true,

    // variants
    "bg-[var(--color-primary)] text-white hover:bg-[var(--color-primary-dark)]":
      props.variant === "primary",
    "bg-[var(--color-secondary)] text-[var(--color-text)] hover:bg-[var(--color-secondary-dark)]":
      props.variant === "icon",
    "border bg-white text-gray-700 hover:bg-gray-100":
      props.variant === "secondary",
    "bg-transparent text-[var(--color-primary)] hover:underline":
      props.variant === "text",

    // text size
    "text-sm px-4 py-2": props.size === "md",
  };
});
</script>

<template>
  <button
    :class="buttonClasses"
    :disabled="disabled"
    @click="(e) => emit('click', e)"
  >
    <slot></slot>

    <span
      v-if="iconRight"
      class="ml-2"
    >
      <component :is="iconRight" />
    </span>
  </button>
</template>
