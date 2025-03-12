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

        const currentPosition = unit.exercises_index.indexOf(exerciseId);

        if (currentPosition === -1) {
            unit.exercises_index.push(exerciseId);
            return true;
        }

        if (currentPosition === newPosition) {
            return false;
        }

        unit.exercises_index.splice(currentPosition, 1);

        unit.exercises_index.splice(newPosition, 0, exerciseId);

        return true;
    };

    return { updateExercisePosition };
}
