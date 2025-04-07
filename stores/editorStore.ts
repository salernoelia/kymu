export const useEditorStore = defineStore("editorStore", () => {
    const units = reactive<UnitWithDetails[]>([]);

    const sidebarOpen = ref(false);
    const sidebarMode = ref<sidebarModes>("none");

    const selectedUnit = ref<UnitWithDetails | null>(null);
    const selectedExercise = ref<Tables<"exercises"> | null>(null);
    const selectedAssessment = ref<Tables<"assessments"> | null>(null);
    const selectedAssessmentTest = ref<Tables<"tests"> | null>(null);

    const getUnitByID = (
        unitID: Tables<"units">["id"],
    ): UnitWithDetails | null => {
        const foundUnit = units.find((unit) => unit.id === unitID);
        return foundUnit || null;
    };

    const openTemplateOrNewUnitSidebar = () => {
        sidebarOpen.value = true;
        sidebarMode.value = "templateOrNewUnit";

        console.log("new unit");
    };

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

    const openEditUnitSidebar = (
        unit: UnitWithDetails,
    ) => {
        sidebarOpen.value = true;
        sidebarMode.value = "editUnit";
    };

    const setUnits = (newUnits: UnitWithDetails[]) => {
        Object.assign(units, newUnits);
    };

    return {
        units,
        setUnits,
        getUnitByID,
        sidebarOpen,
        sidebarMode,
        openTemplateOrNewUnitSidebar,
        openNewExerciseSidebar,
        openEditExerciseSidebar,
        openEditUnitSidebar,
        selectedAssessment,
        selectedAssessmentTest,
        selectedExercise,
        selectedUnit,
    };
});
