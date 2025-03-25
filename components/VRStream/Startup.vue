<template>
    <div id="startup" v-html="startupConfig"></div>
</template>

<script setup lang="ts">
import { useStartupConfig } from "~/assets/js/main.js";

const { startupConfig } = useStartupConfig();
</script>