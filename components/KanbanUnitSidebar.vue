<template>
    <Transition name="slide">
        <div v-if="isOpen" ref="sidebar" class="sidebar" :class="{ 'sidebar--open': isOpen }">
            <div class="sidebar__header">
                <h2 v-if="title" class="sidebar__title">{{ title }}</h2>
                <button class="sidebar__close" @click="close">
                    <span class="sr-only">Close</span>
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
                        stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </button>
            </div>
            <div class="sidebar__content">
                <slot></slot>
            </div>
        </div>
    </Transition>
    <Transition name="fade">
        <div v-if="isOpen && overlay" class="sidebar-overlay" @click="close"></div>
    </Transition>
</template>

<script setup lang="ts">
const props = defineProps({
    modelValue: {
        type: Boolean,
        default: false
    },
    title: {
        type: String,
        default: ''
    },
    width: {
        type: String,
        default: '400px'
    },
    overlay: {
        type: Boolean,
        default: true
    }
});

const emit = defineEmits(['update:modelValue', 'closed']);

const isOpen = ref(props.modelValue);

watch(() => props.modelValue, (newValue) => {
    isOpen.value = newValue;
});

const close = () => {
    isOpen.value = false;
    emit('update:modelValue', false);
    emit('closed');
};

// Expose method to open the sidebar
defineExpose({
    open: () => {
        isOpen.value = true;
        emit('update:modelValue', true);
    },
    close
});
</script>

<style scoped lang="scss">
.sidebar {
    position: fixed;
    right: 0;
    top: 0;
    height: 100vh;
    background-color: #ffffff;
    box-shadow: -4px 0 12px rgba(0, 0, 0, 0.1);
    padding: 0;
    z-index: 999;
    display: flex;
    flex-direction: column;
    width: v-bind('width');
    border-radius: 0.5rem 0 0 0.5rem;

    &__header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 16px 20px;
        border-bottom: 1px solid #ededed;
    }

    &__title {
        font-size: 1.25rem;
        font-weight: 600;
        margin: 0;
    }

    &__close {
        background: transparent;
        border: none;
        cursor: pointer;
        padding: 4px;
        border-radius: 4px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #666;
        transition: all 0.2s ease;

        &:hover {
            background-color: #f3f4f6;
            color: #000;
        }
    }

    &__content {
        flex: 1;
        padding: 20px;
        overflow-y: auto;
    }
}

.sidebar-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 998;
}

// Transitions
.slide-enter-active,
.slide-leave-active {
    transition: transform 0.5s ease-in-out;
}

.slide-enter-from,
.slide-leave-to {
    transform: translateX(100%);
}

.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.5s ease-in-out;
}

.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}

.sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border-width: 0;
}
</style>