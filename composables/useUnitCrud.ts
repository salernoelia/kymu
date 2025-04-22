export const useUnitCrud = () => {
    const supabase = useSupabaseClient<Database>();
    const route = useRoute();
    const patientId = computed(() => route.params.patientid as string);

    /**
     * Get all units for a specific patient
     */
    const get = async (): Promise<Unit[]> => {
        const { data, error } = await supabase
            .from("units")
            .select("*")
            .eq("patient_uid", patientId.value)
            .order("created_at", { ascending: false });

        if (error) throw error;
        return data || [];
    };

    /**
     * Get all units for a specific patient with their assessments and exercises
     */
    const getWithDetails = async (
        isFocus?: boolean,
    ): Promise<UnitWithDetails[]> => {
        let query = supabase
            .from("units")
            .select(`
            *,
            start_assessment:start_assessment_id(*),
            end_assessment:end_assessment_id(*),
            exercises:units_and_exercises(
                prev_exercise_id,
                exercise:exercise_id(
                    *,
                    exercise_categories:category(*)
                )
            )
        `)
            .eq("patient_uid", patientId.value);

        if (isFocus === true) {
            query = query.eq("isFocus", true);
        }

        const { data: units, error: unitsError } = await query
            .order("created_at", { ascending: true });
        console.log(units);

        if (unitsError) throw unitsError;
        if (!units || units.length === 0) return [];

        const assessmentIds = units
            .flatMap(
                (unit) => [unit.start_assessment_id, unit.end_assessment_id],
            )
            .filter((id) => id !== null) as string[];

        const { data: testsWithOrder, error: testsError } = await supabase
            .from("assessments_and_tests")
            .select("assessment_id, prev_test_id, tests!test_id(*)")
            .in("assessment_id", assessmentIds);

        if (testsError) throw testsError;

        const testsByAssessment: Record<string, TestWithRelations[]> = {};

        assessmentIds.forEach((assessmentId) => {
            const assessmentTests = testsWithOrder?.filter((t) =>
                t.assessment_id === assessmentId
            ) || [];

            const orderedTests: TestWithRelations[] = [];

            const firstTest = assessmentTests.find((t) =>
                t.prev_test_id === null
            );
            if (firstTest) {
                orderedTests.push(firstTest.tests);
            }

            let currentTestId = firstTest?.tests.id;
            while (
                currentTestId && orderedTests.length < assessmentTests.length
            ) {
                const nextTest = assessmentTests.find((t) =>
                    t.prev_test_id === currentTestId
                );
                if (!nextTest) {
                    break;
                }

                orderedTests.push(nextTest.tests);
                currentTestId = nextTest.tests.id;
            }

            testsByAssessment[assessmentId] = orderedTests;
        });

        return units.map((unit) => {
            const orderedExercises: Tables<"exercises">[] = [];
            const exerciseItems = unit.exercises || [];

            const firstExercise = exerciseItems.find((e: any) =>
                e.prev_exercise_id === null
            );
            if (firstExercise) orderedExercises.push(firstExercise.exercise);

            // Add remaining exercises in order
            let currentExerciseId = firstExercise?.exercise.id;
            while (
                currentExerciseId &&
                orderedExercises.length < exerciseItems.length
            ) {
                const nextExercise = exerciseItems.find((e: any) =>
                    e.prev_exercise_id === currentExerciseId
                );
                if (!nextExercise) break;

                orderedExercises.push(nextExercise.exercise);
                currentExerciseId = nextExercise.exercise.id;
            }

            return {
                ...unit,
                start_assessment: unit.start_assessment_id
                    ? {
                        ...unit.start_assessment,
                        tests: testsByAssessment[unit.start_assessment_id] ||
                            [],
                    }
                    : null,
                end_assessment: unit.end_assessment_id
                    ? {
                        ...unit.end_assessment,
                        tests: testsByAssessment[unit.end_assessment_id] || [],
                    }
                    : null,
                exercises: orderedExercises,
            };
        });
    };

    /**
     * Get a specific unit by ID
     */
    const getById = async (id: string): Promise<Unit | null> => {
        const { data, error } = await supabase
            .from("units")
            .select("*")
            .eq("id", id)
            .single();

        if (error) throw error;
        return data;
    };

    /**
     * Create a new unit
     */
    const create = async (unit: UnitInsert): Promise<Unit> => {
        const { data, error } = await supabase
            .from("units")
            .insert(unit)
            .select()
            .single();

        if (error) throw error;
        return data;
    };

    /**
     * Update an existing unit
     */
    const update = async (
        id: string,
        updates: UnitUpdate,
    ): Promise<Unit> => {
        const { data, error } = await supabase
            .from("units")
            .update(updates)
            .eq("id", id)
            .select()
            .single();

        if (error) throw error;
        return data;
    };

    /**
     * Delete a unit by ID
     */
    const deleteUnit = async (id: string): Promise<void> => {
        const { error } = await supabase
            .from("units")
            .delete()
            .eq("id", id);

        if (error) throw error;
    };

    /**
     * Toggle unit focus state
     */
    const toggleUnitFocus = async (
        id: string,
        isFocus: boolean,
    ): Promise<Unit> => {
        const { data, error } = await supabase
            .from("units")
            .update({ isFocus })
            .eq("id", id)
            .select()
            .single();

        if (error) throw error;
        return data;
    };

    return {
        get,
        getWithDetails,
        getById,
        create,
        update,
        deleteUnit,
        toggleUnitFocus,
    };
};
