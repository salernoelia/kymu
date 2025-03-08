<template>
    <div class="kanban-column" @dragover.prevent @drop="onDrop" :data-column-id="column.id">
        <div class="column-header">
            <div v-if="isEditing" class="edit-column">
                <input v-model="editTitle" type="text" placeholder="Column Title" @keyup.enter="saveColumnEdit"
                    ref="titleInput">
                <button @click="saveColumnEdit">Save</button>
                <button @click="cancelColumnEdit">Cancel</button>
            </div>
            <div v-else class="column-title-display">
                <div class="column-title">

                    <h3>{{ column.title }}</h3>
                </div>
                <div class="column-actions">
                    <button @click="startEditing">Edit</button>
                    <button @click="$emit('delete-column', column.id)">Delete</button>
                </div>
            </div>
        </div>

        <div class="cards-container">
            <KanbanCard v-for="card in sortedCards" :key="card.id" :card="card"
                @update-card="$emit('update-card', card.id, $event)" @delete-card="$emit('delete-card', card.id)"
                @dragstart="onDragStart" />
        </div>

        <div class="add-card">
            <div v-if="isAddingCard" class="add-card-form">
                <input v-model="newCardTitle" type="text" placeholder="Card title" @keyup.enter="addCard"
                    ref="cardInput">
                <button @click="addCard">Add</button>
                <button @click="cancelAddCard">Cancel</button>
            </div>
            <button v-else @click="startAddingCard" class="add-card-button">
                + Add Card
            </button>
        </div>
    </div>
</template>

<script setup lang="ts">

const props = defineProps<{
    column: KanbanColumn;
    cards: KanbanCard[];
}>();

const emit = defineEmits<{
    'add-card': [columnId: string, title: string];
    'delete-card': [cardId: string];
    'update-card': [cardId: string, updatedCard: { title: string, description: string }];
    'delete-column': [columnId: string];
    'update-column': [columnId: string, updatedColumn: { title: string }];
    'card-moved': [payload: { cardId: string, toColumnId: string, newIndex: number }];
}>();

const isAddingCard = ref(false);
const newCardTitle = ref('');
const isEditing = ref(false);
const editTitle = ref(props.column.title);
const titleInput = ref<HTMLInputElement | null>(null);
const cardInput = ref<HTMLInputElement | null>(null);

const sortedCards = computed(() => {
    return [...props.cards].sort((a, b) => a.order - b.order);
});

const startAddingCard = () => {
    isAddingCard.value = true;
    nextTick(() => {
        cardInput.value?.focus();
    });
};

const addCard = () => {
    if (newCardTitle.value.trim()) {
        emit('add-card', props.column.id, newCardTitle.value.trim());
        newCardTitle.value = '';
        isAddingCard.value = false;
    }
};

const cancelAddCard = () => {
    newCardTitle.value = '';
    isAddingCard.value = false;
};

const startEditing = () => {
    isEditing.value = true;
    nextTick(() => {
        titleInput.value?.focus();
    });
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

const onDragStart = (event: DragEvent, card: KanbanCard) => {
    if (event.dataTransfer) {
        event.dataTransfer.effectAllowed = 'move';
        event.dataTransfer.setData('cardId', card.id);
        event.dataTransfer.setData('sourceColumnId', card.columnId);
    }
};

const onDrop = (event: DragEvent) => {
    if (!event.dataTransfer) return;

    const cardId = event.dataTransfer.getData('cardId');
    const targetColumnId = props.column.id;

    const cardElements = document.querySelectorAll(`[data-column-id="${targetColumnId}"] .kanban-card`);
    let insertIndex = cardElements.length;

    const mouseY = event.clientY;

    for (let i = 0; i < cardElements.length; i++) {
        const rect = (cardElements[i] as HTMLElement).getBoundingClientRect();
        const cardMiddle = rect.top + rect.height / 2;

        if (mouseY < cardMiddle) {
            insertIndex = i;
            break;
        }
    }

    emit('card-moved', {
        cardId,
        toColumnId: targetColumnId,
        newIndex: insertIndex
    });
};
</script>

<style scoped lang="scss">
.kanban-column {
    min-width: 250px;
    width: 300px;
    background-color: #f5f5f5;
    border-radius: 3px;
    padding: 8px;
    display: flex;
    flex-direction: column;
    height: fit-content;
}

.column-header {
    padding-bottom: 8px;
    border-bottom: 1px solid #ddd;
    margin-bottom: 8px;
}

.column-title-display {
    display: flex;
    justify-content: space-between;
    align-items: center;

    .column-title {
        display: flex;
        flex-grow: 1;
        width: 50%;
        justify-content: left;
        align-items: center;
    }

    .column-actions {
        display: flex;
        gap: 4px;
        width: 50%;
        justify-content: flex-end;
        align-items: center;
    }
}

.column-title-display h3 {
    margin: 0;
}

.cards-container {
    min-height: 10px;
    flex-grow: 1;
}

.add-card-button {
    width: 100%;
    text-align: left;
    background: none;
    border: none;
    cursor: pointer;
    padding: 8px 0;
}

input {
    padding: 4px;
    border: 1px solid #ddd;
    border-radius: 3px;
    margin-bottom: 4px;
    width: 100%;
}

button {
    cursor: pointer;
    margin-right: 4px;
}
</style>