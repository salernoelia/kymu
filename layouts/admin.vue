<script setup>
import Toaster from '@/components/ui/toast/Toaster.vue'

const user = useSupabaseUser();
const route = useRoute();
const isActive = (path) => route.path === path;
const localePath = useLocalePath();
const client = useSupabaseClient();
const authReady = ref(false);

const therapist = ref(null);

onMounted(async () => {
  await fetchTherapist();
});

const fetchTherapist = async () => {
  if (!user.value) {
    console.error("User not logged in");
    return;
  }
  const { data, error } = await client
    .from("therapists")
    .select("first_name, last_name")
    .eq("uid", user.value.id);
  if (error) {
    console.error("Error fetching user data", error);
    return;
  }
  therapist.value = data[0];
};

watch(user, (newUser) => {
  authReady.value = true;
});
</script>

<template>
  <div class="parent">
    <NavigationAdminLeft
      :isActive="isActive"
      icon="HomeOutlined"
      text="Home"
      :path="localePath('/')"
    />

    <main class="w-full h-full overflow-hidden p-6">
      <slot />
    </main>
  </div>
  <Toaster class="z-50">
    <template #toast="{ toast }"> </template>
  </Toaster  />
</template>

<style scoped lang="scss">
body {
  overflow: hidden;
}
.parent {
  display: flex;
  position: absolute;
  inset: 0;
  overflow: hidden;
  background: linear-gradient(118deg, #f7f9ff 16.96%, #fbf5f5 75.42%);
}
</style>
