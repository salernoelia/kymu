<template>
  <UCard class="max-w-sm w-full">
    <!-- header -->
    <template v-if="isLogin">
      <h2 class="text-2xl font-bold mb-4">Login</h2>
    </template>
    <template v-else>
      <h2 class="text-2xl font-bold mb-4">Sign Up</h2>
    </template>

    <!-- form content -->
    <UFormGroup v-if="!isLogin" label="Full Name" name="name"  class="py-2">
      <UInput v-model="name" type="name" placeholder="Enter your name" color="grey"/>
    </UFormGroup>

    <UFormGroup label="Email" name="email"  class="py-2">
      <UInput v-model="email" type="email" placeholder="Enter your email" color="grey"/>
    </UFormGroup>

    <UFormGroup label="Password" name="password" class="py-2">
      <UInput v-model="password" type="password" placeholder="Enter your password" color="grey" />
    </UFormGroup>

    <!-- submit btn -->
    <UButton
      @click="handleSubmit"
      :label="isLogin ? 'Login' : 'Sign Up'"
      class="w-full bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 rounded"
    />

    <!-- toggle forms -->
    <div class="mt-4 text-center">
      <template v-if="isLogin" >
        <span class="text-gray-500">
          Don't have an account?
        </span>
        <span link @click="toggleForm" class="text-gray-500 hover:text-black hover:underline cursor-pointer">Sign Up</span>
      </template>
      <template v-else>
        <span class="text-gray-500">
          Already have an account?
        </span>
        <span link @click="toggleForm" class="text-gray-500 hover:text-black hover:underline cursor-pointer">Login</span>
      </template>
    </div>

    <UAlert v-if="errorMessage" icon="i-heroicons-information-circle-20-solid" :title="errorMessage" class="mt-4 border-solid border-2 border-red-500 text-red-500" />
  </UCard>
</template>

<script setup>
import { ref } from 'vue';
import { useSupabaseClient } from '#imports';
import { useRouter } from 'vue-router';

const isLogin = ref(true);
const email = ref('');
const password = ref('');
const router = useRouter();
const supabase = useSupabaseClient();
const errorMessage = ref('');

const toggleForm = () => {
  isLogin.value = !isLogin.value;
  errorMessage.value = ''; 
};

const handleSubmit = async () => {
  errorMessage.value = ''; 
  if (isLogin.value) {
    //login
    const { error } = await supabase.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    });

    if (error) {
      errorMessage.value = error.message;
    } else {
      router.push('/');
    }
  } else {
    //signup
    const { error } = await supabase.auth.signUp({
      email: email.value,
      password: password.value,
    });

    if (error) {
      errorMessage.value = error.message;
    } else {
      alert('Please check your email to verify your account.');
      //router.push('/login');
    }
  }
};
</script>