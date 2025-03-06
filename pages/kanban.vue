<template>
    <NuxtLayoutEmpty>
        <div class="kanban-container">
            <KanbanSidebar :templates="templates" @add-template="addTemplate" @use-template="useTemplate" />
            <div class="kanban-board">
                <h1>Kanban Board</h1>
                <div class="board-container">
                    <KanbanColumn v-for="column in kanbanState.columns" :key="column.id" :column="column"
                        :cards="getCardsForColumn(column.id)" @add-card="addCard" @delete-card="deleteCard"
                        @update-card="updateCard" @card-moved="handleCardMoved" />
                    <button class="add-column-btn" @click="addColumn">+ Add Column</button>
                </div>
            </div>
        </div>
    </NuxtLayoutEmpty>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { useKanbanStore } from '~/stores/kanbanStore';

definePageMeta
    ({
        layout
            : 'empty'
    })

const kanbanStore = useKanbanStore();
const kanbanState = computed(() => kanbanStore);
const templates = ref([
    { id: 1, name: 'Basic Kanban', columns: ['To Do', 'In Progress', 'Done'] },
    { id: 2, name: 'Project Management', columns: ['Backlog', 'Ready', 'In Progress', 'QA', 'Done'] },
    { id: 3, name: 'Patient Management', columns: ['New Patients', 'Ongoing Treatment', 'Recovery', 'Completed'] },
]);

const getCardsForColumn = (columnId: string) => {
    return kanbanState.value.cards.filter(card => card.columnId === columnId);
};

const addColumn = () => {
    kanbanStore.addColumn(`Column ${kanbanState.value.columns.length + 1}`);
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

const updateCard = (cardId: string, updatedCard: any) => {
    kanbanStore.updateCard(cardId, updatedCard);
};

const handleCardMoved = (payload: { cardId: string, toColumnId: string, newIndex: number }) => {
    kanbanStore.moveCard(payload.cardId, payload.toColumnId, payload.newIndex);
};

const addTemplate = (template: any) => {
    templates.value.push({ ...template, id: templates.value.length + 1 });
};

const useTemplate = (template: any) => {
    kanbanStore.resetBoard();
    template.columns.forEach((columnName: string) => {
        kanbanStore.addColumn(columnName);
    });
};
</script>

<style scoped>
.kanban-container {
    display: flex;
    height: 100vh;
}

.kanban-board {
    flex-grow: 1;
    padding: 20px;
    overflow-y: auto;
}

.board-container {
    display: flex;
    gap: 20px;
    align-items: flex-start;
    overflow-x: auto;
    padding-bottom: 20px;
}

.add-column-btn {
    min-width: 250px;
    height: 50px;
    background-color: #f1f1f1;
    border: 2px dashed #ccc;
    border-radius: 4px;
    cursor: pointer;
}
</style>