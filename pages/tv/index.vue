<!-- TV index -->

<template>
  <div>
    <h1>{{ $t("tv-welcome-back") }} Stepan!</h1>

    <h3>{{ $t("tv-enter-menu") }}</h3>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  title: "Kymu",
  layout: "television",
});

const localePath = useLocalePath();
const { remoteKey } = useRemoteControl();
const user = useSupabaseUser();
const userID = user.value?.id;

watch(
  () => remoteKey.value,
  (newKey) => {
    if (newKey === "ok") {
      navigateTo(localePath(`/tv/${userID}/menu`));
    }
  }
);
</script>

<style scoped>
h1,
h3 {
  text-align: center;
}
</style>
