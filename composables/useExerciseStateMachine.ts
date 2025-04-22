export const useExerciseStateMachine = () => {
    const exercises = ref<ExerciseCollection>([]);
    const currentExerciseIndex = ref<number>(0);
    const isLoading = ref<boolean>(false);
    const error = ref<string | null>(null);

    const currentExercise = computed(() => {
        if (exercises.value.length === 0) return null;
        return exercises.value[currentExerciseIndex.value];
    });

    const isFirstExercise = computed(() => currentExerciseIndex.value === 0);

    const isLastExercise = computed(() =>
        currentExerciseIndex.value === exercises.value.length - 1
    );

    const progress = computed(() => {
        if (exercises.value.length === 0) {
            return { current: 0, total: 0, percentage: 0 };
        }
        const current = currentExerciseIndex.value + 1;
        const total = exercises.value.length;
        const percentage = Math.round((current / total) * 100);
        return { current, total, percentage };
    });

    const initializeExercises = (unitExercises: any[]) => {
        if (!unitExercises || unitExercises.length === 0) {
            exercises.value = [];
            return;
        }

        exercises.value = unitExercises.map((exercise) => ({
            ...exercise,
            status: exercise.completed_status === "none"
                ? "not_started"
                : exercise.completed_status,
            results: exercise.results || {},
            unitId: exercise.unitID,
        })) as ExerciseCollection;

        currentExerciseIndex.value = 0;
    };

    const goToNextExercise = () => {
        if (isLastExercise.value) return;
        currentExerciseIndex.value++;
    };

    const goToPreviousExercise = () => {
        if (isFirstExercise.value) return;
        currentExerciseIndex.value--;
    };

    const startExercise = () => {
        if (!currentExercise.value) return;
        currentExercise.value.status = "in_progress";
    };

    const completeExercise = (results?: ExerciseResults) => {
        if (!currentExercise.value) return;
        currentExercise.value.status = "completed";
        if (results) {
            currentExercise.value.results = results;
        }
    };

    const skipExercise = () => {
        if (!currentExercise.value) return;
        currentExercise.value.status = "skipped";
    };

    const getExerciseStatus = () => {
        if (!currentExercise.value) return null;
        return currentExercise.value.status;
    };

    const getAllExercises = () => exercises.value;

    const goToExercise = (index: number) => {
        if (index >= 0 && index < exercises.value.length) {
            currentExerciseIndex.value = index;
        }
    };

    return {
        exercises,
        currentExercise,
        currentExerciseIndex,
        isLoading,
        error,
        progress,
        isFirstExercise,
        isLastExercise,
        initializeExercises,
        goToNextExercise,
        goToPreviousExercise,
        startExercise,
        completeExercise,
        skipExercise,
        getExerciseStatus,
        getAllExercises,
        goToExercise,
    };
};
