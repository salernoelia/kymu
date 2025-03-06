import { defineStore } from "pinia";

interface KanbanCard {
    id: string;
    columnId: string;
    title: string;
    description: string;
    order: number;
}

interface KanbanColumn {
    id: string;
    title: string;
    order: number;
}

interface KanbanState {
    columns: KanbanColumn[];
    cards: KanbanCard[];
}

export const useKanbanStore = defineStore("kanban", {
    state: (): KanbanState => ({
        columns: [
            { id: "column-1", title: "To Do", order: 0 },
            { id: "column-2", title: "In Progress", order: 1 },
            { id: "column-3", title: "Done", order: 2 },
        ],
        cards: [
            {
                id: "card-1",
                columnId: "column-1",
                title: "Task 1",
                description: "Description for task 1",
                order: 0,
            },
            {
                id: "card-2",
                columnId: "column-1",
                title: "Task 2",
                description: "Description for task 2",
                order: 1,
            },
            {
                id: "card-3",
                columnId: "column-2",
                title: "Task 3",
                description: "Description for task 3",
                order: 0,
            },
        ],
    }),

    actions: {
        addColumn(title: string) {
            const newColumn: KanbanColumn = {
                id: `column-${Date.now()}`,
                title,
                order: this.columns.length,
            };
            this.columns.push(newColumn);
        },

        updateColumn(columnId: string, updates: Partial<KanbanColumn>) {
            const index = this.columns.findIndex((col) => col.id === columnId);
            if (index !== -1) {
                this.columns[index] = { ...this.columns[index], ...updates };
            }
        },

        deleteColumn(columnId: string) {
            this.columns = this.columns.filter((col) => col.id !== columnId);
            this.cards = this.cards.filter((card) =>
                card.columnId !== columnId
            );
            this.reorderColumns();
        },

        reorderColumns() {
            this.columns.forEach((col, index) => {
                col.order = index;
            });
        },

        addCard(card: KanbanCard) {
            this.cards.push(card);
        },

        updateCard(cardId: string, updates: Partial<KanbanCard>) {
            const index = this.cards.findIndex((card) => card.id === cardId);
            if (index !== -1) {
                this.cards[index] = { ...this.cards[index], ...updates };
            }
        },

        deleteCard(cardId: string) {
            this.cards = this.cards.filter((card) => card.id !== cardId);
            this.reorderCards();
        },

        reorderCards() {
            const columnMap = new Map();

            this.cards.forEach((card) => {
                if (!columnMap.has(card.columnId)) {
                    columnMap.set(card.columnId, []);
                }
                columnMap.get(card.columnId).push(card);
            });

            columnMap.forEach((cards) => {
                cards.sort((a: KanbanCard, b: KanbanCard) => a.order - b.order);
                cards.forEach((card: KanbanCard, index: number) => {
                    card.order = index;
                });
            });
        },

        moveCard(cardId: string, toColumnId: string, newIndex: number) {
            const cardIndex = this.cards.findIndex((card) =>
                card.id === cardId
            );
            if (cardIndex === -1) return;

            const card = this.cards[cardIndex];
            const fromColumnId = card.columnId;

            // Update the card's column
            card.columnId = toColumnId;

            // Get cards in the destination column
            const columnCards = this.cards
                .filter((c) => c.columnId === toColumnId && c.id !== cardId)
                .sort((a, b) => a.order - b.order);

            // Insert the card at the right position
            columnCards.splice(newIndex, 0, card);

            // Update orders
            columnCards.forEach((c, i) => {
                c.order = i;
            });

            // If moving between columns, reorder the source column
            if (fromColumnId !== toColumnId) {
                const sourceCards = this.cards
                    .filter((c) => c.columnId === fromColumnId)
                    .sort((a, b) => a.order - b.order);

                sourceCards.forEach((c, i) => {
                    c.order = i;
                });
            }
        },

        resetBoard() {
            this.columns = [];
            this.cards = [];
        },
    },
});
