import type { Tables } from "~/shared/types/database";

export const useExerciseCrud = () => {
    const supabase = useSupabaseClient();
    const updateExercisePosition = async (
        exerciseId: Tables<"exercises">["id"],
        targetPriorIndexExerciseID: Tables<"exercises">["id"] | null,
        sourceUnitId: Tables<"units">["id"],
        targetUnitId: Tables<"units">["id"],
    ) => {
        try {
            const { error } = await supabase.rpc("move_unit_exercise", {
                old_unit_id: sourceUnitId,
                new_unit_id: targetUnitId,
                moved_exercise_id: exerciseId,
                new_prev_exercise_id: targetPriorIndexExerciseID,
            });

            if (error) {
                throw new Error(
                    `Failed to update exercise position: ${error.message}`,
                );
            }
        } catch (err) {
            console.error(err);
            throw err; // Re-throw the error to handle it further up if needed
        }
    };

    return {
        updateExercisePosition,
    };
};
