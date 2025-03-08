<template>
    <div class="kanban-container">
        <div class="kanban-board">
            <h1>Unit Editor</h1>
            <div class="board-container">
                <KanbanColumn v-for="column in kanbanState.columns" :key="column.id" :column="column"
                    :cards="getCardsForColumn(column.id)" @delete-card="deleteCard" @card-moved="handleCardMoved"
                    @delete-column="deleteColumn" />
                <button class="add-column-btn" @click="openAddColumnSidebar">+ Add Column</button>
            </div>

            <KanbanSidebar v-model="sidebarOpen" :title="getSidebarTitle" width="50%" @closed="handleSidebarClosed">
                <div class="sidebar-form">
                    <div class="form-group">
                        <label for="item-title">Title</label>
                        <input id="item-title" v-model="kanbanState.formData.title" type="text"
                            placeholder="Enter title">
                    </div>

                    <div v-if="isCardForm" class="form-group">
                        <label for="item-description">Description</label>
                        <textarea id="item-description" v-model="kanbanState.formData.description"
                            placeholder="Enter description"></textarea>
                    </div>

                    <div class="form-actions">
                        <button class="btn-save" @click="saveForm">Save</button>
                        <button class="btn-cancel" @click="closeSidebar">Cancel</button>
                    </div>
                </div>
            </KanbanSidebar>
        </div>
    </div>
</template>

<script setup lang="ts">
const { t } = useI18n();
const kanbanStore = useKanbanStore();
const kanbanState = computed(() => kanbanStore);

const sidebarOpen = ref(false);

const getSidebarTitle = computed(() => {
    switch (kanbanState.value.formMode) {
        case 'add-column': return t('add-block');
        case 'edit-column': return t('edit-block');
        case 'add-card': return t('add-exercise');
        case 'edit-card': return t('edit-exercise');
        default: return '';
    }
});

// Computed to check if we're adding/editing a card (to show description field)
const isCardForm = computed(() => {
    return ['add-card', 'edit-card'].includes(kanbanState.value.formMode || '');
});

const getCardsForColumn = (columnId: string) => {
    return kanbanState.value.cards.filter(card => card.columnId === columnId);
};

// Sidebar handling
const openAddColumnSidebar = () => {
    kanbanStore.setFormMode('add-column');
    kanbanStore.formData.title = '';
    kanbanStore.formData.description = '';
    sidebarOpen.value = true;
};

const openEditColumnSidebar = (columnId: string) => {
    const column = kanbanState.value.columns.find(col => col.id === columnId);
    if (column) {
        kanbanStore.setFormMode('edit-column');
        kanbanStore.setActiveColumn(columnId);
        kanbanStore.formData.title = column.title;
        sidebarOpen.value = true;
    }
};

const openAddCardSidebar = (columnId: string) => {
    kanbanStore.setFormMode('add-card');
    kanbanStore.setActiveColumn(columnId);
    kanbanStore.formData.title = '';
    kanbanStore.formData.description = '';
    sidebarOpen.value = true;
};

const openEditCardSidebar = (cardId: string) => {
    kanbanStore.setFormMode('edit-card');
    kanbanStore.setActiveCard(cardId);
    sidebarOpen.value = true;
};

const closeSidebar = () => {
    sidebarOpen.value = false;
    kanbanStore.resetForm();
};

const saveForm = () => {
    kanbanStore.saveForm();
    sidebarOpen.value = false;
};

const handleSidebarClosed = () => {
    kanbanStore.resetForm();
};

// Column and card operations
const deleteColumn = (columnId: string) => {
    kanbanStore.deleteColumn(columnId);
};

const deleteCard = (cardId: string) => {
    kanbanStore.deleteCard(cardId);
};

const handleCardMoved = (payload: { cardId: string, toColumnId: string, newIndex: number }) => {
    kanbanStore.moveCard(payload.cardId, payload.toColumnId, payload.newIndex);
};

// Expose methods to be used by child components
provide('kanbanActions', {
    openEditColumnSidebar,
    openAddCardSidebar,
    openEditCardSidebar
});
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

.sidebar-form {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.form-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.form-group label {
    font-weight: 600;
}

.form-group input,
.form-group textarea {
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 16px;
}

.form-group textarea {
    min-height: 120px;
    resize: vertical;
}

.form-actions {
    display: flex;
    gap: 10px;
    margin-top: 20px;
}

.form-actions button {
    padding: 10px 20px;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
}

.btn-save {
    background: #4f46e5;
    color: white;
    border: none;
}

.btn-cancel {
    background: transparent;
    border: 1px solid #ddd;
}
</style>