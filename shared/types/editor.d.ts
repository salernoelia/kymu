type Unit = Tables<"units">;
type UnitInsert = TablesInsert<"units">;
type UnitUpdate = TablesUpdate<"units">;

type TestWithRelations = Tables<"tests">;

type AssessmentWithTests = Tables<"assessments"> & {
    tests: TestWithRelations[];
};

type UnitWithDetails = Tables<"units"> & {
    start_assessment: AssessmentWithTests | null;
    end_assessment: AssessmentWithTests | null;
    exercises: Tables<"exercises">[];
};
