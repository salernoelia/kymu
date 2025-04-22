import { useRoute, useRouter } from "vue-router";
import { useTVStore } from "~/stores/tvStore";

/**
 * Exercise state machine singleton that manages exercise navigation and state transitions
 */
export class ExerciseStateMachine {
    private static instance: ExerciseStateMachine;
    private tvStore: ReturnType<typeof useTVStore>;
    private router: ReturnType<typeof useRouter>;
    private route: ReturnType<typeof useRoute>;
    private currentExerciseIndex: number = 0;

    private constructor() {
        this.tvStore = useTVStore();
        this.router = useRouter();
        this.route = useRoute();
    }

    /**
     * Get the singleton instance of the exercise state machine
     */
    public static getInstance(): ExerciseStateMachine {
        if (!ExerciseStateMachine.instance) {
            ExerciseStateMachine.instance = new ExerciseStateMachine();
        }
        return ExerciseStateMachine.instance;
    }

    /**
     * Initialize the state machine with the current exercise
     * @param exerciseId The current exercise ID
     */
    public initialize(exerciseId?: string): void {
        const { currentUnit } = this.tvStore;

        if (!currentUnit?.exercises?.length) {
            console.error("Cannot initialize: No exercises available");
            return;
        }

        // Initialize exercise states if not already done
        if (!this.tvStore.exercisesStates?.length) {
            this.tvStore.initializeExercisesState();
        }

        // Set current exercise index
        if (exerciseId) {
            const index = currentUnit.exercises.findIndex(
                (ex) => ex.Id === exerciseId,
            );
            this.currentExerciseIndex = index >= 0 ? index : 0;
        } else {
            this.currentExerciseIndex = 0;
        }
    }

    /**
     * Navigate to the next exercise
     */
    public nextExercise(): void {
        const { currentUnit } = this.tvStore;
        if (!currentUnit?.exercises?.length) return;

        const exercisesCount = currentUnit.exercises.length;
        if (this.currentExerciseIndex < exercisesCount - 1) {
            this.currentExerciseIndex++;
            this.navigateToCurrentExercise();
        } else {
            // We're at the end, navigate back to unit page or show completion
            this.navigateToUnitSummary();
        }
    }

    /**
     * Navigate to the previous exercise
     */
    public previousExercise(): void {
        const { currentUnit } = this.tvStore;
        if (!currentUnit?.exercises?.length) return;

        if (this.currentExerciseIndex > 0) {
            this.currentExerciseIndex--;
            this.navigateToCurrentExercise();
        } else {
            // We're at the beginning, navigate back to unit list
            this.navigateToUnitList();
        }
    }

    /**
     * Skip the current exercise
     */
    public skipExercise(): void {
        this.updateExerciseStatus("skipped");
        this.nextExercise();
    }

    /**
     * Mark the current exercise as completed
     * @param results Optional results data to save
     */
    public completeExercise(results?: ExerciseResults): void {
        this.updateExerciseStatus("completed", results);
        this.nextExercise();
    }

    /**
     * Retry the current exercise
     */
    public retryExercise(): void {
        this.updateExerciseStatus("none");
        this.navigateToCurrentExercise();
    }

    /**
     * Update the status of the current exercise
     * @param status New status to set
     * @param results Optional results data
     */
    private updateExerciseStatus(
        status: completed_status,
        results?: ExerciseResults,
    ): void {
        const { currentUnit, exercisesStates } = this.tvStore;

        if (!currentUnit?.value?.exercises || !exercisesStates?.length) return;

        const currentExercise =
            currentUnit.value.exercises[this.currentExerciseIndex];
        if (!currentExercise) return;

        const stateIndex = exercisesStates.findIndex(
            (state) => state.Id === currentExercise.Id,
        );

        if (stateIndex >= 0) {
            // Clone the state to maintain reactivity
            const updatedStates = [...exercisesStates];
            updatedStates[stateIndex] = {
                ...updatedStates[stateIndex],
                completed_status: status,
                results: results || updatedStates[stateIndex].results,
            };

            // Update the state in the store
            this.tvStore.$patch({ exercisesStates: updatedStates });
        }
    }

    /**
     * Get the current exercise
     */
    public getCurrentExercise(): Tables<"exercises"> {
        const { currentUnit } = this.tvStore;
        if (!currentUnit?.exercises?.length) return undefined;

        return currentUnit.exercises[this.currentExerciseIndex];
    }

    /**
     * Get the state of the current exercise
     */
    public getCurrentExerciseState(): ExerciseState | undefined {
        const currentExercise = this.getCurrentExercise();
        if (!currentExercise) return undefined;

        const { exercisesStates } = this.tvStore;
        return exercisesStates.find((state) =>
            state.unitID === currentExercise.id
        );
    }

    /**
     * Navigate to the current exercise
     */
    private navigateToCurrentExercise(): void {
        const currentExercise = this.getCurrentExercise();
        if (!currentExercise) return;

        const { patientid, unitid } = this.route.params;
        this.router.push(`/tv/${patientid}/${unitid}/${currentExercise.Id}`);
    }

    /**
     * Navigate back to unit list
     */
    private navigateToUnitList(): void {
        const { patientid } = this.route.params;
        this.router.push(`/tv/${patientid}`);
    }

    /**
     * Navigate to unit summary page
     */
    private navigateToUnitSummary(): void {
        const { patientid, unitid } = this.route.params;
        this.router.push(`/tv/${patientid}/${unitid}/summary`);
    }

    /**
     * Get all exercise states
     */
    public getAllExerciseStates(): ExercisesStates {
        return this.tvStore.exercisesStates;
    }

    /**
     * Check if we're on the first exercise
     */
    public isFirstExercise(): boolean {
        return this.currentExerciseIndex === 0;
    }

    /**
     * Check if we're on the last exercise
     */
    public isLastExercise(): boolean {
        const { currentUnit } = this.tvStore;
        if (!currentUnit?.exercises?.length) return true;

        return this.currentExerciseIndex ===
            currentUnit.exercises.length - 1;
    }

    /**
     * Get the progress as a percentage
     */
    public getProgressPercentage(): number {
        const { currentUnit } = this.tvStore;
        if (!currentUnit?.exercises?.length) return 0;

        const total = currentUnit.exercises.length;
        return Math.round(((this.currentExerciseIndex + 1) / total) * 100);
    }

    /**
     * Get a summary of completed exercises
     */
    public getSummary(): {
        total: number;
        completed: number;
        skipped: number;
        remaining: number;
    } {
        const { exercisesStates } = this.tvStore;

        const total = exercisesStates.length;
        const completed = exercisesStates.filter(
            (state) => state.completed_status === "completed",
        ).length;
        const skipped = exercisesStates.filter(
            (state) => state.completed_status === "skipped",
        ).length;

        return {
            total,
            completed,
            skipped,
            remaining: total - completed - skipped,
        };
    }
}

/**
 * Composable that returns the singleton instance of ExerciseStateMachine
 */
export function useExerciseStateMachine() {
    return ExerciseStateMachine.getInstance();
}
