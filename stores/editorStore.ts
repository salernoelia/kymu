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

    const openSidebar = (
        mode: sidebarModes,
        options: {
            unitId?: string;
            exerciseId?: string;
            assessmentId?: string;
            testId?: string;
        } = {},
    ) => {
        const { unitId, exerciseId, assessmentId, testId } = options;
        sidebarOpen.value = true;
        sidebarMode.value = mode;

        console.log("options", exerciseId);

        // Set selected items based on provided IDs
        if (unitId) {
            selectedUnit.value = units.find((u) => u.id === unitId) || null;
        }
        if (exerciseId) selectedExercise.value = /* find exercise logic */ null;
        if (assessmentId) {
            selectedAssessment.value = /* find assessment logic */ null;
        }
        if (testId) selectedAssessmentTest.value = /* find test logic */ null;
    };

    const setUnits = (newUnits: UnitWithDetails[]) => {
        Object.assign(units, newUnits);
    };

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
        openSidebar,
    };
});
