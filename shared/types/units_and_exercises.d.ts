type Unit = Tables<"units">;
type UnitInsert = TablesInsert<"units">;
type UnitUpdate = TablesUpdate<"units">;

type TestWithRelations = Tables<"tests">;

type AssessmentWithTests = Tables<"assessments"> & {
    tests: TestWithRelations[];
};

type ExerciseWithCategory = Tables<"exercises"> & {
    category_info: Tables<"exercise_categories"> | null;
};

type UnitWithDetails = Tables<"units"> & {
    id: Tables<"units">[id];
    start_assessment: AssessmentWithTests | null;
    end_assessment: AssessmentWithTests | null;
    exercises: ExerciseWithCategory[];
};

type ExerciseStatus = "not_started" | "in_progress" | "skipped" | "completed";

type ExerciseResults = {
    achieved_repetitions?: number;
    achieved_seconds?: number;
    pain_angles_deg?: number[];
    dumbell?: {};
    rom?: {};
};

type ExerciseItem = ExerciseWithCategory & {
    unitId: Tables<"units">[id];
    created_at: Date;
    status: ExerciseStatus;
    results?: ExerciseResults;
};

type ExerciseCollection = ExerciseItem[];
