<script setup>
const route = useRoute();

const isActive = (path) => route.path === path;

</script>

<template>
  <div class="flex h-screen">

    <WidgetsNavigationLeft :isActive="isActive" icon="HomeOutlined" text="Home" path="/" />

    <!-- main -->
    <div class="flex flex-col flex-grow bg-gray-100">
      <header class="bg-white shadow-md p-4 flex justify-between items-center">
        <h1 class="text-xl font-semibold">Welcome back, Dr. Elanowski</h1>
        <div class="flex items-center">
          <input type="text" placeholder="Search"
            class="border rounded px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          <p class="text-gray-500 text-sm ml-2">
            Jan 9, 2025
          </p>
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