<template>
  <div class="flex justify-center items-center h-screen">
    <div
      class="max-w-sm w-full flex flex-col items-center bg-white p-8 pt-10 pb-10 rounded-md shadow-md gap-4"
    >
      <h2 class="text-2xl font-bold ">Login</h2>

        <p
        v-if="errorMessage"
        class="text-error"
      >

        {{ errorMessage }}
      </p>
      <!-- form content -->

      <PrimitivesInput
        v-model="email"
        type="email"
        :variant="emailInputVariant"
        placeholder="Enter your email"
      />

      <PrimitivesInput
        v-model="password"
        type="password"
        :variant="passwordInputVariant"
        placeholder="Enter your password"
      />

      <!-- Alternative: nuxt-link but unsure how to navigate and check user credentials -->
      <!-- <div class="flex justify-center items-center pt-4 w-full">
        <nuxt-link
          @click="logIn"
          class="w-full bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 rounded cursor-pointer"
          >Login</nuxt-link
        >
      </div> -->

      <PrimitivesButton
        @click="logIn"
        variant="tertiary"
        >Login</PrimitivesButton

      <!-- toggle forms -->
      <div class=" text-center">
        <span class="text-gray-600"> Already have an account? </span>
        <NuxtLink
          :to="localePath('/signup')"
          class="text-gray-700 hover:text-black hover:underline cursor-pointer"
        >
          {{ $t("signup") }}
        </NuxtLink>
      </div>

    
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

const emailInputVariant = ref("default");
const passwordInputVariant = ref("default");

const logIn = async () => {
  try {
    if (!email.value && !password.value) {
      emailInputVariant.value = "error";
      passwordInputVariant.value = "error";
      errorMessage.value = "Please enter your email and password.";
      return;
    }

    if (!email.value || email.value.length < 3) {
      emailInputVariant.value = "error";
      errorMessage.value = "Please enter a valid email.";
      
      return;
    } 

    if (!password.value || password.value.length < 3) {
      passwordInputVariant.value = "error";
      errorMessage.value = "Please enter a valid password.";
      return;
    }

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


