<template>
    <div class="kanban-container">
        <button @click="openSidebar">Open Sidebar</button>

        <div class="kanban-board">
            <h1>Unit Editor</h1>
            <div class="board-container">
                <KanbanColumn v-for="column in kanbanState.columns" :key="column.id" :column="column"
                    :cards="getCardsForColumn(column.id)" @add-card="addCard" @delete-card="deleteCard"
                    @update-card="updateCard" @card-moved="handleCardMoved" @delete-column="deleteColumn"
                    @update-column="updateColumn" />
                <button class="add-column-btn" @click="addColumn">+ Add Column</button>
            </div>

            <KanbanUnitSidebar v-model="sidebarOpen" title="Patient Details" width="50%"
                @closed="handleSidebarClosed" />
        </div>
    </div>
</template>

<script setup lang="ts">
const kanbanStore = useKanbanStore();
const kanbanState = computed(() => kanbanStore);

const sidebarOpen = ref(false);

const openSidebar = () => {
    sidebarOpen.value = true;
};

const handleSidebarClosed = () => {
    console.log('Sidebar was closed');
};

const getCardsForColumn = (columnId: string) => {
    return kanbanState.value.cards.filter(card => card.columnId === columnId);
};

const addColumn = () => {
    kanbanStore.addColumn(`Column ${kanbanState.value.columns.length + 1}`);
};

const deleteColumn = (columnId: string) => {
    kanbanStore.deleteColumn(columnId);
};

const updateColumn = (columnId: string, updatedColumn: { title: string }) => {
    kanbanStore.updateColumn(columnId, updatedColumn);
};

const addCard = (columnId: string, cardTitle: string) => {
    kanbanStore.addCard({
        id: `card-${Date.now()}`,
        columnId,
        title: cardTitle,
        description: '',
        order: getCardsForColumn(columnId).length
    });
};

const deleteCard = (cardId: string) => {
    kanbanStore.deleteCard(cardId);
};

const updateCard = (cardId: string, updatedCard: { title: string, description: string }) => {
    kanbanStore.updateCard(cardId, updatedCard);
};

const handleCardMoved = (payload: { cardId: string, toColumnId: string, newIndex: number }) => {
    kanbanStore.moveCard(payload.cardId, payload.toColumnId, payload.newIndex);
};
</script>

<style scoped>
.kanban-container {
    height: 100vh;
    overflow: hidden;
}

.kanban-board {
    padding: 10px;
    height: 100%;
}

.board-container {
    display: flex;
    gap: 10px;
    overflow-x: auto;
    height: calc(100% - 60px);
}

.add-column-btn {
    min-width: 200px;
    background: #f0f0f0;
    border: 1px dashed #ccc;
    border-radius: 3px;
    cursor: pointer;
    height: 40px;
}
</style>