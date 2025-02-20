<template>
  <UCard class="max-w-sm w-full ">
      <h2 class="text-2xl font-bold mb-4">Login</h2>

  <!-- form content -->
  <UFormGroup label="Email" name="email"  class="py-2">
    <UInput v-model="email" type="email" placeholder="Enter your email" color="grey"/>
  </UFormGroup>

  <UFormGroup label="Password" name="password" class="py-2">
    <UInput v-model="password" type="password" placeholder="Enter your password" color="grey" />
  </UFormGroup>

    <!-- submit btn -->
    <!-- <UButton
      @click="logIn"
      :label="'Login'"
      class="w-full bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 rounded"
    /> -->
  <!-- Alternative: nuxt-link but unsure how to navigate and check user credentials -->
   <div class="flex justify-center items-center pt-4 w-full">
     <nuxt-link @click="logIn" class="w-full bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 rounded cursor-pointer">Login</nuxt-link>
   </div>

    <!-- toggle forms -->
    <div class="mt-4 text-center">
        <span class="text-gray-500">
          Already have an account?
        </span>
        <NuxtLink :to="localePath('/register')"  class="text-gray-500 hover:text-black hover:underline cursor-pointer">
          {{ $t('signup') }}
      </NuxtLink>
    </div>

    <UAlert v-if="errorMessage" icon="i-heroicons-information-circle-20-solid" :title="errorMessage" class="mt-4 border-solid border-2 border-red-500 text-red-500" />
  </UCard>
</template>



<script setup>
const localePath = useLocalePath();
const client = useSupabaseClient();
const email = ref('');
const password = ref('');
const errorMessage = ref('');


const logIn = async () => {
  try {
    const { error } = await client.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    });

    if (error) throw error;
    return navigateTo(localePath('/confirm'));
    }
    catch (error) {
      errorMessage.value = error.message;
    }
};
</script>