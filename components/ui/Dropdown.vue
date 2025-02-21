<template>
    <div>
        <select :name="type" id="dropdown" :value="modelValue" :required="required"
            @input="$emit('update:modelValue', ($event.target as HTMLSelectElement).value)">
            <option value="" disabled>{{ placeholder }}</option>
            <option v-for="option in options" :value="option.value" :key="option.value">
                {{ option.label }}
            </option>
        </select>
    </div>
</template>

<script setup lang="ts">
interface DropdownOption {
    value: string
    label: string
}

defineProps({
    modelValue: String,
    type: String,
    required: Boolean,
    placeholder: {
        type: String,
        default: 'Select an option',
    },
    options: {
        type: Array as PropType<DropdownOption[]>,
        default: () => [],
    },
})

defineEmits(['update:modelValue'])
</script>

<style scoped>
#dropdown {
    width: 100%;
    padding: 10px;
    margin: 10px 0;
    border: 1px solid #ccc;
    border-radius: 4px;
}
</style>