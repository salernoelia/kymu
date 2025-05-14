<template>
    <div class="tabs-container flex flex-row rounded-lg">
        <button
            v-for="tab in tabs"
            :key="tab.name"
            class="tab-item flex flex-row items-center justify-center p-2"
            :class="{ 'active': activeTab === tab.name }"
            @click="$emit('update:active', tab.name)"
        >
            <p>{{ tab.name }}</p>
        </button>
    </div>
</template>

<script setup>
const props = defineProps({
    tabs: {
        type: Array,
        required: true,
        default: () => []
    },
    active: {
        type: String,
        required: true
    }
});

const activeTab = computed(() => props.active);

defineEmits(['update:active']);
</script>

<style lang="scss" scoped>
.tabs-container {
    border: 1px var(--color-outline_grayNormal) solid;
    overflow: hidden;
    flex-wrap: nowrap;
}

.tab-item {
    border-right: 1px var(--color-outline_grayNormal) solid;
    width: auto; // change this line to let the content determine the width
    transition: all 0.2s ease-in-out;
    position: relative;

    &::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 2px;
        background-color: var(--color-outline_grayLight);
    }

    &:last-child {
        border-right: none;
    }

    &:hover {
        background-color: var(--color-outline_grayLight);
    }

    &.active {
        background-color: white;
        color: var(--color-outline_grayNormal);
    }
}
</style>