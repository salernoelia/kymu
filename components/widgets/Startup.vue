<template>
    <div id="startup" v-html="startupConfig"></div>
</template>

<script setup>
import { useStartupConfig } from "../../assets/js/main.js";

const { startupConfig } = useStartupConfig();
</script>