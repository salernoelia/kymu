<template>
  <div>
    <div class="exercises flex flex-row">
      <TvExercises
        v-for="(exercise, index) in exercisesWithFocus"
        :key="index"
        :title="exercise.title"
        :description="exercise.description"
        :focus="exercise.focus"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  title: "Kymu",
  layout: "television",
});

const localePath = useLocalePath();
const { remoteKey } = useRemoteControl();
const selectedIndex = ref(0);
const route = useRoute();
const patientId = route?.params.patientid;

const unitId = route.params.unitid;
console.log("unitId", unitId);

const exercises = [
  {
    Id: "6b238ad8-7da1-43f9-990b-1e4dedb72a82",
    title: "exercise 1",
    description: "Description for exercise 1",
  },
  {
    Id: "8ec96432-1adf-499c-9680-3b3f702b8c57",
    title: "exercise 2",
    description: "Description for exercise 3",
  },
  {
    Id: "be19bcfe-7fd5-4384-8d45-628e11bf8a2d",
    title: "exercise 3",
    description: "Description for exercise 2",
  },
];

const exercisesWithFocus = computed(() => {
  return exercises.map((exercise, index) => ({
    ...exercise,
    focus: index === selectedIndex.value,
  }));
});

watch(
  () => remoteKey.value,
  (newKey) => {
    if (newKey === "right") {
      selectedIndex.value = (selectedIndex.value + 1) % exercises.length;
    } else if (newKey === "left") {
      selectedIndex.value =
        (selectedIndex.value - 1 + exercises.length) % exercises.length;
    } else if (newKey === "ok") {
      const selectedexercise = exercises[selectedIndex.value];
      if (selectedexercise && unitId) {
        navigateTo(
          localePath(`/tv/${patientId}/${unitId}/${selectedexercise.Id}`)
        );
      }
    }
  }
);
</script>

<style scoped></style>
