<template>
  <div
    id="body"
    class="flex flex-col"
  >
    <NavigationTelevision />
    <Transition appear>
      <NavigationTelevisionMenu v-if="menu">
        <WidgetsLanguageSelector />
      </NavigationTelevisionMenu>
    </Transition>
    <main class="p-6 flex flex-col items-center justify-center flex-grow">
      <slot></slot>
    </main>
  </div>
</template>

<script setup lang="ts">
const menu = ref(false);
const { remoteKey } = useRemoteControl();

watch(remoteKey, (newKey) => {
  if (newKey === "menu") {
    console.log("Menu button pressed - toggling menu");
    menu.value = !menu.value;
  } else if (newKey === "cancel") {
    menu.value = false;
  }
});
</script>

<style scoped>
@keyframes gradientAnimation {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

#body {
  background: linear-gradient(118deg, #f0f8ff 30%, #f5f5f5 60%, #f0f8ff 90%);
  background-size: 150% 150%;
  height: 100vh;
  animation: gradientAnimation 30s ease infinite;
}

.v-enter-active,
.v-leave-active {
  transition: opacity 0.2s ease;
}

.v-enter-from,
.v-leave-to {
  opacity: 0;
}
</style>
