

<template>
  <div class="parent">
    <NavigationAdminLeft
      :isActive="isActive"
      icon="HomeOutlined"
      text="Home"
      :path="localePath('/')"
    />

    <main class="w-full h-full overflow-hidden p-6">

      <Transition
        appear
        v-if="!isLoadingPage"
      >
        <div class="flex flex-col gap-4">
          <NavigationBreadcrumbs
            :breadcrumbs="[
              {
                path: '/admin/patients',
                translationKey: 'patient-overview-title',
              },
              {
                path: `/admin/${route.params.patientid}`,
                translationKey: 'patient-info',
              },
              {
                path: `/admin/${route.params.patientid}/editor/`,
                translationKey: 'unit-editor-title',
              },
            ]"
          />

          <h1 class="text-2xl font-bold">{{ $t("unit-editor-title") }}</h1>

          <slot />
        </div>
      </Transition>
      <div
        v-else
        class="flex items-center justify-center h-full"
      >
        <Icon
          name="svg-spinners:180-ring"
          size="3rem"
        />
      </div>
    </main>
  </div>
  <Toaster class="z-50">
    <template #toast="{ toast }"> </template>
  </Toaster  />
</template>

<script setup lang="ts">
import Toaster from "@/components/ui/toast/Toaster.vue";

const route = useRoute();
const localePath = useLocalePath();
const client = useSupabaseClient();
const authReady = ref(false);

const isLoadingPage = ref(true);

onMounted(() => {
  isLoadingPage.value = false;
});

const user = useSupabaseUser();

const isActive = (path: string) => route.path === path;


const therapist = ref<any>(null);

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
