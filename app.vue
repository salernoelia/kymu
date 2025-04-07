<template>
  <div>
    <NuxtLayout>
      <NuxtPage
        :transition="{
          name: 'bounce',
          mode: 'out-in',
        }"
      />
    </NuxtLayout>
  </div>
</template>

<script setup>
const userRoleStore = useUserRoleStore();
const supabaseUser = useSupabaseUser();

onMounted(async () => {
  if (supabaseUser.value) {
    await userRoleStore.determineUserRole();
  }
});
</script>
