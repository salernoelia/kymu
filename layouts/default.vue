<script setup>
import {
  HomeOutlined,
  UsergroupAddOutlined,
  PlusCircleOutlined,
  CheckCircleOutlined,
  FolderOpenOutlined,
  BarChartOutlined,
  SettingOutlined,
  UserOutlined,
  FileTextOutlined,
} from "@ant-design/icons-vue";
import { useRoute } from "vue-router";



const route = useRoute();

const isActive = (path) => route.path === path;

</script>

<template>
  <div class="flex h-screen">
    <aside class="sidebar bg-gray-900 text-white w-64 flex flex-col ">
      <div class="p-4 text-xl font-semibold">
        ReGain Platform
      </div>
      <!-- nav -->
      <div class="flex flex-col justify-between h-full">
        <div>
          <nav class="flex flex-col pt-4">

            <nuxt-link to="/"
              :class="['flex items-center p-4 rounded transition', isActive('/') ? 'bg-blue-700' : 'hover:bg-gray-700']">
              <HomeOutlined class="mr-3" />
              Dashboard
            </nuxt-link>

            <nuxt-link to="/patients"
              :class="['flex items-center p-4 rounded transition', isActive('/patients') ? 'bg-blue-700' : 'hover:bg-gray-700']">
              <UsergroupAddOutlined class="mr-3" />
              Patients
            </nuxt-link>

            <nuxt-link to="/exercisesAlt"
              :class="['flex items-center p-4 rounded transition', isActive('/exercisesAlt') ? 'bg-blue-700' : 'hover:bg-gray-700']">
              <PlusCircleOutlined class="mr-3" />
              Create Exercises
            </nuxt-link>
            <nuxt-link to="/training-programs"
              :class="['flex items-center p-4 rounded transition', isActive('/training-programs') ? 'bg-blue-700' : 'hover:bg-gray-700']">
              <CheckCircleOutlined class="mr-3" />
              Training Programs
            </nuxt-link>

            <nuxt-link to="/reports"
              :class="['flex items-center p-4 rounded transition', isActive('/reports') ? 'bg-blue-700' : 'hover:bg-gray-700']">
              <BarChartOutlined class="mr-3" />
              Progress Reports
            </nuxt-link>

            <nuxt-link to="/library"
              :class="['flex items-center p-4 rounded transition', isActive('/library') ? 'bg-blue-700' : 'hover:bg-gray-700']">
              <FolderOpenOutlined class="mr-3" />
              Exercise Library
            </nuxt-link>

            <nuxt-link to="/documentation"
              :class="['flex items-center p-4 rounded transition', isActive('/documentation') ? 'bg-blue-700' : 'hover:bg-gray-700']">
              <FileTextOutlined class="mr-3" />
              Documentation
            </nuxt-link>
          </nav>
        </div>
        <div>
          <nuxt-link to="/settings"
            :class="['flex items-center p-4 rounded transition', isActive('/settings') ? 'bg-blue-700' : 'hover:bg-gray-700']">
            <SettingOutlined class="mr-3" />
            Settings
          </nuxt-link>

          <nuxt-link to="/profile"
            :class="['flex items-center p-4 rounded transition', isActive('/profile') ? 'bg-blue-700' : 'hover:bg-gray-700']">
            <UserOutlined class="mr-3" />
            Profile
          </nuxt-link>
        </div>
      </div>
    </aside>

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