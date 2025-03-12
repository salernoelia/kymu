interface Slide {
  title: string;
  description: string;
}

interface DraggingExercise {
  id: string;
  unitId: string;
  position: number;
}

interface ExerciseTemplate extends Tables<"default_exercises"> {}

interface UnitTemplate extends Tables<"default_units"> {}

interface UnitsWithExercises extends Tables<"units"> {
  exercises: Tables<"exercises">[];
}
