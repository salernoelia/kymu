// import { useStorage } from "@vueuse/core";

export const useTVStore = defineStore("tvStore", () => {
    const exerciseStateMachine = useExerciseStateMachine();
    const unitCrud = useUnitCrud();
    const units = ref<UnitWithDetails[]>([]);

    // const currentUnit = useStorage<UnitWithDetails | undefined>(
    //     "current-unit",
    //     undefined,
    // );
    // const exercisesStates = useStorage<ExercisesStates>(
    //     "exercises-state",
    //     [],
    // );
    const currentUnit = ref<UnitWithDetails | undefined>(
        undefined,
    );
    const exercisesStates = ref<ExercisesStates>(
        [],
    );
    const currentExercise = ref<ExerciseState>();

    const isLoading = ref(false);
    const error = ref<string | null>(null);

    /**
     * Get a unit by its ID, first checking the local cache, then fetching if needed
     * @param id The unit ID to retrieve
     * @returns The found unit or undefined
     */
    const getInstanceUnitByID = async (
        id: string,
    ): Promise<UnitWithDetails | undefined> => {
        if (!id) {
            error.value = "Invalid unit ID";
            return undefined;
        }
        try {
            isLoading.value = true;
            error.value = null;

            const cachedUnit = units.value.find((unit) => unit.id === id);
            if (cachedUnit) {
                currentUnit.value = cachedUnit;
                return cachedUnit;
            }

            // If not in cache, fetch all units and find the one we want
            await fetchUnits();

            const fetchedUnit = units.value.find((unit) => unit.id === id);
            currentUnit.value = fetchedUnit;

            return fetchedUnit;
        } catch (err) {
            console.error("Failed to get unit:", err);
            error.value = err instanceof Error
                ? err.message
                : "Failed to retrieve unit";
            return undefined;
        } finally {
            isLoading.value = false;
        }
    };

    /**
     * Fetch all units with details
     */
    const fetchUnits = async (): Promise<void> => {
        try {
            isLoading.value = true;
            error.value = null;
            units.value = await unitCrud.getWithDetails(true) || [];
        } catch (err) {
            console.error("Failed to fetch units:", err);
            error.value = err instanceof Error
                ? err.message
                : "Failed to fetch units";
            units.value = [];
        } finally {
            isLoading.value = false;
        }
    };

    const checkExercisesStates = (): completed_status => {
        if (
            !exercisesStates.value ||
            exercisesStates.value.length === 0
        ) {
            return "none";
        }

        const hasCompleted = exercisesStates.value.some((state) =>
            state.completed_status === "completed" ||
            state.completed_status === "skipped"
        );
        const hasOngoing = exercisesStates.value.some((state) =>
            state.completed_status === "ongoing"
        );

        if (hasCompleted) {
            return "completed";
        } else if (hasOngoing) {
            return "ongoing";
        } else {
            return "none";
        }
    };

    const initializeExercisesState = () => {
        if (!currentUnit.value || !currentUnit.value.id) return;
        exercisesStates.value = currentUnit.value.exercises.map((exercise) => ({
            ...exercise,
            unitID: currentUnit.value!.id,
            created_at: new Date().toISOString(),
            completed_status: "none" as completed_status,
            results: {},
        })) as ExercisesStates;
        console.log("Exercise State inizialized", exercisesStates.value);
    };

    onMounted(async () => {
        await fetchUnits();
        initializeExercisesState();
    });

    return {
        units,
        currentUnit,
        isLoading,
        error,
        exercisesStates,
        getInstanceUnitByID,
        fetchUnits,
        initializeExercisesState,
        checkExercisesStates,
    };
});
