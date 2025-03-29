<script setup lang="ts">
interface Props {
  variant?: "primary" | "secondary" | "tertiary" | "icon" | "text" | "outline";
  disabled?: boolean;
  iconRight?: string;
  iconLeft?: string;
  size?: "sm" | "md" | "lg";
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
    "bg-primary text-on-primary hover:bg-[var(--color-PrimaryHover)]":
      props.variant === "primary",
    "bg-secondary text-on-secondary hover:bg-[var(--color-SecondaryHover)]":
      props.variant === "secondary",
    "bg-tertiary text-on-tertiary hover:bg-[var(--color-TertiaryHover)]":
      props.variant === "tertiary",
    "bg-surface-container text-on-surface hover:bg-surface-container-high":
      props.variant === "icon",
    "bg-transparent text-primary hover:underline": props.variant === "text",
    "border border-primary text-primary hover:bg-[var(--color-PrimaryHover)] hover:text-[var(--color-OnPrimary)]":
      props.variant === "outline",

    // sizes
    "text-xs px-3 py-1.5": props.size === "sm",
    "text-sm px-4 py-2": props.size === "md",
    "text-base px-6 py-3": props.size === "lg",
  };
});
</script>

<template>
  <button
    :class="buttonClasses"
    :disabled="disabled"
    @click="(e) => emit('click', e)"
  >
    <Icon
      v-if="iconLeft"
      class="mr-2 h-4 w-4"
      :name="iconLeft"
    />
    <slot></slot>

    <Icon
      v-if="iconRight"
      class="ml-2 h-4 w-4"
      :name="iconRight"
    />
  </button>
</template>
