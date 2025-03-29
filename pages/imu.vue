<template>
  <h1>Key moves</h1>

  <note class="mb-2"> Device Motion: </note>
  <div v-if="!isSupported">Not supported by your current browser.</div>
  <template v-else>
    <pre
      v-if="!permissionGranted"
      lang="json"
      >{{
        { acceleration, accelerationIncludingGravity, rotationRate, interval }
      }}</pre
    >
    <div v-else>Permission is required</div>
    <button
      v-if="!permissionGranted"
      @click="ensurePermissions"
    >
      Request Permission
    </button>
  </template>
</template>

<script setup lang="ts">
definePageMeta({
  title: "Kymu",
});

import { useDeviceMotion } from "@vueuse/core";

const {
  acceleration,
  accelerationIncludingGravity,
  rotationRate,
  interval,
  isSupported,
  ensurePermissions,
  permissionGranted,
} = useDeviceMotion();
</script>

<style scoped>
@import url("https://use.typekit.net/vov2bbh.css");

h1 {
  font-family: "ivypresto-display", serif;
  font-weight: 400;
  font-style: normal;
}
</style>
