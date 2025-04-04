import type { Tables } from "~/shared/types/database";

export const useEditorStore = defineStore("editorStore", () => {
    const units = reactive<UnitWithDetails[]>([]);
    const draggingExercise = ref(false);
    const draggedExerciseId = ref<string | null>(null);
    const draggingAssessment = ref(false);
    const draggedAssessmentId = ref<string | null>(null);

    const sidebarOpen = ref(true);

    const sidebarMode = ref<sidebarModes>("newExercise");

    const sourceUnitId = ref<string | null>(null);

    const selectedUnit = ref<UnitWithDetails | null>(null);
    const selectedExercise = ref<Tables<"exercises"> | null>(null);
    const selectedAssessment = ref<Tables<"assessments"> | null>(null);
    const selectedAssessmentTest = ref<Tables<"tests"> | null>(null);

    const openNewExerciseSidebar = (
        unit: UnitWithDetails,
        sourcePriorIndexExerciseID: Tables<"exercises">["id"] | "new",
    ) => {
        sidebarOpen.value = true;
        sidebarMode.value = "newExercise";

        console.log("unit", unit);

        console.log(
            "sourcePriorIndexExerciseID",
            sourcePriorIndexExerciseID,
        );
    };

    const openEditExerciseSidebar = (
        exerciseID: Tables<"exercises">["id"],
    ) => {
        sidebarOpen.value = true;
        sidebarMode.value = "editExercise";

        selectedExercise.value = units
            .flatMap((unit) => unit.exercises)
            .find((exercise) => exercise.id === exerciseID) || null;

        console.log("selectedExercise", selectedExercise.value);
    };

    const setUnits = (newUnits: UnitWithDetails[]) => {
        Object.assign(units, newUnits);
    };

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
        return draggingExercise.value && draggedExerciseId.value === exerciseId;
    };

    return {
        units,
        setUnits,
        startDragExercise,
        onDropExercise,
        draggingExercise,
        endDragExercise,
        isExerciseBeingDragged,
        sidebarOpen,
        sidebarMode,
        openNewExerciseSidebar,
        openEditExerciseSidebar,
        selectedAssessment,
        selectedAssessmentTest,
        selectedExercise,
        selectedUnit,
    };
});
