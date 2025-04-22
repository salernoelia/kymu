type Unit = Tables<"units">;
type UnitInsert = TablesInsert<"units">;
type UnitUpdate = TablesUpdate<"units">;

type TestWithRelations = Tables<"tests">;

type AssessmentWithTests = Tables<"assessments"> & {
    tests: TestWithRelations[];
};

type UnitWithDetails = Tables<"units"> & {
    id: Tables<"units">[id];
    start_assessment: AssessmentWithTests | null;
    end_assessment: AssessmentWithTests | null;
    exercises: Tables<"exercises">[];
};

type ExerciseStatus = "not_started" | "in_progress" | "skipped" | "completed";

type ExerciseResults = {
    achieved_repetitions?: number;
    achieved_seconds?: number;
    pain_angles_deg?: number[];
    dumbell?: {};
    rom?: {};
};

type ExerciseItem = Tables<"exercises"> & {
    unitId: Tables<"units">[id];
    created_at: Date;
    status: ExerciseStatus;
    results?: ExerciseResults;
};

type ExerciseCollection = ExerciseItem[];
