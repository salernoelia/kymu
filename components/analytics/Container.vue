<template>
    <div :class="['c flex flex-col gap-2 p-4', outline]">
        <slot></slot>
    </div>
</template>

<script setup>
defineProps({
    outline: {
        default: 'gray'
    }
})
</script>

<style lang="scss" scoped>
.c {
    border: 1px var(--color-outline_grayNormal) solid;
    background-color: white;
    border-radius: 0.6rem;
    width: 100%;
    min-height: 0;
    min-width: 0;

    .gray {
        border: 1px var(--color-outline_grayNormal) solid;
        background-color: white;
    }

    .primary {
        border: 1px var(--color-primaryNormal) solid;
        background-color: var(--color-primaryLight);
    }
}
</style>