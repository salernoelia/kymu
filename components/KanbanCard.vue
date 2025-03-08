<template>
    <div class="kanban-card" draggable="true" @dragstart="onDragStart" @dragend="onDragEnd"
        @dragover.prevent="onDragOver" @click="toggleCardDetails" :class="{ 'dragging': isDragging }">
        <div class="card-title">{{ card.title }}</div>

        <div v-if="showCardDetails" class="card-details">
            <div v-if="isEditing" class="card-edit">
                <input v-model="editTitle" type="text" placeholder="Title" ref="titleInput">
                <textarea v-model="editDescription" placeholder="Description"></textarea>
                <div>
                    <button @click="saveCardEdit">Save</button>
                    <button @click="cancelCardEdit">Cancel</button>
                </div>
            </div>
            <div v-else class="card-view">
                <p v-if="card.description">{{ card.description }}</p>
                <div class="card-actions">
                    <button @click="startEditing">Edit</button>
                    <button @click="$emit('delete-card', card.id)">Delete</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">

const props = defineProps<{
    card: KanbanCard
}>();

const emit = defineEmits<{
    'update-card': [{ title: string, description: string }];
    'delete-card': [cardId: string];
    'dragstart': [event: DragEvent, card: KanbanCard];
    'dragover': [event: DragEvent];
}>();

const showCardDetails = ref(false);
const isEditing = ref(false);
const editTitle = ref(props.card.title);
const editDescription = ref(props.card.description);
const titleInput = ref<HTMLInputElement | null>(null);

const isDragging = ref(false);

const toggleCardDetails = (event: MouseEvent) => {
    // Don't toggle if clicking on action buttons
    if ((event.target as HTMLElement).closest('.card-actions, .card-edit')) {
        return;
    }
    showCardDetails.value = !showCardDetails.value;
};

const startEditing = () => {
    isEditing.value = true;
    nextTick(() => {
        titleInput.value?.focus();
    });
};

const saveCardEdit = () => {
    if (editTitle.value.trim()) {
        emit('update-card', {
            title: editTitle.value.trim(),
            description: editDescription.value
        });
        isEditing.value = false;
    }
};

const cancelCardEdit = () => {
    editTitle.value = props.card.title;
    editDescription.value = props.card.description;
    isEditing.value = false;
};

const onDragStart = (event: DragEvent) => {
    isDragging.value = true;

    if (event.dataTransfer) {
        event.dataTransfer.effectAllowed = 'move';
        event.dataTransfer.setData('cardId', props.card.id);
        event.dataTransfer.setData('sourceColumnId', props.card.columnId);
    }

    emit('dragstart', event, props.card);

    // Add a small delay to make dragging feel more natural
    setTimeout(() => {
        isDragging.value = true;
    }, 0);
};

const onDragEnd = () => {
    isDragging.value = false;
};

const onDragOver = (event: DragEvent) => {
    if (event.dataTransfer) {
        event.dataTransfer.dropEffect = 'move';
        emit('dragover', event);
    }
};
</script>

<style scoped>
.kanban-card {
    background: white;
    border-radius: 3px;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    padding: 8px;
    margin-bottom: 8px;
    cursor: grab;
    transition: transform 0.15s ease, opacity 0.15s ease;
}

.card-title {
    font-weight: 500;
}

.card-details {
    margin-top: 8px;
    border-top: 1px solid #eee;
    padding-top: 8px;
}

input,
textarea {
    width: 100%;
    padding: 4px;
    border: 1px solid #ddd;
    border-radius: 3px;
    margin-bottom: 4px;
}

textarea {
    min-height: 60px;
    resize: vertical;
}

button {
    cursor: pointer;
    margin-right: 4px;
}

.dragging {
    opacity: 0.5;
    transform: scale(0.98);
}
</style>