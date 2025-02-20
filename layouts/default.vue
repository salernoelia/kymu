<script setup>
const user = useSupabaseUser();
const router = useRouter();
const route = useRoute();
const isActive = (path) => route.path === path;
const localePath = useLocalePath();
const client = useSupabaseClient();
const authReady = ref(false);

const handleLogout = async () => {
  try {
    const { error } = await client.auth.signOut();
    if (error) throw error;
    navigateTo(localePath('/login'));
  } catch (error) {
    console.log(error.message);
  }
};

watch(user, (newUser) => {
  authReady.value = true;
  console.log("user", newUser);
});
</script>


<template>

  <div class="flex h-screen">
    <WidgetsNavigationLeft :isActive="isActive" icon="HomeOutlined" text="Home" :path="localePath('/')" />
    <div class="flex flex-col flex-grow bg-gray-100">
      <header class="bg-white shadow-md p-4 flex justify-between items-center">
        <h1 class="text-xl font-semibold">Welcome back, {{ user.email }}</h1>
        <div class="flex items-center gap-4">
          <WidgetsLanguageSelector />
          <input
            type="text"
            placeholder="Search"
            class="border rounded px-4 py-2 h-[42px] focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        <NuxtLink @click="handleLogout" class="hover:underline cursor-pointer text-gray-500 hover:text-black py-2 px-4 rounded h-[42px]">
          Logout
      </NuxtLink>
        </div>
      </header>

      <main class="flex-grow p-6 overflow-auto">
        <div class="flex justify-center items-center pt-20 w-full">
          <slot />
        </div>
      </main>
    </div>
  </div>

</template>