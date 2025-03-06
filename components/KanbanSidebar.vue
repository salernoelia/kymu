<template>
    <div class="sidebar">
        <div class="sidebar-header">
            <h3>Templates</h3>
        </div>

        <div class="templates-list">
            <div v-for="template in templates" :key="template.id" class="template-item"
                @click="$emit('use-template', template)">
                <div class="template-name">{{ template.name }}</div>
                <div class="template-preview">
                    <div v-for="(column, index) in template.columns" :key="index" class="template-column-preview">
                        {{ column }}
                    </div>
                </div>
            </div>
        </div>

        <div class="new-template">
            <button v-if="!isAddingTemplate" @click="startAddingTemplate">
                + Create Template
            </button>

            <div v-else class="add-template-form">
                <input v-model="newTemplateName" type="text" placeholder="Template Name">

                <div class="template-columns">
                    <div v-for="(column, index) in newTemplateColumns" :key="index" class="column-input">
                        <input v-model="newTemplateColumns[index]" type="text" :placeholder="`Column ${index + 1}`">
                        <button @click="removeColumn(index)" class="remove-btn">×</button>
                    </div>

                    <button @click="addColumn" class="add-column">
                        + Add Column
                    </button>
                </div>

                <div class="form-actions">
                    <button @click="saveTemplate">Save Template</button>
                    <button @click="cancelAddTemplate">Cancel</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, defineProps, defineEmits } from 'vue';

const props = defineProps({
    templates: {
        type: Array,
        default: () => []
    }
});

const emit = defineEmits(['add-template', 'use-template']);

const isAddingTemplate = ref(false);
const newTemplateName = ref('');
const newTemplateColumns = ref(['To Do', 'In Progress', 'Done']);

const startAddingTemplate = () => {
    isAddingTemplate.value = true;
};

const addColumn = () => {
    newTemplateColumns.value.push(`Column ${newTemplateColumns.value.length + 1}`);
};

const removeColumn = (index: number) => {
    newTemplateColumns.value.splice(index, 1);
};

const saveTemplate = () => {
    if (newTemplateName.value.trim() && newTemplateColumns.value.length > 0) {
        emit('add-template', {
            name: newTemplateName.value.trim(),
            columns: [...newTemplateColumns.value]
        });
        resetForm();
    }
};

const cancelAddTemplate = () => {
    resetForm();
};

const resetForm = () => {
    newTemplateName.value = '';
    newTemplateColumns.value = ['To Do', 'In Progress', 'Done'];
    isAddingTemplate.value = false;
};
</script>

<style scoped>
.sidebar {
    width: 250px;
    background-color: #f5f5f5;
    border-right: 1px solid #ddd;
    padding: 15px;
    overflow-y: auto;
    height: 100%;
}

.sidebar-header {
    margin-bottom: 15px;
    padding-bottom: 10px;
    border-bottom: 1px solid #ddd;
}

.templates-list {
    margin-bottom: 20px;
}

.template-item {
    background-color: white;
    border-radius: 4px;
    padding: 10px;
    margin-bottom: 10px;
    cursor: pointer;
    border: 1px solid #ddd;
}

.template-name {
    font-weight: bold;
    margin-bottom: 5px;
}

.template-preview {
    display: flex;
    gap: 5px;
    font-size: 0.8rem;
}

.template-column-preview {
    background-color: #eee;
    padding: 2px 5px;
    border-radius: 3px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 80px;
}

.new-template button {
    width: 100%;
    padding: 8px;
    background-color: #e7e7e7;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.add-template-form {
    margin-top: 10px;
}

.add-template-form input {
    width: 100%;
    padding: 5px;
    margin-bottom: 10px;
    border: 1px solid #ddd;
    border-radius: 3px;
}

.column-input {
    display: flex;
    margin-bottom: 5px;
    align-items: center;
}

.column-input input {
    flex-grow: 1;
    margin-bottom: 0;
}

.remove-btn {
    background: none;
    border: none;
    cursor: pointer;
    font-size: 1.2rem;
    color: #999;
}

.add-column {
    background: none;
    border: 1px dashed #ccc;
    padding: 5px;
    width: 100%;
    margin-top: 5px;
    cursor: pointer;
}

.form-actions {
    display: flex;
    justify-content: space-between;
    margin-top: 10px;
}
</style>
