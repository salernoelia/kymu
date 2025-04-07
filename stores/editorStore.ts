export const useEditorStore = defineStore("editorStore", () => {
    const units = reactive<UnitWithDetails[]>([]);
    const isEditorLoaded = ref(false);

    const sidebarOpen = ref(false);
    const sidebarMode = ref<sidebarModes>("none");

    const selectedUnit = ref<UnitWithDetails | null>(null);
    const selectedExercise = ref<Tables<"exercises"> | null>(null);
    const selectedAssessment = ref<Tables<"assessments"> | null>(null);
    const selectedAssessmentTest = ref<Tables<"tests"> | null>(null);

    // temp
    const tempUnit = ref<UnitWithDetails>();
    const tempSourcePriorExerciseID = ref<Tables<"exercises">["id"]>();
    const tempTargetPriorExerciseID = ref<Tables<"exercises">["id"]>();

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

    const openTemplateOrNewExerciseSidebar = (
        unit: UnitWithDetails,
        sourcePriorIndexExerciseID: Tables<"exercises">["id"] | "new",
    ) => {
        sidebarOpen.value = true;
        sidebarMode.value = "templateOrNewExercise";
        tempUnit.value = unit;
        tempSourcePriorExerciseID.value = sourcePriorIndexExerciseID;

        console.log("new exercise");
    };

    const openNewExerciseSidebar = () => {
        sidebarOpen.value = true;
        sidebarMode.value = "newExercise";

        console.log("unit", tempUnit.value);

        console.log(
            "sourcePriorIndexExerciseID",
            tempSourcePriorExerciseID.value,
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
        isEditorLoaded,
        setUnits,
        getUnitByID,
        sidebarOpen,
        sidebarMode,
        openTemplateOrNewUnitSidebar,
        openTemplateOrNewExerciseSidebar,
        openNewExerciseSidebar,
        openEditExerciseSidebar,
        openEditUnitSidebar,
        selectedAssessment,
        selectedAssessmentTest,
        selectedExercise,
        selectedUnit,
    };
});
