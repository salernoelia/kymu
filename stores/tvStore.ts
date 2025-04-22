export const useTVStore = defineStore("tvStore", () => {
    const unitCrud = useUnitCrud();
    const units = ref<UnitWithDetails[]>([]);
    const currentUnit = ref<UnitWithDetails | undefined>(undefined);
    const isLoading = ref(false);
    const error = ref<string | null>(null);

    const exerciseStateMachine = useExerciseStateMachine();

    const getUnitById = async (
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
                initializeExercises();
                return cachedUnit;
            }

            await fetchUnits();

            const fetchedUnit = units.value.find((unit) => unit.id === id);
            currentUnit.value = fetchedUnit;
            initializeExercises();

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

    const getUnitExerciseStatus = (): ExerciseStatus => {
        const exercises = exerciseStateMachine.getAllExercises();
        if (!exercises || exercises.length === 0) {
            return "not_started";
        }

        const hasCompleted = exercises.some((ex) =>
            ex.status === "completed" || ex.status === "skipped"
        );
        const hasInProgress = exercises.some((ex) =>
            ex.status === "in_progress"
        );

        if (hasCompleted && !hasInProgress) {
            return "completed";
        } else if (hasInProgress || hasCompleted) {
            return "in_progress";
        } else {
            return "not_started";
        }
    };

    const initializeExercises = () => {
        if (!currentUnit.value || !currentUnit.value.id) return;
        exerciseStateMachine.initializeExercises(currentUnit.value.exercises);
    };

    const getExerciseById = (exerciseId: string) => {
        const exercises = exerciseStateMachine.getAllExercises();
        return exercises.find((ex) => ex.id === exerciseId);
    };

    const setCurrentExercise = (exerciseId: string) => {
        const exercises = exerciseStateMachine.getAllExercises();
        const index = exercises.findIndex((ex) => ex.id === exerciseId);
        if (index >= 0) {
            exerciseStateMachine.goToExercise(index);
        }
    };

    onMounted(async () => {
        await fetchUnits();
        initializeExercises();
    });

    return {
        units,
        currentUnit,
        isLoading,
        error,
        getUnitById,
        fetchUnits,
        initializeExercises,
        getUnitExerciseStatus,
        getExerciseById,
        setCurrentExercise,
        exerciseStateMachine,
        currentExercise: exerciseStateMachine.currentExercise,
        exerciseProgress: exerciseStateMachine.progress,
    };
});
