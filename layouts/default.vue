<script setup>
const user = useSupabaseUser();
const route = useRoute();
const isActive = (path) => route.path === path;
const localePath = useLocalePath();
const client = useSupabaseClient();
const authReady = ref(false);

const therapist = ref(null);

onMounted(async () => {
  if (!user.value) {
    navigateTo(localePath("/login"));
  }

  await fetchTherapist();
});

const handleLogout = async () => {
  try {
    const { error } = await client.auth.signOut();
    if (error) throw error;
    navigateTo(localePath("/login"));
  } catch (error) {
    console.log(error.message);
  }
};

const fetchTherapist = async () => {
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
  console.log("user", newUser);
});
</script>

<template>
  <div class="flex h-screen">
    <WidgetsNavigationLeft
      :isActive="isActive"
      icon="HomeOutlined"
      text="Home"
      :path="localePath('/')"
    />
    <div class="flex flex-col flex-grow bg-gray-100">
      <header class="bg-white shadow-md p-4 flex justify-between items-center">
        <h1 class="text-xl font-semibold">
          {{ $t("welcome-back") }}, {{ therapist?.first_name }}
          {{ therapist?.last_name }}
        </h1>
        <div class="flex items-center gap-4">
          <WidgetsLanguageSelector />
          <NuxtLink
            @click="handleLogout"
            class="hover:underline cursor-pointer text-gray-500 hover:text-black py-2 px-4 rounded h-[42px]"
          >
            Logout
          </NuxtLink>
        </div>
      </header>

      <main class="p-4">
        <slot />
      </main>
    </div>
  </div>
</template>
