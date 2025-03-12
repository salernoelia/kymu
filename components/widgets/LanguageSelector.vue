<template>
  <select
    :value="$i18n.locale"
    @change="(e) => setLocale(e.target.value)"
    class="border m-0 rounded px-4 py-2 min-w-[120px] h-[42px] focus:outline-none focus:ring-2 focus:ring-blue-500 appearance-none"
  >
    <option value="de">DE</option>
    <option value="en">EN</option>
    <option value="fr">FR</option>
    <option value="it">IT</option>
  </select>
</template>

<script setup>
const { setLocale } = useI18n();
</script>

<style scoped></style>
