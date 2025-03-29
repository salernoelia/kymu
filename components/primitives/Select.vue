<template>
  <div class="relative inline-block">
    <select
      :value="modelValue"
      @change="(e) => $emit('update:modelValue', e.target.value)"
      class="border m-0 rounded-lg px-4 py-2 min-w-[120px] text-sm font-medium focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 appearance-none pl-10 bg-white text-gray-900 border-gray-300 focus:border-gray-500 focus:ring-gray-500"
    >
      <option
        v-for="option in options"
        :key="option.value"
        :value="option.value"
      >
        {{ option.label }}
      </option>
    </select>
    <Icon
      :name="rightIcon"
      class="absolute right-2 top-1/2 transform -translate-y-1/2 pointer-events-none"
    />
    <Icon
      v-if="leftIcon"
      :name="leftIcon"
      class="absolute left-3 top-1/2 transform -translate-y-1/2 pointer-events-none w-5 h-5"
    />
  </div>
</template>

<script setup>
defineProps({
  modelValue: {
    type: [String, Number],
    required: true,
  },
  options: {
    type: Array,
    required: true,
  },
  leftIcon: {
    type: String,
    default: "",
  },
  rightIcon: {
    type: String,
    default: "material-symbols-light:keyboard-arrow-down-rounded",
  },
});

defineEmits(["update:modelValue"]);
</script>

<style scoped>
select {
  height: 38px;
}

select option {
  padding-left: 10px;
}
</style>
