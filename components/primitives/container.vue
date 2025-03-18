<script setup lang="ts">
import { computed } from "vue";

interface Props {
  variant?: "white" | "transparent";
  interactive?: boolean;
  class?: string;
}

const props = withDefaults(defineProps<Props>(), {
  variant: "white",
  interactive: true,
  class: "",
});

const containerClasses = computed(() => {
  return {
    //base
    "rounded-lg border border-gray-200": true,
    "p-6": true,

    //variant
    "bg-white": props.variant === "white",
    "bg-transparent": props.variant === "transparent",

    "cursor-pointer": props.interactive,
    "hover:bg-gray-100": props.interactive,
    "hover:shadow-md": props.interactive,
    "transition-all": props.interactive,
  };
});
</script>

<template>
  <div :class="[containerClasses, props.class]">
    <slot></slot>
  </div>
</template>
