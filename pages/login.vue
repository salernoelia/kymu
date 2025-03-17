<template>
  <div class="flex justify-center items-center h-screen">
    <div class="max-w-sm w-full">
      <h2 class="text-2xl font-bold mb-4">Login</h2>

      <!-- form content -->
      <form
        label="Email"
        name="email"
        class="py-2"
      >
        <input
          v-model="email"
          type="email"
          placeholder="Enter your email"
          color="grey"
        />
      </form>

      <form
        label="Password"
        name="password"
        class="py-2"
      >
        <input
          v-model="password"
          type="password"
          placeholder="Enter your password"
          color="grey"
        />
      </form>

      <!-- Alternative: nuxt-link but unsure how to navigate and check user credentials -->
      <div class="flex justify-center items-center pt-4 w-full">
        <nuxt-link
          @click="logIn"
          class="w-full bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 rounded cursor-pointer"
          >Login</nuxt-link
        >
      </div>

      <!-- toggle forms -->
      <div class="mt-4 text-center">
        <span class="text-gray-500"> Already have an account? </span>
        <NuxtLink
          :to="localePath('/signup')"
          class="text-gray-500 hover:text-black hover:underline cursor-pointer"
        >
          {{ $t("signup") }}
        </NuxtLink>
      </div>

      <p
        v-if="errorMessage"
        icon="i-heroicons-information-circle-20-solid"
        :title="errorMessage"
        class="mt-4 border-solid border-2 border-red-500 text-red-500"
      />
    </div>
  </div>
</template>

<script setup>
definePageMeta({
  layout: "auth",
});

const localePath = useLocalePath();
const client = useSupabaseClient();
const email = ref("");
const password = ref("");
const errorMessage = ref("");

const logIn = async () => {
  try {
    const { error } = await client.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    });

    if (error) throw error;
    return navigateTo(localePath("/confirm"));
  } catch (error) {
    errorMessage.value = error.message;
  }
};
</script>
