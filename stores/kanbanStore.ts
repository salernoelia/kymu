export const useKanbanStore = defineStore("kanban", {
    state: () => ({
        columns: [] as KanbanColumn[],
        cards: [] as KanbanCard[],
        formMode: null as
            | "add-column"
            | "edit-column"
            | "add-card"
            | "edit-card"
            | null,
        activeColumnId: null as string | null,
        activeCardId: null as string | null,
        formData: {
            title: "",
            description: "",
        },
    }),

    actions: {
        // Form management actions
        setFormMode(
            mode:
                | "add-column"
                | "edit-column"
                | "add-card"
                | "edit-card"
                | null,
        ) {
            this.formMode = mode;
        },

        setActiveColumn(columnId: string | null) {
            this.activeColumnId = columnId;
        },

        setActiveCard(cardId: string | null) {
            this.activeCardId = cardId;

            if (cardId) {
                const card = this.cards.find((c) => c.id === cardId);
                if (card) {
                    this.formData = {
                        title: card.title,
                        description: card.description,
                    };
                }
            }
        },

        resetForm() {
            this.formMode = null;
            this.activeColumnId = null;
            this.activeCardId = null;
            this.formData = { title: "", description: "" };
        },

        // Existing actions
        addColumn(title: string, description: string, goal: string) {
            this.columns.push({
                id: `column-${Date.now()}`,
                title,
                description,
                goal,
            });
        },

        updateColumn(
            columnId: string,
            updatedColumn: { title: string; description: string; goal: string },
        ) {
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

        // Save form data based on current form mode
        saveForm() {
            if (!this.formMode) return;

            const { title, description } = this.formData;

            switch (this.formMode) {
                case "add-column":
                    if (title.trim()) {
                        this.addColumn(title.trim(), "", "");
                    }
                    break;

                case "edit-column":
                    if (this.activeColumnId && title.trim()) {
                        this.updateColumn(this.activeColumnId, {
                            title: title.trim(),
                            description: "",
                            goal: "",
                        });
                    }
                    break;

                case "add-card":
                    if (this.activeColumnId && title.trim()) {
                        this.addCard({
                            id: `card-${Date.now()}`,
                            columnId: this.activeColumnId,
                            title: title.trim(),
                            description: description || "",
                            order:
                                this.getMaxOrderForColumn(this.activeColumnId) +
                                1,
                        });
                    }
                    break;

                case "edit-card":
                    if (this.activeCardId && title.trim()) {
                        this.updateCard(this.activeCardId, {
                            title: title.trim(),
                            description: description || "",
                        });
                    }
                    break;
            }

            this.resetForm();
        },
    },
});
