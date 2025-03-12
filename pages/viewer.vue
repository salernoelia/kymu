<template>
  <div class="flex-col">
    <h1>
      {{ $t("vr-viewer") }}
    </h1>
    <h3>
      {{ $t("vr-viewer-description") }}
    </h3>
    <WidgetsPlayer id="player" />
  </div>
</template>

<script setup lang="ts">
const supabase = useSupabaseClient();

const profiles = ref([]);

onMounted(async () => {
  let { data, error } = await supabase.from("default_scenes").select("*");

  if (data) {
    profiles.value = data;
  }
});
</script>

<style scoped>
#player {
  display: flex;
  justify-content: center;
  align-items: center;
  max-width: 500px;
}
</style>
