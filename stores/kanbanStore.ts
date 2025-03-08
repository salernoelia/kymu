export const useKanbanStore = defineStore("kanban", {
    state: () => ({
        columns: [] as KanbanColumn[],
        cards: [] as KanbanCard[],
    }),

    actions: {
        addColumn(title: string) {
            this.columns.push({
                id: `column-${Date.now()}`,
                title,
            });
        },

        updateColumn(columnId: string, updatedColumn: { title: string }) {
            const index = this.columns.findIndex((col) => col.id === columnId);
            if (index !== -1) {
                this.columns[index] = {
                    ...this.columns[index],
                    ...updatedColumn,
                };
            }
        },

        deleteColumn(columnId: string) {
            this.columns = this.columns.filter((col) => col.id !== columnId);
            this.cards = this.cards.filter((card) =>
                card.columnId !== columnId
            );
        },

        // Card operations
        addCard(card: Omit<KanbanCard, "order"> & { order?: number }) {
            const order = card.order ??
                this.getMaxOrderForColumn(card.columnId) + 1;
            this.cards.push({ ...card, order });
        },

        updateCard(cardId: string, updatedCard: Partial<KanbanCard>) {
            const index = this.cards.findIndex((card) => card.id === cardId);
            if (index !== -1) {
                this.cards[index] = { ...this.cards[index], ...updatedCard };
            }
        },

        deleteCard(cardId: string) {
            const deletedCard = this.cards.find((card) => card.id === cardId);
            if (!deletedCard) return;

            // Remove the card
            this.cards = this.cards.filter((card) => card.id !== cardId);

            const columnCards = this.cards
                .filter((card) => card.columnId === deletedCard.columnId)
                .sort((a, b) => a.order - b.order);

            columnCards.forEach((card, index) => {
                card.order = index;
            });
        },

        moveCard(cardId: string, targetColumnId: string, newIndex: number) {
            const cardToMove = this.cards.find((card) => card.id === cardId);
            if (!cardToMove) return;

            const sourceColumnId = cardToMove.columnId;
            cardToMove.columnId = targetColumnId;

            if (sourceColumnId !== targetColumnId) {
                const sourceCards = this.cards
                    .filter((card) => card.columnId === sourceColumnId)
                    .sort((a, b) => a.order - b.order);

                sourceCards.forEach((card, index) => {
                    card.order = index;
                });
            }

            const targetCards = this.cards
                .filter((card) =>
                    card.columnId === targetColumnId && card.id !== cardId
                )
                .sort((a, b) => a.order - b.order);

            targetCards.splice(newIndex, 0, cardToMove);

            targetCards.forEach((card, index) => {
                card.order = index;
            });
        },

        getMaxOrderForColumn(columnId: string): number {
            const columnCards = this.cards.filter((card) =>
                card.columnId === columnId
            );
            if (columnCards.length === 0) return 0;
            return Math.max(...columnCards.map((card) => card.order));
        },

        resetBoard() {
            this.columns = [];
            this.cards = [];
        },
    },
});
