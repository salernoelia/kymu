import type { Tables } from "~/shared/types/database";

export const useEditorStore = defineStore("editorStore", () => {
    const units = reactive<UnitWithDetails[]>([]);
    const dragging = ref(false);
    const draggedExerciseId = ref<string | null>(null);
    const sourceUnitId = ref<string | null>(null);

    const setUnits = (newUnits: UnitWithDetails[]) => {
        Object.assign(units, newUnits);
    };

    const startDragExercise = (
        event: DragEvent,
        exercise: Tables<"exercises">,
        unitId: string,
    ) => {
        if (event.dataTransfer) {
            dragging.value = true;
            draggedExerciseId.value = exercise.id;
            sourceUnitId.value = unitId;
            event.dataTransfer.dropEffect = "move";
            event.dataTransfer.effectAllowed = "move";
            event.dataTransfer.setData("exerciseID", exercise.id);
            event.dataTransfer.setData("sourceUnitID", unitId);
        }
    };

    const endDragExercise = (event: DragEvent) => {
        dragging.value = false;
        draggedExerciseId.value = null;
        sourceUnitId.value = null;
    };

    const onDropExercise = (
        event: DragEvent,
        targetUnit: UnitWithDetails,
        position?: number,
    ) => {
        event.preventDefault();

        const exerciseID = event.dataTransfer?.getData("exerciseID");
        const sourceUnitID = event.dataTransfer?.getData("sourceUnitID");

        if (!exerciseID || !sourceUnitID) return;

        const sourceUnit = units.find((u) => u.id === sourceUnitID);
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
        return dragging.value && draggedExerciseId.value === exerciseId;
    };

    return {
        units,
        setUnits,
        startDragExercise,
        onDropExercise,
        dragging,
        endDragExercise,
        isExerciseBeingDragged,
    };
});
