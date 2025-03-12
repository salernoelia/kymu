import type { Tables } from "~/shared/types/database.types";

export interface DraggingExercise {
    id: string;
    unitId: string;
    position: number;
}

export interface ExerciseTemplate extends Tables<"default_exercises"> {}

export interface UnitTemplate extends Tables<"default_units"> {}

export interface UnitsWithExercises extends Tables<"units"> {
    exercises: Tables<"exercises">[];
}
