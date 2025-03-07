<template>
  <div class="flex flex-row">
    <WidgetsVerticalCarousell
      @current-slide="(i) => console.log('clicke', i)"
      :initialSlide="0"
      :slides="[
        { title: 'Slide 1', content: 'Content 1' },
        { title: 'Slide 2', content: 'Content 2' },
        { title: 'Slide 3', content: 'Content 3' },
        { title: 'Slide 4', content: 'Content 4' },
        { title: 'Slide 5', content: 'Content 5' },
      ]"
    />
    <WidgetsThreeModelViewer />
  </div>
</template>

<script setup lang="ts"></script>

<style scoped></style>
