<template>
    <select :value="$i18n.locale" @change="e => setLocale(e.target.value)"
        class="border m-0 rounded px-4 py-2 min-w-[120px] h-[42px] focus:outline-none focus:ring-2 focus:ring-blue-500 appearance-none">
        <option value="de">Deutsch</option>
        <option value="en">English</option>
        <option value="fr">Français</option>
        <option value="it">Italiano</option>
    </select>
</template>

<script setup>
const { setLocale } = useI18n();

</script>

<style scoped></style>