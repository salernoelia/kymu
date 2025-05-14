<template>
    <div class="tabs-container flex flex-row rounded-lg">
        <button
            v-for="tab in tabs"
            :key="tab.name"
            class="tab-item flex flex-row items-center justify-center p-3"
            :class="{ 'active': activeTab === tab.name }"
            @click="$emit('update:active', tab.name)"
        >
            <h4>{{ tab.name }}</h4>
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
    // border: 1px var(--color-outline_grayNormal) solid;
    overflow: hidden;
}

.tab-item {
    // border-right: 1px var(--color-outline_grayNormal) solid;
    width: 100%;
    transition: all 0.2s ease-in-out;
    position: relative;

    &::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 1px;
        background-color: var(--color-outline_grayNormal);
    }

    &:last-child {
        border-right: none;
    }

    &:hover {
        background-color: var(--color-outline_grayLight);
    }

    &.active {
        // background-color: var(--color-primaryLight);
        color: var(--color-primaryNormal);

        &::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 2px;
            background-color: var(--color-primaryNormal);
        }
    }
}
</style>