<template>
  <div>
    <h1>Family</h1>
    <button @click="getDeviceInfo">Get Device Info</button>
    <div v-if="deviceInfo">
      <h2>Device Information:</h2>
      <p>Name: {{ deviceInfo.name }}</p>
      <p>Model: {{ deviceInfo.model }}</p>
      <p>Platform: {{ deviceInfo.platform }}</p>
      <p>Operating System: {{ deviceInfo.operatingSystem }}</p>
      <p>OS Version: {{ deviceInfo.osVersion }}</p>
      <p>Web View Version: {{ deviceInfo.webViewVersion }}</p>
      <div>
        {{ deviceInfo }}
      </div>
    </div>
    <div v-else>no info</div>
  </div>
</template>

<script setup lang="ts">
import { Device } from "@capacitor/device";

definePageMeta({
  title: "Kymu",
  layout: "family",
});

const deviceInfo = ref<any>(null);

const getDeviceInfo = async () => {
  try {
    const info = await Device.getInfo();
    deviceInfo.value = info;
    console.log("Device info:", info);
  } catch (error) {
    console.error("Error getting device info:", error);
  }
};
</script>

<style scoped></style>
