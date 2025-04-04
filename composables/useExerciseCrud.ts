import type { Tables } from "~/shared/types/database";

export const useExerciseCrud = () => {
    const supabase = useSupabaseClient();

    const updateExercisePosition = async (
        exerciseId: Tables<"exercises">["id"],
        sourcePriorIndexExerciseID: Tables<"exercises">["id"] | null,
        targetPriorIndexExerciseID: Tables<"exercises">["id"] | null,
        sourceUnitId: Tables<"units">["id"],
        targetUnitId: Tables<"units">["id"],
    ) => {
        if (!exerciseId || !targetUnitId) {
            console.error("Invalid parameters for updating exercise position");
            return;
        }

        const { data: currentExercisePosition, error: selectError } =
            await supabase
                .from("units_and_exercises")
                .select("*")
                .or(`exercise_id.eq.${exerciseId},prev_exercise_id.eq.${exerciseId}`);

        if (selectError) {
            console.error(
                "Error fetching current exercise position:",
                selectError,
            );
            return;
        }

        console.log(
            "Current exercise position data:",
            currentExercisePosition,
        );

        const {
            data: updateOldPositionReference,
            error: updateErrorReference,
        } = await supabase
            .from("units_and_exercises")
            .update({
                prev_exercise_id: sourcePriorIndexExerciseID || null,
            })
            .eq("prev_exercise_id", exerciseId || null)
            .eq("unit_id", sourceUnitId);

        if (updateErrorReference) {
            console.error(
                "Error updating old position reference:",
                updateErrorReference,
            );
            return;
        }

        const { data: squeezeIntoNewPosition, error: updateError } =
            await supabase
                .from("units_and_exercises")
                .update({
                    prev_exercise_id: exerciseId,
                })
                .eq("prev_exercise_id", targetPriorIndexExerciseID || null)
                .eq("unit_id", targetUnitId);

        if (updateError) {
            console.error(
                "Error updating new position reference:",
                updateError,
            );
            return;
        }

        // if (updateError) {
        //     console.error(
        //         "Error updating exercise position:",
        //         updateError,
        //     );
        //     return;
        // }
    };

    return {
        updateExercisePosition,
    };
};
