<template>
  <Transition name="slide">
    <div
      v-if="editorStore.sidebarOpen"
      class="sidebar"
    >
      <Icon
        name="material-symbols-light:close-rounded"
        class="absolute top-4 right-4 w-6 h-6 cursor-pointer"
        @click="editorStore.sidebarOpen = false"
      />
      <slot></slot>
    </div>
  </Transition>
  <Transition name="fade">
    <div
      v-if="editorStore.sidebarOpen"
      class="sidebarScreenBackdrop"
      @click="dialog = true"
    ></div>
  </Transition>
  <WidgetsDiscardDialog
    v-if="dialog"
    :onSave="() => ((editorStore.sidebarOpen = false), (dialog = false))"
    :onDiscard="() => ((editorStore.sidebarOpen = false), (dialog = false))"
  >
  </WidgetsDiscardDialog>
</template>

<script setup lang="ts">
const editorStore = useEditorStore();

const dialog = ref(false);
</script>

<style scoped>
.sidebar {
  width: 50%;
  height: 100vh;
  position: absolute;
  right: 0;
  top: 0;
  background-color: #fff;
  border-radius: 5px 0 0 5px;
  border-left: 1px solid var(--color-Stroke);
  z-index: 1000;
}

.sidebarScreenBackdrop {
  width: 100vw;
  height: 100vh;
  position: fixed;
  left: 0;
  top: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 999;
}

/* Animation for sidebar */
.slide-enter-active,
.slide-leave-active {
  transition: transform 0.3s ease;
}

.slide-enter-from,
.slide-leave-to {
  transform: translateX(100%);
}

/* Animation for backdrop */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
