<template>
    <div class="w-full">
        <WidgetsPatients />
    </div>
</template>
<script setup>
import jsonData from '../assets/data/data.json';
const patients = ref(jsonData.patients);
</script>
