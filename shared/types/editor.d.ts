interface Slide {
  title: string;
  description: string;
}

interface DraggingExercise {
  id: number;
  unitId: number;
}

interface UnitsWithExercises extends Tables<"units"> {
  exercises: Tables<"exercises">[];
}
