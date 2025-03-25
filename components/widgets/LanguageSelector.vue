<template>
  <div class="relative inline-block">
    <select
      :value="$i18n.locale"
      @change="(e) => setLocale(e.target.value)"
      class="border m-0 rounded-lg px-4 py-2 min-w-[120px] text-sm font-medium focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 appearance-none pl-10"
    >
      <option value="de">DE</option>
      <option value="en">EN</option>
      <option value="fr">FR</option>
      <option value="it">IT</option>
    </select>
    <Icon
      name="material-symbols-light:keyboard-arrow-down-rounded"
      class="absolute right-2 top-1/2 transform -translate-y-1/2 pointer-events-none"
    />
    <Icon
      name="material-symbols-light:language"
      class="absolute left-3 top-1/2 transform -translate-y-1/2 pointer-events-none w-5 h-5"
    />
  </div>
</template>

<script setup>
const { setLocale } = useI18n();
</script>

<style scoped>
select {
  height: 38px;
}

select option {
  padding-left: 10px;
}
</style>
