<template>
  <div class="flex flex-col justify-center items-center gap-4">
    <h1>Video that instructs the exercise</h1>
    <iframe
      width="1000"
      height="562"
      src="https://www.youtube.com/embed/Czx6LUnG1cs?si=E5DV8p275fSKP6Mt&amp;controls=0&amp;start=389"
      title="YouTube video player"
      frameborder="0"
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
      referrerpolicy="strict-origin-when-cross-origin"
      allowfullscreen
    ></iframe>

    <TvProgress
      :current="exerciseProgress.current - 1"
      :total="exerciseProgress.total"
    />
    <h1>Drücke nach rechts um weiterzumachen!</h1>
  </div>
</template>

<script setup lang="ts">
const localePath = useLocalePath();
const tvStore = useTVStore();
const route = useRoute();

const exerciseProgress = computed(() => tvStore.exerciseProgress);

// Route params
const unitId = computed(() => route.params.unitid as string);
const patientId = route.params.patientid as string;

// Access the reactive state from the store
const {
  currentUnit,
  isLoading: storeLoading,
  error: storeError,
} = storeToRefs(tvStore);

const { remoteKey } = useRemoteControl();

watch(
  () => remoteKey.value,
  (newKey) => {
    if (newKey === "right") {
      navigateTo(
        localePath(
          `/tv/${patientId}/${unitId.value}/${
            currentUnit.value?.exercises[exerciseProgress.value.current - 1]?.id
          }/rom`
        )
      );
    }
  }
);

definePageMeta({
  title: "Kymu",
  layout: "television",
});
</script>

<style scoped></style>
