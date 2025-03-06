<template>
    <div class="kanban-column" @dragover.prevent @drop="onDrop">
        <div class="column-header">
            <h3>{{ column.title }}</h3>
            <div class="column-actions">
                <button @click="isEditing = true" v-if="!isEditing">Edit</button>
                <button @click="$emit('delete-column', column.id)" v-if="!isEditing">Delete</button>
            </div>
        </div>

        <div v-if="isEditing" class="edit-column">
            <input v-model="editTitle" type="text" placeholder="Column Title">
            <div class="edit-actions">
                <button @click="saveColumnEdit">Save</button>
                <button @click="cancelColumnEdit">Cancel</button>
            </div>
        </div>

        <div class="cards-container">
            <KanbanCard v-for="card in cards" :key="card.id" :card="card"
                @update-card="$emit('update-card', card.id, $event)" @delete-card="$emit('delete-card', card.id)"
                @dragstart="onDragStart" />
        </div>

        <div class="add-card">
            <div v-if="!isAddingCard" class="add-card-button" @click="isAddingCard = true">
                + Add Card
            </div>
            <div v-else class="add-card-form">
                <input v-model="newCardTitle" type="text" placeholder="Enter card title" @keyup.enter="addCard">
                <div class="add-card-actions">
                    <button @click="addCard">Add</button>
                    <button @click="isAddingCard = false">Cancel</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, defineProps, defineEmits } from 'vue';

const props = defineProps({
    column: {
        type: Object,
        required: true
    },
    cards: {
        type: Array,
        default: () => []
    }
});

const emit = defineEmits(['add-card', 'delete-card', 'update-card', 'delete-column', 'update-column', 'card-moved']);

const isAddingCard = ref(false);
const newCardTitle = ref('');
const isEditing = ref(false);
const editTitle = ref(props.column.title);

const addCard = () => {
    if (newCardTitle.value.trim()) {
        emit('add-card', props.column.id, newCardTitle.value.trim());
        newCardTitle.value = '';
        isAddingCard.value = false;
    }
};

const saveColumnEdit = () => {
    if (editTitle.value.trim()) {
        emit('update-column', props.column.id, { title: editTitle.value.trim() });
        isEditing.value = false;
    }
};

const cancelColumnEdit = () => {
    editTitle.value = props.column.title;
    isEditing.value = false;
};

const onDragStart = (event: DragEvent, card: any) => {
    if (event.dataTransfer) {
        event.dataTransfer.effectAllowed = 'move';
        event.dataTransfer.setData('cardId', card.id);
    }
};

const onDrop = (event: DragEvent) => {
    if (event.dataTransfer) {
        const cardId = event.dataTransfer.getData('cardId');
        const cardElements = document.querySelectorAll('.kanban-card');
        const targetColumn = props.column.id;

        // Calculate the index for the dropped card
        let index = 0;
        const mouseY = event.clientY;

        // Find the insertion point based on mouse Y position
        for (const cardEl of cardElements) {
            if (cardEl.parentElement?.parentElement?.dataset.columnId !== targetColumn) continue;

            const rect = cardEl.getBoundingClientRect();
            const cardMiddle = rect.top + rect.height / 2;

            if (mouseY < cardMiddle) break;
            index++;
        }

        emit('card-moved', {
            cardId,
            toColumnId: targetColumn,
            newIndex: index
        });
    }
};
</script>

<style scoped>
.kanban-column {
    min-width: 250px;
    width: 250px;
    background-color: #f1f1f1;
    border-radius: 4px;
    padding: 8px;
    display: flex;
    flex-direction: column;
    max-height: calc(100vh - 120px);
}

.column-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
    padding-bottom: 8px;
    border-bottom: 1px solid #ddd;
}

.column-header h3 {
    margin: 0;
}

.column-actions button {
    margin-left: 5px;
    background: none;
    border: none;
    cursor: pointer;
    color: #666;
    font-size: 0.8rem;
}

.edit-column {
    margin-bottom: 10px;
}

.edit-column input {
    width: 100%;
    padding: 5px;
    margin-bottom: 5px;
}

.edit-actions {
    display: flex;
    justify-content: flex-end;
    gap: 5px;
}

.cards-container {
    flex: 1;
    overflow-y: auto;
    margin-bottom: 10px;
    min-height: 100px;
}

.add-card-button {
    padding: 8px;
    text-align: center;
    background-color: rgba(0, 0, 0, 0.05);
    border-radius: 4px;
    cursor: pointer;
}

.add-card-form input {
    width: 100%;
    padding: 5px;
    margin-bottom: 5px;
}

.add-card-actions {
    display: flex;
    justify-content: flex-end;
    gap: 5px;
}
</style>
