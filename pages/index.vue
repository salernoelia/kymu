<template>
  <div class="flex-col">
    <h1>
      {{ $t("hello") }}
    </h1>
    <WidgetsPlayer id="player" />
    <h1>Hello {{ profiles }}!</h1>
  </div>
</template>

<script setup lang="ts">
const supabase = useSupabaseClient();

const profiles = ref([]);

onMounted(async () => {
  let { data, error } = await supabase.from("default_scenes").select("*");

  console.log(data, error);

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
