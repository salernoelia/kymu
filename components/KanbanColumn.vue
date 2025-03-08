<template>
    <div class="kanban-column" @dragover.prevent="onDragOver" @dragenter.prevent="onDragEnter" @dragleave="onDragLeave"
        @drop="onDrop" :data-column-id="column.id" :class="{ 'drop-active': isDropTarget }">
        <div class="column-header">
            <div class="column-title-display">
                <div class="column-title">
                    <h3>{{ column.title }}</h3>
                </div>
                <div class="column-actions">
                    <button @click="editColumn">Edit</button>
                    <button @click="handleColumnDelete('dialog')">Delete</button>

                    <dialog ref="dialog">
                        <p>Are you sure you want to delete this column?</p>
                        <button @click="handleColumnDelete('yes')">Yes</button>
                        <button @click="handleColumnDelete('no')">No</button>
                    </dialog>
                </div>
            </div>
        </div>

        <div class="cards-container">
            <template v-for="(card, index) in sortedCards" :key="card.id">
                <div v-if="draggedOverIndex === index" class="drop-indicator"></div>

                <KanbanCard :card="card" @delete-card="$emit('delete-card', $event)" @dragstart="onDragStart"
                    @dragover="onCardDragOver(index, $event)" />
            </template>

            <div v-if="draggedOverIndex === sortedCards.length || (isDropTarget && !sortedCards.length)"
                class="drop-indicator">
            </div>
        </div>

        <div class="add-card">
            <button @click="addCard" class="add-card-button">
                + Add Card
            </button>
        </div>
    </div>
</template>

<script setup lang="ts">
const deleteColumnDialog = templateRef('dialog');

const props = defineProps<{
    column: KanbanColumn;
    cards: KanbanCard[];
}>();

const emit = defineEmits<{
    'delete-card': [cardId: string];
    'delete-column': [columnId: string];
    'card-moved': [payload: { cardId: string, toColumnId: string, newIndex: number }];
}>();

const kanbanActions = inject('kanbanActions') as {
    openEditColumnSidebar: (columnId: string) => void;
    openAddCardSidebar: (columnId: string) => void;
    openEditCardSidebar: (cardId: string) => void;
};

const sortedCards = computed(() => {
    return [...props.cards].sort((a, b) => a.order - b.order);
});

const addCard = () => {
    kanbanActions.openAddCardSidebar(props.column.id);
};

const editColumn = () => {
    kanbanActions.openEditColumnSidebar(props.column.id);
};

interface ColumnDeleteOptions {
    dialog: string;
    yes: string;
    no: string;
}

const handleColumnDelete = (option: keyof ColumnDeleteOptions) => {

    if (option === 'dialog') {
        deleteColumnDialog.value.showModal();
    } else if (option === 'yes') {
        emit('delete-column', props.column.id);
    } else if (option === 'no') {
        deleteColumnDialog.value.close();
    } else {
        console.error('Invalid option');
    }
};

const isDropTarget = ref(false);
const dragCounter = ref(0);
const draggedOverIndex = ref(-1);

const onDragStart = (event: DragEvent, card: KanbanCard) => {
    if (event.dataTransfer) {
        event.dataTransfer.effectAllowed = 'move';
        event.dataTransfer.setData('cardId', card.id);
        event.dataTransfer.setData('sourceColumnId', card.columnId);
    }
};

const onDragEnter = (event: DragEvent) => {
    dragCounter.value++;
    isDropTarget.value = true;
};

const onDragLeave = (event: DragEvent) => {
    dragCounter.value--;

    // Only remove highlight when completely left the container
    if (dragCounter.value === 0) {
        isDropTarget.value = false;
        draggedOverIndex.value = -1;
    }
};

const onDragOver = (event: DragEvent) => {
    if (event.dataTransfer) {
        event.dataTransfer.dropEffect = 'move';

        // If dragging directly over the column and not over a card
        if ((event.target as HTMLElement).classList.contains('cards-container') ||
            (event.target as HTMLElement).classList.contains('kanban-column')) {
            const cardElements = document.querySelectorAll(`[data-column-id="${props.column.id}"] .kanban-card`);

            if (cardElements.length === 0) {
                draggedOverIndex.value = 0;
                return;
            }

            // Calculate insert position based on mouse position
            const mouseY = event.clientY;
            let newIndex = cardElements.length;  // Default to end

            for (let i = 0; i < cardElements.length; i++) {
                const rect = (cardElements[i] as HTMLElement).getBoundingClientRect();
                const cardMiddle = rect.top + rect.height / 2;

                if (mouseY < cardMiddle) {
                    newIndex = i;
                    break;
                }
            }

            draggedOverIndex.value = newIndex;
        }
    }
};

const onCardDragOver = (index: number, event: DragEvent) => {
    event.stopPropagation();
    const rect = (event.currentTarget as HTMLElement).getBoundingClientRect();
    const mouseY = event.clientY;

    // Determine if we're in the top or bottom half of the card
    if (mouseY < rect.top + rect.height / 2) {
        // Top half - place before this card
        draggedOverIndex.value = index;
    } else {
        // Bottom half - place after this card
        draggedOverIndex.value = index + 1;
    }
};

const onDrop = (event: DragEvent) => {
    isDropTarget.value = false;
    dragCounter.value = 0;

    if (!event.dataTransfer) return;

    const cardId = event.dataTransfer.getData('cardId');
    const targetColumnId = props.column.id;

    // Use the tracked index if available, otherwise calculate it
    let insertIndex = draggedOverIndex.value >= 0 ? draggedOverIndex.value : sortedCards.value.length;

    emit('card-moved', {
        cardId,
        toColumnId: targetColumnId,
        newIndex: insertIndex
    });

    // Reset the drag state
    draggedOverIndex.value = -1;
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
    padding-top: 4px;
    padding-bottom: 4px;
    display: flex;
    flex-direction: column;
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

.drop-active {
    background-color: #ffffff;

}

.drop-placeholder {
    height: 80px;
    background-color: rgba(0, 120, 215, 0.1);
    border: 2px dashed #0078d7;
    border-radius: 3px;
    margin-bottom: 8px;
}

.drop-indicator {
    height: 80px;
    background-color: rgba(0, 120, 215, 0.1);
    border: 2px dashed #99d1ff;
    border-radius: 3px;
    margin: 4px 0;
    transition: all 0.2s ease;
}
</style>