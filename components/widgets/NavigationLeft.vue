<template>
  <aside class="sidebar bg-gray-900 text-white w-64 flex flex-col">
    <div class="p-4 text-xl font-semibold">Kymu</div>
    <!-- nav -->
    <div class="flex flex-col justify-between h-full">
      <div>
        <nav class="flex flex-col pt-4">
          <nuxt-link
            :to="localePath('/')"
            :class="[
              'flex items-center p-4 rounded transition',
              isActive('/') ? 'bg-blue-700' : 'hover:bg-gray-700',
            ]"
          >
            <!-- <HomeOutlined class="mr-3" /> -->
            Home
          </nuxt-link>
          <nuxt-link
            :to="localePath('/viewer')"
            :class="[
              'flex items-center p-4 rounded transition',
              isActive('/viewer') ? 'bg-blue-700' : 'hover:bg-gray-700',
            ]"
          >
            <!-- <HomeOutlined class="mr-3" /> -->
            VR Viewer
          </nuxt-link>

          <nuxt-link
            :to="localePath('/editor')"
            :class="[
              'flex items-center p-4 rounded transition',
              isActive('/editor') ? 'bg-blue-700' : 'hover:bg-gray-700',
            ]"
          >
            <!-- <UsergroupAddOutlined class="mr-3" /> -->

            Editor
          </nuxt-link>

          <nuxt-link
            :to="localePath('/patients')"
            :class="[
              'flex items-center p-4 rounded transition',
              isActive('/patients') ? 'bg-blue-700' : 'hover:bg-gray-700',
            ]"
          >
            <!-- <UsergroupAddOutlined class="mr-3" /> -->
            Patients
          </nuxt-link>

          <!-- <nuxt-link
            :to="localePath('/exercisesAlt')"
            :class="[
              'flex items-center p-4 rounded transition',
              isActive('/exercisesAlt') ? 'bg-blue-700' : 'hover:bg-gray-700',
            ]"
          >
            <PlusCircleOutlined class="mr-3" />
            Create Exercises
          </nuxt-link> -->
          <nuxt-link
            :to="localePath('/training-programs')"
            :class="[
              'flex items-center p-4 rounded transition',
              isActive('/training-programs')
                ? 'bg-blue-700'
                : 'hover:bg-gray-700',
            ]"
          >
            <!-- <CheckCircleOutlined class="mr-3" /> -->
            Explore Kymu
          </nuxt-link>
          <!-- <nuxt-link
            :to="localePath('/training-programs')"
            :class="[
              'flex items-center p-4 rounded transition',
              isActive('/training-programs')
                ? 'bg-blue-700'
                : 'hover:bg-gray-700',
            ]"
          >
            <CheckCircleOutlined class="mr-3" />
            Training Programs
          </nuxt-link> -->
          <!-- 
          <nuxt-link
            :to="localePath('/reports')"
            :class="[
              'flex items-center p-4 rounded transition',
              isActive('/reports') ? 'bg-blue-700' : 'hover:bg-gray-700',
            ]"
          >
            <BarChartOutlined class="mr-3" />
            Progress Reports
          </nuxt-link> -->
          <!-- 
          <nuxt-link
            :to="localePath('/library')"
            :class="[
              'flex items-center p-4 rounded transition',
              isActive('/library') ? 'bg-blue-700' : 'hover:bg-gray-700',
            ]"
          >
            <FolderOpenOutlined class="mr-3" />
            Exercise Library
          </nuxt-link> -->

          <!-- <nuxt-link
            :to="localePath('/documentation')"
            :class="[
              'flex items-center p-4 rounded transition',
              isActive('/documentation') ? 'bg-blue-700' : 'hover:bg-gray-700',
            ]"
          >
            <FileTextOutlined class="mr-3" />
            Documentation
          </nuxt-link> -->
        </nav>
      </div>
      <div>
        <nuxt-link
          to="/settings"
          :class="[
            'flex items-center p-4 rounded transition',
            isActive('/settings') ? 'bg-blue-700' : 'hover:bg-gray-700',
          ]"
        >
          <!-- <SettingOutlined class="mr-3" /> -->
          Settings
        </nuxt-link>

        <nuxt-link
          to="/profile"
          :class="[
            'flex items-center p-4 rounded transition',
            isActive('/profile') ? 'bg-blue-700' : 'hover:bg-gray-700',
          ]"
        >
          <!-- <UserOutlined class="mr-3" /> -->
          Profile
        </nuxt-link>
      </div>
    </div>
  </aside>
</template>

<script setup lang="ts">
const localePath = useLocalePath();

defineProps({
  isActive: {
    type: Function,
    required: true,
  },
});
</script>

<style scoped></style>
