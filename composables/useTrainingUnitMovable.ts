interface UnitWithExercises extends Tables<"units"> {
    exercises: Tables<"exercises">[];
}

export function useTrainingUnitMovable() {
    const updateExercisePosition = async (
        unit: UnitWithExercises,
        exerciseId: number,
        newPosition: number,
    ) => {
        if (!unit.exercises_index) {
            unit.exercises_index = [];
        }

        // Find the current position of the exercise in the index
        const currentPosition = unit.exercises_index.indexOf(exerciseId);

        // If not found, add it
        if (currentPosition === -1) {
            unit.exercises_index.push(exerciseId);
            return true;
        }

        // If the position is the same, do nothing
        if (currentPosition === newPosition) {
            return false;
        }

        // Remove from current position
        unit.exercises_index.splice(currentPosition, 1);

        // Insert at new position
        unit.exercises_index.splice(newPosition, 0, exerciseId);

        return true;
    };

    return { updateExercisePosition };
}
