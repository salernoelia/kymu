<template>
    <UCard class="max-w-sm w-full">
        <h2 class="text-2xl font-bold mb-4">Sign Up</h2>
  
      <!-- form content -->
      <UFormGroup label="Full Name" name="name"  class="py-2">
        <UInput v-model="name" type="name" placeholder="Enter your name" color="grey"/>
      </UFormGroup>
  
      <UFormGroup label="Email" name="email"  class="py-2">
        <UInput v-model="email" type="email" placeholder="Enter your email" color="grey"/>
      </UFormGroup>
  
      <UFormGroup label="Password" name="password" class="py-2">
        <UInput v-model="password" type="password" placeholder="Enter your password" color="grey" />
      </UFormGroup>
  
      <!-- submit btn -->
      <div class="flex justify-center items-center pt-4 w-full">
     <nuxt-link @click="signUp" class="w-full bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 rounded cursor-pointer">Sign Up</nuxt-link>
   </div>
  
      <!-- toggle forms -->
      <div class="mt-4 text-center">
          <span class="text-gray-500">
            Already have an account?
          </span>
          <NuxtLink :to="localePath('/login')" class="text-gray-500 hover:text-black hover:underline cursor-pointer">
            {{ $t('login') }}
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

  
  async function signUp() {
    try {
      const { error } = await client.auth.signUp({
        email: email.value,
        password: password.value,
      });
  
      if (error) throw error;
      successMessage.value = 'Please check your email to verify your account.';
    } catch (error) {
      errorMessage.value = error.message;
    }
  }

  </script>