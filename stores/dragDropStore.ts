export const useDragDropStore = defineStore("dragDropStore", () => {
    const exerciseCrud = useExerciseCrud();

    const draggingExercise = ref(false);
    const draggedExerciseID = ref<string | null>(null);
    const draggedExerciseSourceUnitID = ref<Tables<"units">["id"]>();
    const draggedExerciseTargetUnitID = ref<Tables<"units">["id"]>();
    const draggedExerciseTargetPreviousExerciseID = ref<
        Tables<"exercises">["id"] | null
    >();

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
            draggedExerciseID.value = exercise.id;
            sourceUnitId.value = unitId;
            draggedExerciseSourceUnitID.value = sourceUnitId.value;
            event.dataTransfer.dropEffect = "move";
            event.dataTransfer.effectAllowed = "move";
            event.dataTransfer.setData("exerciseID", exercise.id);
            event.dataTransfer.setData("sourceUnitID", unitId);
        }
    };

    const endDragExercise = (event: DragEvent) => {
        draggingExercise.value = false;
    };

    const cleanupDragging = () => {
        draggedExerciseID.value = null;
        sourceUnitId.value = null;
    };

    const onDropExercise = (
        event: DragEvent,
        targetUnitId: Tables<"units">["id"],
        position?: number,
    ) => {
        event.preventDefault();

        const targetUnit = editorStore.getUnitByID(targetUnitId);
        draggedExerciseTargetUnitID.value = targetUnit?.id;

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

        // Calculate insert position, accounting for the case where we're moving within the same unit
        let insertPosition = position !== undefined
            ? position
            : targetUnit.exercises.length;
        const isSameUnit = sourceUnitID === targetUnitId;

        // If we're moving within the same unit, and moving to a later position,
        // we need to adjust the insert position because removing the exercise will shift indexes
        if (isSameUnit && exerciseIndex < insertPosition) {
            insertPosition--;
        }

        // Remove from source
        sourceUnit.exercises.splice(exerciseIndex, 1);

        // Add to target at the specified position
        targetUnit.exercises.splice(insertPosition, 0, exercise);

        // Determine the previous exercise in the target unit
        // Ensure we're not setting an exercise as its own previous exercise
        let previousExerciseId = null;
        if (insertPosition > 0) {
            const previousExercise = targetUnit.exercises[insertPosition - 1];
            if (previousExercise.id !== exerciseID) {
                previousExerciseId = previousExercise.id;
            }
        }

        draggedExerciseTargetPreviousExerciseID.value = previousExerciseId;

        if (
            draggedExerciseID.value &&
            draggedExerciseSourceUnitID.value &&
            draggedExerciseTargetUnitID.value
        ) {
            exerciseCrud.updateExercisePosition(
                draggedExerciseID.value,
                draggedExerciseTargetPreviousExerciseID.value,
                draggedExerciseSourceUnitID.value,
                draggedExerciseTargetUnitID.value,
            );

            console.log("draggedExerciseID.value", draggedExerciseID.value);
            console.log(
                "draggedExerciseTargetPreviousExerciseID.value",
                draggedExerciseTargetPreviousExerciseID.value,
            );
            console.log(
                "draggedExerciseSourceUnitID.value",
                draggedExerciseSourceUnitID.value,
            );
            console.log(
                "draggedExerciseTargetUnitID.value",
                draggedExerciseTargetUnitID.value,
            );
        } else {
            // If there's an issue, revert the UI change
            targetUnit.exercises.splice(insertPosition, 1);
            sourceUnit.exercises.splice(exerciseIndex, 0, exercise);

            alert("cannot update on DB as a value is missing");
            console.log("draggedExerciseID.value", draggedExerciseID.value);
            console.log(
                "draggedExerciseTargetPreviousExerciseID.value",
                draggedExerciseTargetPreviousExerciseID.value,
            );
            console.log(
                "draggedExerciseSourceUnitID.value",
                draggedExerciseSourceUnitID.value,
            );
            console.log(
                "draggedExerciseTargetUnitID.value",
                draggedExerciseTargetUnitID.value,
            );
        }
        cleanupDragging();
    };

    const isExerciseBeingDragged = (exerciseId: string) => {
        return draggingExercise.value && draggedExerciseID.value === exerciseId;
    };

    return {
        startDragExercise,
        onDropExercise,
        draggingExercise,
        endDragExercise,
        isExerciseBeingDragged,
    };
});
