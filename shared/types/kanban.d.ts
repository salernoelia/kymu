export interface KanbanCard {
    id: string;
    columnId: string;
    title: string;
    description: string;
    order: number;
}

export interface KanbanColumn {
    id: string;
    title: string;
    description: string;
    goal: string;
}
