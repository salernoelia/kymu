export const useDragDropStore = defineStore("dragDropStore", () => {
    const draggingExercise = ref(false);
    const draggedExerciseId = ref<string | null>(null);
    const draggingAssessment = ref(false);
    const draggedAssessmentId = ref<string | null>(null);
    const sourceUnitId = ref<string | null>(null);

    const editorStore = useEditorStore();

    // drag and drop

    const startDragExercise = (
        event: DragEvent,
        exercise: Tables<"exercises">,
        unitId: string,
    ) => {
        if (event.dataTransfer) {
            draggingExercise.value = true;
            draggedExerciseId.value = exercise.id;
            sourceUnitId.value = unitId;
            event.dataTransfer.dropEffect = "move";
            event.dataTransfer.effectAllowed = "move";
            event.dataTransfer.setData("exerciseID", exercise.id);
            event.dataTransfer.setData("sourceUnitID", unitId);
        }
    };

    const endDragExercise = (event: DragEvent) => {
        draggingExercise.value = false;
        draggedExerciseId.value = null;
        sourceUnitId.value = null;
    };

    const onDropExercise = (
        event: DragEvent,
        targetUnitId: Tables<"units">["id"],
        position?: number,
    ) => {
        event.preventDefault();

        const targetUnit = editorStore.getUnitByID(targetUnitId);

        if (!targetUnit) {
            console.log("no unit found!", targetUnit);
            return;
        }

        const exerciseID = event.dataTransfer?.getData("exerciseID");
        const sourceUnitID = event.dataTransfer?.getData("sourceUnitID");

        if (!exerciseID || !sourceUnitID) return;

        const sourceUnit = editorStore.units.find((u) => u.id === sourceUnitID);
        if (!sourceUnit) return;

        const exerciseIndex = sourceUnit.exercises.findIndex((e) =>
            e.id === exerciseID
        );
        if (exerciseIndex === -1) return;

        const exercise = sourceUnit.exercises[exerciseIndex];

        sourceUnit.exercises.splice(exerciseIndex, 1);

        const insertPosition = position !== undefined
            ? position
            : targetUnit.exercises.length;
        targetUnit.exercises.splice(insertPosition, 0, exercise);
    };

    const isExerciseBeingDragged = (exerciseId: string) => {
        return draggingExercise.value && draggedExerciseId.value === exerciseId;
    };

    return {
        startDragExercise,
        onDropExercise,
        draggingExercise,
        endDragExercise,
        isExerciseBeingDragged,
    };
});
