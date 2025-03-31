<template>
  <div class="overlay-menu">
    <div class="menu-content flex flex-col gap-4">
      <h1>Settings</h1>
      <slot></slot>
    </div>
  </div>
</template>

<script setup lang="ts"></script>

<style scoped>
.overlay-menu {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 1000;
}

.menu-content {
  background-color: white;
  padding: 20px;
  border-radius: 4px;
  max-width: 80%;
  max-height: 80%;
  min-width: 400px;
  min-height: 300px;
  overflow-y: auto;
}
</style>
