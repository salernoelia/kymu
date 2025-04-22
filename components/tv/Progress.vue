<template>
  <div class="flex flex-row gap-4 items-center">
    <div
      v-for="n in total"
      :key="n"
      class="flex flex-row items-center gap-4"
    >
      <div
        :class="[
          'dot flex justify-center items-center',
          {
            completed: n <= current,
            ongoing: n === current + 1,
            upcoming: n > current + 1,
          },
        ]"
      >
        <Icon
          v-if="n <= current"
          name="material-symbols-light:check-rounded"
          class="text-white h-8 w-8"
        />
      </div>
      <div
        v-if="n !== total"
        class="line"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps({
  current: {
    type: Number,
    default: 0,
    required: true,
  },
  total: {
    type: Number,
    default: 5,
  },
});
</script>

<style scoped lang="scss">
.dot {
  width: 50px;
  height: 50px;
  border-radius: 50%;

  &.completed {
    background-color: var(--color-Primary);
  }

  &.ongoing {
    background-color: var(--color-Primary);
    opacity: 1;
  }

  &.upcoming {
    background-color: transparent;
    border: 2px solid var(--color-Primary);
  }
}

.line {
  width: 50px;
  height: 2px;
  background-color: var(--color-Primary);
}
</style>
