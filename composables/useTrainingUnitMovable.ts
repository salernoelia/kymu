export function useTrainingUnitMovable() {
    const updateExercisePosition = async (
        unit: TrainingUnit,
        exerciseId: number,
        targetBlockId: number,
        newPosition: number,
    ) => {
        const exercise = unit.training_block_exercises.find((ex) =>
            ex.id === exerciseId
        );
        if (!exercise) return;

        const oldBlockId = exercise.training_block_id;
        const oldPosition = exercise.order_position;

        if (oldBlockId === targetBlockId && oldPosition !== newPosition) {
            unit.training_block_exercises.forEach((ex) => {
                if (
                    ex.training_block_id === targetBlockId &&
                    ex.id !== exerciseId
                ) {
                    if (oldPosition < newPosition) {
                        if (
                            ex.order_position > oldPosition &&
                            ex.order_position <= newPosition
                        ) {
                            ex.order_position--;
                        }
                    } else {
                        if (
                            ex.order_position >= newPosition &&
                            ex.order_position < oldPosition
                        ) {
                            ex.order_position++;
                        }
                    }
                }
            });
        } else if (oldBlockId !== targetBlockId) {
            unit.training_block_exercises.forEach((ex) => {
                if (
                    ex.training_block_id === oldBlockId &&
                    ex.order_position > oldPosition
                ) {
                    ex.order_position--;
                }
            });

            unit.training_block_exercises.forEach((ex) => {
                if (
                    ex.training_block_id === targetBlockId &&
                    ex.order_position >= newPosition
                ) {
                    ex.order_position++;
                }
            });
        }

        exercise.training_block_id = targetBlockId;
        exercise.order_position = newPosition;

        return { exercise, oldBlockId, oldPosition };
    };

    return {
        updateExercisePosition,
    };
}
