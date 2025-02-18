<script setup>
import { useSupabaseClient } from '#imports';
import { useRouter } from 'vue-router';

const route = useRoute();
const isActive = (path) => route.path === path;
const localePath = useLocalePath();
const supabase = useSupabaseClient();
const router = useRouter();

const handleLogout = async () => {
  const { error } = await supabase.auth.signOut();
  if (error) {
    console.error('Logout failed:', error);
    alert(error.message);
  } else {
    router.push('/login'); 
  }
};
</script>

<template>
  <div class="flex h-screen">
    <WidgetsNavigationLeft :isActive="isActive" icon="HomeOutlined" text="Home" :path="localePath('/')" />

    <!-- main -->
    <div class="flex flex-col flex-grow bg-gray-100">
      <header class="bg-white shadow-md p-4 flex justify-between items-center">
        <h1 class="text-xl font-semibold">Welcome back, Dr. Elanowski</h1>
        <div class="flex items-center gap-4">
          <WidgetsLanguageSelector />
          <input
            type="text"
            placeholder="Search"
            class="border rounded px-4 py-2 h-[42px] focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <span
            @click="handleLogout"
            class="hover:underline cursor-pointer text-gray-500 hover:text-black py-2 px-4 rounded h-[42px] "
          >
            Logout
        </span>
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