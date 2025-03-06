<template>
    <div class="kanban-card" draggable="true" @dragstart="(e) => $emit('dragstart', e, card)"
        @click="toggleCardDetails">
        <div class="card-content">
            <div class="card-title">{{ card.title }}</div>
            <div class="card-indicators">
                <span v-if="card.description" class="indicator">📝</span>
            </div>
        </div>

        <div v-if="showCardDetails" class="card-details">
            <div v-if="isEditing">
                <input v-model="editTitle" type="text" placeholder="Card Title">
                <textarea v-model="editDescription" placeholder="Card Description"></textarea>
                <div class="card-edit-actions">
                    <button @click="saveCardEdit">Save</button>
                    <button @click="cancelCardEdit">Cancel</button>
                </div>
            </div>
            <div v-else>
                <h4>{{ card.title }}</h4>
                <p class="description">{{ card.description || 'No description' }}</p>
                <div class="card-actions">
                    <button @click="startEditing">Edit</button>
                    <button @click="$emit('delete-card', card.id)">Delete</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, defineProps, defineEmits } from 'vue';

const props = defineProps({
    card: {
        type: Object,
        required: true
    }
});

const emit = defineEmits(['update-card', 'delete-card', 'dragstart']);

const showCardDetails = ref(false);
const isEditing = ref(false);
const editTitle = ref(props.card.title);
const editDescription = ref(props.card.description);

const toggleCardDetails = (event: MouseEvent) => {
    // Prevent propagation for internal card elements
    if ((event.target as HTMLElement).closest('.card-actions')) {
        return;
    }
    showCardDetails.value = !showCardDetails.value;
};

const startEditing = () => {
    isEditing.value = true;
};

const saveCardEdit = () => {
    if (editTitle.value.trim()) {
        emit('update-card', {
            title: editTitle.value.trim(),
            description: editDescription.value.trim()
        });
        isEditing.value = false;
    }
};

const cancelCardEdit = () => {
    editTitle.value = props.card.title;
    editDescription.value = props.card.description;
    isEditing.value = false;
};
</script>

<style scoped>
.kanban-card {
    background-color: white;
    border-radius: 3px;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
    margin-bottom: 8px;
    padding: 8px;
    cursor: grab;
}

.card-content {
    display: flex;
    justify-content: space-between;
}

.card-title {
    font-weight: 500;
}

.card-indicators {
    display: flex;
    gap: 3px;
    color: #666;
}

.card-details {
    margin-top: 8px;
    padding-top: 8px;
    border-top: 1px solid #eee;
}

.card-details input,
.card-details textarea {
    width: 100%;
    padding: 5px;
    margin-bottom: 5px;
    border: 1px solid #ddd;
    border-radius: 3px;
}

.card-details textarea {
    min-height: 60px;
    resize: vertical;
}

.description {
    color: #666;
    font-size: 0.9rem;
    white-space: pre-wrap;
    margin: 8px 0;
}

.card-actions,
.card-edit-actions {
    display: flex;
    justify-content: flex-end;
    gap: 5px;
}

.card-actions button,
.card-edit-actions button {
    background: none;
    border: none;
    cursor: pointer;
    color: #666;
    font-size: 0.8rem;
}
</style>
