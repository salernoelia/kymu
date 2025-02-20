<template>
    <div class="flex justify-center items-center h-screen">
      <LoginForm />
    </div>
  </template>
  
  <script setup>
  definePageMeta({
    layout: 'empty',
    middleware: ['auth'],
  });


  </script>