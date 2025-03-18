<template>
  <div
    :class="[
      'flex',
      orientation === 'horizontal' ? 'w-full' : 'h-full',
      marginClasses,
    ]"
    role="separator"
    :aria-orientation="orientation"
  >
    <hr
      :class="[
        'border-0',
        orientation === 'horizontal'
          ? 'w-full border-t'
          : 'h-full border-l self-stretch',
        `border-${color}`,
        thickness === 'thin' ? 'border-[0.5px]' : 'border-[1px]',
      ]"
    />
  </div>
</template>

<script setup lang="ts">
interface Props {
  orientation?: "horizontal" | "vertical";
  color?: string;
  thickness?: "thin" | "normal";
  marginLeft?: number;
  marginRight?: number;
  marginTop?: number;
  marginBottom?: number;
}

const props = withDefaults(defineProps<Props>(), {
  orientation: "horizontal",
  color: "gray-200",
  thickness: "thin",
  marginLeft: 0,
  marginRight: 0,
  marginTop: 0,
  marginBottom: 0,
});

const marginClasses = computed(() => {
  return [
    props.marginLeft ? `ml-${props.marginLeft}` : "",
    props.marginRight ? `mr-${props.marginRight}` : "",
    props.marginTop ? `mt-${props.marginTop}` : "",
    props.marginBottom ? `mb-${props.marginBottom}` : "",
  ]
    .filter(Boolean)
    .join(" ");
});
</script>
