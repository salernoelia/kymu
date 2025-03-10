export function useTrainingUnitMovable() {
    const updateExercisePosition = async (
        unit: TrainingUnit,
        exerciseId: number,
        targetBlockId: number,
        newPosition: number,
    ) => {
        const exerciseToMove = unit.training_block_exercises.find(
            (ex) => ex.id === exerciseId,
        );

        if (!exerciseToMove) return false;

        const sourceBlockId = exerciseToMove.training_block_id;
        const originalPosition = exerciseToMove.order_position;

        const updatedExercises = unit.training_block_exercises.filter(
            (ex) => ex.id !== exerciseId,
        );

        const sourceBlockExercises = updatedExercises.filter(
            (ex) => ex.training_block_id === sourceBlockId,
        );

        sourceBlockExercises.sort((a, b) =>
            a.order_position - b.order_position
        );
        sourceBlockExercises.forEach((ex, index) => {
            ex.order_position = index;
        });

        const targetBlockExercises = updatedExercises.filter(
            (ex) => ex.training_block_id === targetBlockId,
        );

        targetBlockExercises.sort((a, b) =>
            a.order_position - b.order_position
        );

        for (let i = 0; i < targetBlockExercises.length; i++) {
            if (i >= newPosition) {
                targetBlockExercises[i].order_position = i + 1;
            } else {
                targetBlockExercises[i].order_position = i;
            }
        }

        exerciseToMove.training_block_id = targetBlockId;
        exerciseToMove.order_position = Math.min(
            newPosition,
            targetBlockExercises.length,
        );

        return true;
    };

    return { updateExercisePosition };
}
