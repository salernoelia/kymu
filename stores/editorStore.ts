import { defineStore } from "pinia";

export const useEditorStore = defineStore("editor", () => {
    const supabase = useSupabaseClient<Database>();
    const supabaseUser = useSupabaseUser();
    const localePath = useLocalePath();
    const router = useRouter();

    const units = ref<UnitsWithExercises[]>([]);
    const selectedExercise = ref<Tables<"exercises"> | null>(null);
    const selectedUnit = ref<UnitsWithExercises | null>(null);
    const selectedPatientId = ref<string | null>(null);
    const sidebarOpen = ref(false);
    const sidebarVariant = ref<"exercise" | "unit">("exercise");
    const sidebarMode = ref<"edit" | "create">("edit");
    const draggingExercise = ref<
        null | { id: string; unitId: string; position: number }
    >(null);
    const dragInProgress = ref(false);
    const exerciseTemplates = ref<ExerciseTemplate[]>([]);
    const unitTemplates = ref<UnitTemplate[]>([]);

    const sidebarTitle = computed(() => {
        const mode = sidebarMode.value === "create" ? "Create" : "Edit";
        if (sidebarVariant.value === "exercise") {
            return `${mode} Exercise`;
        }
        if (sidebarVariant.value === "unit") {
            return `${mode} Unit`;
        }
        return "Details";
    });

    function setSelectedPatientId(id: string | null) {
        selectedPatientId.value = id;
    }

    function getExercisesForUnit(unitId: string) {
        const unit = units.value.find((u) => u.id === unitId);
        if (!unit || !unit.exercises) return [];

        if (unit.exercises_index) {
            return [...unit.exercises].sort((a, b) => {
                const aIndex = unit.exercises_index?.indexOf(a.id) ?? -1;
                const bIndex = unit.exercises_index?.indexOf(b.id) ?? -1;
                return aIndex - bIndex;
            });
        }
        return unit.exercises;
    }

    function getExercisePosition(unit: UnitsWithExercises, exerciseId: string) {
        if (!unit.exercises_index) return 0;
        return unit.exercises_index.indexOf(exerciseId);
    }

    function selectExercise(
        exercise: Tables<"exercises">,
        mode: "edit" | "create" = "edit",
    ) {
        selectedExercise.value = exercise;
        sidebarVariant.value = "exercise";
        sidebarMode.value = mode;
        sidebarOpen.value = true;
    }

    function selectUnit(
        unit: UnitsWithExercises,
        mode: "edit" | "create" = "edit",
    ) {
        selectedUnit.value = unit;
        sidebarVariant.value = "unit";
        sidebarMode.value = mode;
        sidebarOpen.value = true;
    }

    function handleUnitUpdate(updatedUnit: UnitsWithExercises) {
        const index = units.value.findIndex((u) => u.id === updatedUnit.id);
        if (index !== -1) {
            units.value[index] = { ...updatedUnit };
        }
    }

    function closeSidebar() {
        sidebarOpen.value = false;
        sidebarMode.value = "edit";
    }

    function handleDragStart(
        data: { id: string; unitId: string; position: number },
    ) {
        draggingExercise.value = data;
        dragInProgress.value = true;
    }

    function handleDragEnd() {
        draggingExercise.value = null;
        dragInProgress.value = false;
    }

    async function loadTrainingUnit() {
        if (!selectedPatientId.value) {
            navigateTo(localePath(`/editor`));
            return;
        }

        try {
            const { data: unitsData, error: unitsError } = await supabase
                .from("units")
                .select(`
                id, 
                created_at, 
                name, 
                description, 
                patient_uid, 
                therapist_uid, 
                exercises_index,
                is_template
            `)
                .eq("patient_uid", selectedPatientId.value)
                .order("created_at", { ascending: true }); // Add this line to sort by creation date

            if (unitsError) {
                console.error(
                    "Error loading training units:",
                    unitsError,
                    selectedPatientId.value,
                );
                navigateTo(localePath(`/editor`));
                return;
            }

            if (!unitsData) {
                units.value = [];
                return;
            }

            const unitsWithExercises: UnitsWithExercises[] = unitsData.map(
                (unit) => ({
                    ...unit,
                    exercises: [],
                }),
            );

            for (const unit of unitsWithExercises) {
                if (unit.exercises_index && unit.exercises_index.length > 0) {
                    const { data: exercisesData, error: exercisesError } =
                        await supabase
                            .from("exercises")
                            .select("*")
                            .in("id", unit.exercises_index);

                    if (exercisesError) {
                        console.error(
                            `Error loading exercises for unit ${unit.id}:`,
                            exercisesError,
                        );
                    } else if (exercisesData) {
                        const sortedExercises = [...exercisesData].sort(
                            (a, b) => {
                                const aIndex =
                                    unit.exercises_index?.indexOf(a.id) ?? -1;
                                const bIndex =
                                    unit.exercises_index?.indexOf(b.id) ?? -1;
                                return aIndex - bIndex;
                            },
                        );
                        unit.exercises = sortedExercises;
                    }
                }
            }

            units.value = unitsWithExercises;
        } catch (error) {
            console.error("Error in loadTrainingUnit:", error);
            navigateTo(localePath(`/editor`));
        }
    }

    async function loadTemplates() {
        try {
            const { data: exerciseData, error: exerciseError } = await supabase
                .from("default_exercises")
                .select("*");

            if (exerciseError) {
                console.error(
                    "Error loading exercise templates:",
                    exerciseError,
                );
            } else if (exerciseData) {
                exerciseTemplates.value = exerciseData;
            }

            const { data: customExerciseData, error: customExerciseError } =
                await supabase
                    .from("exercises")
                    .select("*")
                    .eq("is_template", true)
                    .eq("therapist_uid", supabaseUser.value?.id || "");

            if (customExerciseError) {
                console.error(
                    "Error loading custom exercise templates:",
                    customExerciseError,
                );
            } else if (customExerciseData) {
                exerciseTemplates.value = [
                    ...exerciseTemplates.value,
                    ...customExerciseData,
                ];
            }

            const { data: unitData, error: unitError } = await supabase
                .from("default_units")
                .select("*");

            if (unitError) {
                console.error("Error loading unit templates:", unitError);
            } else if (unitData) {
                unitTemplates.value = unitData;
            }

            const { data: customUnitData, error: customUnitError } =
                await supabase
                    .from("units")
                    .select("*")
                    .eq("is_template", true)
                    .eq("therapist_uid", supabaseUser.value?.id || "");

            if (customUnitError) {
                console.error(
                    "Error loading custom unit templates:",
                    customUnitError,
                );
            } else if (customUnitData) {
                unitTemplates.value = [
                    ...unitTemplates.value,
                    ...customUnitData,
                ];
            }
        } catch (error) {
            console.error("Error loading templates:", error);
        }
    }

    async function initializeNewExercise(unitId: string) {
        // Check which fields actually exist in the database schema
        const newExercise = {
            name: "",
            focus_type: "strength",
            family_scene_adjustment_access: false,
            therapist_uid: supabaseUser.value?.id || "",
            // Replace training_unit_id with unit_id if that's what's in the schema
            unit_id: unitId,
            repetitions_goal: 10,
            duration_seconds_goal: 30,
            is_template: false,
        } as Tables<"exercises">;

        selectExercise(newExercise, "create");
    }

    async function initializeNewUnit() {
        const newUnit = {
            name: "",
            description: "",
            patient_uid: selectedPatientId.value || "",
            therapist_uid: supabaseUser.value?.id || "",
            exercises_index: [],
            is_template: false,
        } as UnitsWithExercises;

        selectUnit(newUnit, "create");
    }

    async function createExercise(unitId: string, fromTemplateId?: string) {
        try {
            let exerciseData: any = {
                name: "New Exercise",
                unit_id: unitId, // Changed from unit_id to training_unit_id
                therapist_uid: supabaseUser.value?.id || "",
                is_template: false,
                repetitions_goal: 10,
                duration_seconds_goal: 30,
                focus_type: "strength",
                family_scene_adjustment_access: false,
            };

            // If using a template, fetch and apply template data
            if (fromTemplateId) {
                const { data: templateData, error } = await supabase
                    .from("default_exercises")
                    .select("*")
                    .eq("id", fromTemplateId)
                    .single();

                if (error) {
                    console.error("Error loading exercise template:", error);
                } else if (templateData) {
                    // Preserve training_unit_id and other required fields while taking properties from template
                    exerciseData = {
                        ...templateData,
                        training_unit_id: unitId, // Changed from unit_id to training_unit_id
                        therapist_uid: supabaseUser.value?.id || "",
                        is_template: false,
                    };
                }
            }

            console.log(
                "Attempting to create exercise with data:",
                exerciseData,
            );

            // Insert the properly formatted exercise
            const { data, error } = await supabase
                .from("exercises")
                .insert([exerciseData])
                .select();

            if (error) {
                console.error("Error creating exercise:", error);
                return null;
            }

            if (data && data[0]) {
                const newExerciseId = data[0].id;

                // Update the unit's exercises_index
                const unit = units.value.find((u) => u.id === unitId);
                if (unit) {
                    const updatedExercisesIndex = [
                        ...(unit.exercises_index || []),
                        newExerciseId,
                    ];

                    const { error: updateError } = await supabase
                        .from("units")
                        .update({
                            exercises_index: updatedExercisesIndex,
                        })
                        .eq("id", unitId);

                    if (updateError) {
                        console.error(
                            "Error updating unit's exercises_index:",
                            updateError,
                        );
                    }
                }

                return data[0];
            }

            return null;
        } catch (error) {
            console.error("Error in createExercise:", error);
            return null;
        } finally {
            await loadTrainingUnit();
            closeSidebar();
        }
    }

    async function createUnit(
        unit: UnitsWithExercises,
        fromTemplateId?: string,
    ) {
        try {
            let unitData = { ...unit };

            if (fromTemplateId) {
                const { data: templateData, error } = await supabase
                    .from("default_units")
                    .select("*")
                    .eq("id", fromTemplateId)
                    .single();

                if (error) {
                    console.error("Error loading unit template:", error);
                    return;
                }

                if (templateData) {
                    const patientId = unitData.patient_uid;
                    unitData = {
                        ...templateData,
                        patient_uid: patientId,
                        therapist_uid: supabaseUser.value?.id || "",
                        is_template: false,
                    };
                }
            }

            const { data, error } = await supabase
                .from("units")
                .insert([unitData])
                .select();

            if (error) {
                console.error("Error creating unit:", error);
                return;
            }

            await loadTrainingUnit();
            closeSidebar();
        } catch (error) {
            console.error("Error in createUnit:", error);
        }
    }

    async function saveExercise(exercise: Tables<"exercises">) {
        try {
            const { error } = await supabase
                .from("exercises")
                .update({
                    name: exercise.name,
                    focus_type: exercise.focus_type,
                    duration_seconds_goal: exercise.duration_seconds_goal,
                    repetitions_goal: exercise.repetitions_goal,
                    family_scene_adjustment_access:
                        exercise.family_scene_adjustment_access,
                    is_template: exercise.is_template,
                })
                .eq("id", exercise.id);

            if (error) {
                console.error("Error updating exercise:", error);
                return;
            }

            await loadTrainingUnit();
        } catch (err) {
            console.error("Error in saveExercise:", err);
        } finally {
            closeSidebar();
        }
    }

    async function duplicateExercise(exerciseId: string) {
        try {
            const { data: exerciseData, error: fetchError } = await supabase
                .from("exercises")
                .select("*")
                .eq("id", exerciseId)
                .single();

            if (fetchError || !exerciseData) {
                console.error(
                    "Error fetching exercise to duplicate:",
                    fetchError,
                );
                return;
            }

            const { id, created_at, ...exerciseToCreate } = exerciseData;
            exerciseToCreate.name = `${exerciseToCreate.name} (Copy)`;

            const { data, error } = await supabase
                .from("exercises")
                .insert([exerciseToCreate])
                .select();

            if (error) {
                console.error("Error duplicating exercise:", error);
                return;
            }

            if (data && data[0]) {
                const newExerciseId = data[0].id;
                const unit = units.value.find((u) =>
                    u.id === exerciseToCreate.unit_id // Updated from training_unit_id
                );

                if (unit) {
                    const updatedExercisesIndex = [
                        ...(unit.exercises_index || []),
                        newExerciseId,
                    ];

                    await supabase
                        .from("units")
                        .update({
                            exercises_index: updatedExercisesIndex,
                        })
                        .eq("id", exerciseToCreate.unit_id); // Updated from training_unit_id
                }
            }

            await loadTrainingUnit();
        } catch (err) {
            console.error("Error in duplicateExercise:", err);
        }
    }

    async function deleteExercise(exerciseId: string) {
        if (!confirm("Are you sure you want to delete this exercise?")) {
            return;
        }

        const exercise = selectedExercise.value;
        if (!exercise) return;

        try {
            const { data: unitData } = await supabase
                .from("units")
                .select("id, exercises_index")
                .eq("id", exercise.unit_id) // Updated from training_unit_id
                .single();

            if (unitData) {
                const updatedExercisesIndex = [
                    ...(unitData.exercises_index || []),
                ];
                const indexToRemove = updatedExercisesIndex.indexOf(exerciseId);
                if (indexToRemove !== -1) {
                    updatedExercisesIndex.splice(indexToRemove, 1);

                    await supabase
                        .from("units")
                        .update({
                            exercises_index: updatedExercisesIndex,
                        })
                        .eq("id", unitData.id);
                }
            }

            const { error } = await supabase
                .from("exercises")
                .delete()
                .eq("id", exerciseId);

            if (error) {
                console.error("Error deleting exercise", error);
                return;
            }

            await loadTrainingUnit();
            sidebarOpen.value = false;
        } catch (err) {
            console.error("Error in deleteExercise:", err);
        }
    }

    async function saveUnit(unit: UnitsWithExercises) {
        try {
            const { error } = await supabase
                .from("units")
                .update({
                    name: unit.name,
                    description: unit.description,
                    is_template: unit.is_template,
                })
                .eq("id", unit.id);

            if (error) {
                console.error("Error updating unit:", error);
                return;
            }

            handleUnitUpdate(unit);
            await loadTrainingUnit();
        } catch (err) {
            console.error("Error in saveUnit:", err);
        } finally {
            closeSidebar();
        }
    }

    async function duplicateUnit(unitId: string) {
        try {
            // Get unit data without trying to join with exercises
            const { data: unitData, error: fetchError } = await supabase
                .from("units")
                .select("*")
                .eq("id", unitId)
                .single();

            if (fetchError || !unitData) {
                console.error("Error fetching unit to duplicate:", fetchError);
                return;
            }

            // Create a duplicate unit without the ID
            const { id, created_at, ...unitToCreate } = unitData;
            unitToCreate.name = `${unitToCreate.name} (Copy)`;
            unitToCreate.exercises_index = []; // Will be populated after exercise creation

            const { data: newUnitData, error } = await supabase
                .from("units")
                .insert([unitToCreate])
                .select();

            if (error || !newUnitData) {
                console.error("Error duplicating unit:", error);
                return;
            }

            const newUnit = newUnitData[0];
            const newExercisesIndex: string[] = [];

            // Separately fetch exercises for this unit
            if (
                unitData.exercises_index && unitData.exercises_index.length > 0
            ) {
                const { data: exercises, error: exercisesError } =
                    await supabase
                        .from("exercises")
                        .select("*")
                        .in("id", unitData.exercises_index);

                if (exercisesError) {
                    console.error(
                        "Error fetching exercises for duplication:",
                        exercisesError,
                    );
                    return;
                }

                // Duplicate all exercises for this unit
                if (exercises && exercises.length > 0) {
                    for (const exercise of exercises) {
                        const {
                            id: exId,
                            created_at: exCreatedAt,
                            ...exerciseToCreate
                        } = exercise;
                        exerciseToCreate.unit_id = newUnit.id; // Updated from training_unit_id

                        const { data: newExData } = await supabase
                            .from("exercises")
                            .insert([exerciseToCreate])
                            .select();

                        if (newExData && newExData[0]) {
                            newExercisesIndex.push(newExData[0].id);
                        }
                    }
                }
            }

            // Update the new unit with the exercise index
            await supabase
                .from("units")
                .update({
                    exercises_index: newExercisesIndex,
                })
                .eq("id", newUnit.id);

            await loadTrainingUnit();
        } catch (err) {
            console.error("Error in duplicateUnit:", err);
        }
    }

    async function deleteUnit(unitId: string) {
        if (
            !confirm(
                "Are you sure you want to delete this unit? This will also delete all exercises in this unit.",
            )
        ) {
            return;
        }

        try {
            const { error: exercisesError } = await supabase
                .from("exercises")
                .delete()
                .eq("unit_id", unitId); // Updated from training_unit_id

            if (exercisesError) {
                console.error("Error deleting exercises:", exercisesError);
                return;
            }

            const { error } = await supabase
                .from("units")
                .delete()
                .eq("id", unitId);

            if (error) {
                console.error("Error deleting unit:", error);
                return;
            }

            await loadTrainingUnit();
            sidebarOpen.value = false;
        } catch (err) {
            console.error("Error in deleteUnit:", err);
        }
    }

    async function handleExerciseDrop({
        exerciseId,
        sourceUnitId,
        targetUnitId,
        newPosition,
    }: {
        exerciseId: string;
        sourceUnitId: string;
        targetUnitId: string;
        newPosition: number;
    }) {
        const sourceUnit = units.value.find((u) => u.id === sourceUnitId);
        const targetUnit = units.value.find((u) => u.id === targetUnitId);

        if (!sourceUnit || !targetUnit) {
            console.error("Source or target unit not found");
            return;
        }

        try {
            const sourceExercisesIndex = [
                ...(sourceUnit.exercises_index || []),
            ];
            const exerciseIndex = sourceExercisesIndex.indexOf(exerciseId);
            if (exerciseIndex !== -1) {
                sourceExercisesIndex.splice(exerciseIndex, 1);
            }

            const targetExercisesIndex = [
                ...(targetUnit.exercises_index || []),
            ];
            targetExercisesIndex.splice(newPosition, 0, exerciseId);

            if (sourceUnitId !== targetUnitId) {
                await supabase
                    .from("units")
                    .update({
                        exercises_index: sourceExercisesIndex,
                    })
                    .eq("id", sourceUnitId);

                await supabase
                    .from("exercises")
                    .update({
                        unit_id: targetUnitId, // Updated from training_unit_id
                    })
                    .eq("id", exerciseId);
            }

            await supabase
                .from("units")
                .update({
                    exercises_index: targetExercisesIndex,
                })
                .eq("id", targetUnitId);

            await loadTrainingUnit();
        } catch (err) {
            console.error("Error saving position:", err);
            await loadTrainingUnit();
        } finally {
            dragInProgress.value = false;
        }
    }

    onMounted(() => {
        loadTemplates();
    });

    loadTemplates();

    return {
        units,
        selectedExercise,
        selectedUnit,
        selectedPatientId,
        sidebarOpen,
        sidebarVariant,
        sidebarMode,
        sidebarTitle,
        draggingExercise,
        dragInProgress,
        exerciseTemplates,
        unitTemplates,
        setSelectedPatientId,
        getExercisesForUnit,
        getExercisePosition,
        selectExercise,
        selectUnit,
        handleUnitUpdate,
        closeSidebar,
        handleDragStart,
        handleDragEnd,
        loadTrainingUnit,
        loadTemplates,
        initializeNewExercise,
        initializeNewUnit,
        createExercise,
        createUnit,
        saveExercise,
        duplicateExercise,
        deleteExercise,
        saveUnit,
        duplicateUnit,
        deleteUnit,
        handleExerciseDrop,
    };
});
