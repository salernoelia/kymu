<template>
  <div
    id="body"
    class="flex flex-col"
  >
    <NavigationTelevision />
    <Transition appear>
      <NavigationTelevisionMenu v-if="menu">
        <WidgetsLanguageSelector />
        <NuxtLink
          @click="handleLogout"
          class="link mb-2"
        >
          <Icon
            name="material-symbols-light:logout"
            class="icon"
          />
        </NuxtLink>
      </NavigationTelevisionMenu>
    </Transition>
    <main class="p-6 flex flex-col items-center justify-center flex-grow">
      <slot></slot>
    </main>
  </div>
</template>

<script setup lang="ts">
const menu = ref(false);
const supabase = useSupabaseClient();
const localePath = useLocalePath();
const { toggleFullscreen } = useFullscreen();
const { remoteKey } = useRemoteControl();

watch(
  () => remoteKey.value,
  (newKey) => {
    if (newKey === "menu") {
      console.log("Menu button pressed - toggling menu");
      menu.value = !menu.value;
    } else if (newKey === "back") {
      if (menu.value) {
        menu.value = false;
      } else if (useRoute().path == "/tv") {
        console.log("already home");
      } else {
        useRouter().back();
      }
    } else if (newKey === "fullscreen") {
      console.log("Fullscreen button pressed - toggling fullscreen");
      toggleFullscreen();
    }
  }
);

const handleLogout = async () => {
  try {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
    navigateTo(localePath("/auth/login"));
  } catch (error: any) {
    console.log(error.message);
  }
};
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

.link {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0.5rem 1rem;
  border-radius: 0.4rem;
  transition: all 0.2s ease;
}

.link {
  &:hover {
    background-color: var(--color-Gray-400);
  }
  .icon {
    width: 1.5rem;
    height: 1.5rem;
  }
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
