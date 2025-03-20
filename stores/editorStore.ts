import { useToast } from "~/components/ui/toast/use-toast";

export const useEditorStore = defineStore("editor", () => {
    const supabase = useSupabaseClient<Database>();
    const supabaseUser = useSupabaseUser();
    const localePath = useLocalePath();
    const router = useRouter();
    const { toast } = useToast();

    const units = ref<UnitsWithExercises[]>([]);
    const selectedExercise = ref<Tables<"exercises"> | null>(null);
    const selectedUnit = ref<UnitsWithExercises | null>(null);
    const selectedPatientId = ref<string | null>(null);
    const sidebarOpen = ref(false);
    const sidebarVariant = ref<"exercise" | "unit" | "template-selector">(
        "exercise",
    );
    const sidebarMode = ref<"edit" | "create">("edit");
    const sidebarTitle = ref("Details");
    const draggingExercise = ref<
        null | { id: string; unitId: string; position: number }
    >(null);
    const dragInProgress = ref(false);
    const exerciseTemplates = ref<ExerciseTemplate[]>([]);
    const unitTemplates = ref<UnitTemplate[]>([]);
    const targetUnitId = ref<string | null>(null);

    watch([sidebarVariant, sidebarMode], () => {
        const mode = sidebarMode.value === "create" ? "Create" : "Edit";
        if (sidebarVariant.value === "exercise") {
            sidebarTitle.value = `${mode} Exercise`;
        } else if (sidebarVariant.value === "unit") {
            sidebarTitle.value = `${mode} Unit`;
        } else if (sidebarVariant.value === "template-selector") {
            sidebarTitle.value = "Select Template";
        } else {
            sidebarTitle.value = "Details";
        }
    });

    function setSelectedPatientId(id: string | null) {
        selectedPatientId.value = id;
    }

    function getExercisesForUnit(unitId: string): Tables<"exercises">[] {
        const unit = units.value.find((u) =>
            u.id.toString() === unitId.toString()
        );
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
            navigateTo(localePath(`/patient/editor`));
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
                is_template,
                inherited_default_unit
            `)
                .eq("patient_uid", selectedPatientId.value)
                .order("created_at", { ascending: true });

            if (unitsError) {
                console.error(
                    "Error loading training units:",
                    unitsError,
                    selectedPatientId.value,
                );
                navigateTo(localePath(`/patient/editor`));
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
            navigateTo(localePath(`/patient/editor`));
        }
    }

    async function loadTemplates() {
        try {
            exerciseTemplates.value = [];
            unitTemplates.value = [];

            const { data: exerciseData, error: exerciseError } = await supabase
                .from("default_exercises")
                .select("*");

            if (exerciseError) {
                console.error(
                    "Error loading default exercise templates:",
                    exerciseError,
                );
            } else if (exerciseData) {
                exerciseTemplates.value = exerciseData.map((item) => ({
                    ...item,
                }));
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
            } else if (customExerciseData && customExerciseData.length > 0) {
                exerciseTemplates.value = [
                    ...exerciseTemplates.value,
                    ...customExerciseData.map((item) => ({
                        ...item,
                        default_exercise_instructions: [],
                        default_scene_id: 1,
                        description: "",
                        thumbnail_url: "",
                        name: item.name || "", // Provide a default value for name
                    })),
                ];
            }

            const { data: unitData, error: unitError } = await supabase
                .from("default_units")
                .select("*");

            if (unitError) {
                console.error(
                    "Error loading default unit templates:",
                    unitError,
                );
            } else if (unitData) {
                unitTemplates.value = unitData.map((item) => ({
                    ...item,
                    exercises_index: item.exercises_index || [],
                }));
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
            } else if (customUnitData && customUnitData.length > 0) {
                unitTemplates.value = [
                    ...unitTemplates.value,
                    ...customUnitData.map((item) => ({
                        ...item,
                        exercises_index: item.exercises_index || [],
                        id: String(item.id),
                    })),
                ];
            }
        } catch (error) {
            console.error("Error loading templates:", error);
        }
    }

    async function getExerciseById(
        exerciseId: string,
    ): Promise<Tables<"exercises"> | null> {
        const { data, error } = await supabase
            .from("exercises")
            .select("*")
            .eq("id", exerciseId)
            .single();

        if (error) {
            console.error("Error fetching exercise:", error);
            return null;
        }

        return data;
    }

    async function initializeNewExercise(unitId: string) {
        targetUnitId.value = unitId;
        const newExercise: TablesInsert<"exercises"> = {
            name: "",
            focus_type: "strength",
            family_scene_adjustment_access: false,
            therapist_uid: supabaseUser.value?.id || "",
            repetitions_goal: 10,
            duration_seconds_goal: 30,
            is_template: false,
        };

        const unit = units.value.find((u) =>
            u.id.toString() === unitId.toString()
        );
        if (unit) {
            // newExercise.inherited_default_exercise = unit.inherited_default_exercise || null;
        }

        selectExercise(
            {
                ...newExercise,
                id: "new", // temporary id
                created_at: new Date().toISOString(),
                focus_type: newExercise.focus_type || "strength",
            } as any,
            "create",
        );
    }

    async function initializeNewUnit() {
        const newUnit: TablesInsert<"units"> = {
            name: "",
            description: null,
            patient_uid: selectedPatientId.value || "",
            therapist_uid: supabaseUser.value?.id || "",
            exercises_index: [],
            is_template: false,
        };

        selectUnit(
            {
                ...newUnit,
                id: "new",
                created_at: new Date().toISOString(),
                inherited_default_unit: null,
            } as any,
            "create",
        );
    }

    async function createExercise(unitId: string, fromTemplateId?: string) {
        try {
            let exerciseData: TablesInsert<"exercises"> = {
                name: "New Exercise",
                therapist_uid: supabaseUser.value?.id || "",
                is_template: false,
                repetitions_goal: 10,
                duration_seconds_goal: 30,
                focus_type: "strength",
                family_scene_adjustment_access: false,
            };

            if (fromTemplateId) {
                const { data: templateData, error } = await supabase
                    .from("default_exercises")
                    .select("*")
                    .eq("id", fromTemplateId)
                    .single();

                if (error) {
                    console.error("Error loading exercise template:", error);
                } else if (templateData && templateData.focus_type) {
                    exerciseData = {
                        name: templateData.name,
                        focus_type: templateData.focus_type,
                        therapist_uid: supabaseUser.value?.id || "",
                        repetitions_goal: templateData.repetitions_goal,
                        duration_seconds_goal:
                            templateData.duration_seconds_goal,
                        is_template: false,
                        inherited_default_exercise: templateData.id,
                    };
                }
            }

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

                const unit = units.value.find((u) =>
                    u.id.toString() === unitId.toString()
                );
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
                        .eq("id", unit.id);

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
            let unitData: TablesInsert<"units"> = {
                name: unit.name,
                description: unit.description,
                patient_uid: selectedPatientId.value || "",
                therapist_uid: supabaseUser.value?.id || "",
                exercises_index: [],
                is_template: false,
            };

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
                    unitData = {
                        name: templateData.name,
                        description: templateData.description,
                        patient_uid: selectedPatientId.value || "",
                        therapist_uid: supabaseUser.value?.id || "",
                        exercises_index: templateData.exercises_index,
                        is_template: false,
                        inherited_default_unit: templateData.id,
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

    async function saveExercise(
        exercise: Tables<"exercises">,
    ) {
        try {
            if (exercise.id === "new") {
                const exerciseToCreate: TablesInsert<"exercises"> = {
                    name: exercise.name,
                    focus_type: exercise.focus_type,
                    duration_seconds_goal: exercise.duration_seconds_goal,
                    repetitions_goal: exercise.repetitions_goal,
                    family_scene_adjustment_access:
                        exercise.family_scene_adjustment_access,
                    is_template: exercise.is_template,
                    therapist_uid: supabaseUser.value?.id || "",
                };

                const { data, error } = await supabase
                    .from("exercises")
                    .insert([exerciseToCreate])
                    .select();

                if (error) {
                    console.error("Error creating new exercise:", error);
                    toast({
                        title: "Error",
                        description:
                            "Failed to create exercise. Please try again.",
                        variant: "destructive",
                    });
                    return;
                }

                if (data && data[0]) {
                    let unitId = targetUnitId.value ||
                        selectedUnit.value?.id?.toString();
                    let unit;
                    if (unitId) {
                        unit = units.value.find((u) =>
                            u.id.toString() === unitId
                        );
                    }

                    if (!unit && units.value.length > 0 && units.value[0]) {
                        unitId = units.value[0].id.toString();
                        unit = units.value[0];
                    }

                    if (unitId && unit) {
                        console.log("unit", unit.exercises_index);
                        const updatedExercisesIndex = [
                            ...(unit.exercises_index || []),
                            data[0].id,
                        ];

                        const {
                            data: updatedExercisesIndexData,
                            error: updateError,
                        } = await supabase
                            .from("units")
                            .update({
                                exercises_index: updatedExercisesIndex,
                            })
                            .eq("id", unit.id);

                        if (updateError) {
                            console.error(
                                "Error updating unit's exercises_index:",
                                updateError,
                            );
                            toast({
                                title: "Warning",
                                description:
                                    "Exercise created but not added to unit. Please reload.",
                                variant: "destructive",
                            });
                        }
                        toast({
                            title: "Exercise created",
                            description:
                                "The exercise has been created successfully.",
                            variant: "default",
                        });
                    } else {
                        console.error("No unit found to add exercise to");
                        toast({
                            title: "Warning",
                            description:
                                "Exercise created but no unit found to add it to.",
                            variant: "destructive",
                        });
                    }
                }
            } else {
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
                    toast({
                        title: "Error",
                        description:
                            "Failed to update exercise. Please try again.",
                        variant: "destructive",
                    });
                    return;
                }
            }

            await loadTrainingUnit();
            toast({
                title: "Exercise saved",
                description: "The exercise has been saved successfully.",
                variant: "default",
            });
        } catch (err) {
            console.error("Error in saveExercise:", err);
            toast({
                title: "Error",
                description: "An unexpected error occurred. Please try again.",
                variant: "destructive",
            });
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
            exerciseToCreate.name = `${
                exerciseToCreate.name || "Exercise"
            } (Copy)`;

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

                const currentUnit = units.value.find((u) =>
                    u.exercises_index?.includes(exerciseId)
                );

                if (currentUnit) {
                    const updatedExercisesIndex = [
                        ...(currentUnit.exercises_index || []),
                        newExerciseId,
                    ];

                    await supabase
                        .from("units")
                        .update({
                            exercises_index: updatedExercisesIndex,
                        })
                        .eq("id", currentUnit.id);
                }

                await loadTrainingUnit();

                toast({
                    title: "Exercise duplicated",
                    description:
                        "The exercise has been duplicated successfully.",
                    variant: "default",
                });
            }
        } catch (err) {
            console.error("Error in duplicateExercise:", err);
            toast({
                title: "Error",
                description: "Failed to duplicate exercise. Please try again.",
                variant: "destructive",
            });
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
                .eq("id", exercise.therapist_uid)
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
            console.log("unit", unit);

            if (unit.id === "new") {
                const unitToCreate: TablesInsert<"units"> = {
                    name: unit.name,
                    description: unit.description,
                    patient_uid: selectedPatientId.value || "",
                    therapist_uid: supabaseUser.value?.id || "",
                    exercises_index: [],
                    is_template: unit.is_template || false,
                };

                const { data, error } = await supabase
                    .from("units")
                    .insert([unitToCreate])
                    .select();

                if (error) {
                    console.error("Error creating unit:", error);
                    toast({
                        title: "Error",
                        description: "Failed to create unit. Please try again.",
                        variant: "destructive",
                    });
                    return;
                }

                if (data && data[0]) {
                    toast({
                        title: "Unit created",
                        description: "The unit has been created successfully.",
                        variant: "default",
                    });
                }
            } else {
                // This is an existing unit - update it
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
                    toast({
                        title: "Error",
                        description: "Failed to update unit. Please try again.",
                        variant: "destructive",
                    });
                    return;
                }

                handleUnitUpdate(unit);
                toast({
                    title: "Unit updated",
                    description: "The unit has been updated successfully.",
                    variant: "default",
                });
            }

            await loadTrainingUnit();
        } catch (err) {
            console.error("Error in saveUnit:", err);
            toast({
                title: "Error",
                description: "An unexpected error occurred. Please try again.",
                variant: "destructive",
            });
        } finally {
            closeSidebar();
        }
    }

    async function duplicateUnit(unitId: string) {
        try {
            const { data: unitData, error: fetchError } = await supabase
                .from("units")
                .select("*")
                .eq("id", unitId)
                .single();

            if (fetchError || !unitData) {
                console.error("Error fetching unit to duplicate:", fetchError);
                return;
            }

            const { id, created_at, ...unitToCreate } = unitData;
            unitToCreate.name = `${unitToCreate.name} (Copy)`;
            unitToCreate.exercises_index = [];

            const { data: newUnitData, error } = await supabase
                .from("units")
                .insert([unitToCreate])
                .select();

            if (error || !newUnitData) {
                console.error("Error duplicating unit:", error);
                return;
            }

            if (newUnitData && newUnitData[0]) {
                const newUnit = newUnitData[0];
                const newExercisesIndex: string[] = [];

                if (
                    unitData.exercises_index &&
                    unitData.exercises_index.length > 0
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

                    if (exercises && exercises.length > 0) {
                        for (const exercise of exercises) {
                            const {
                                id: exId,
                                created_at: exCreatedAt,
                                ...exerciseToCreate
                            } = exercise;

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

                await supabase
                    .from("units")
                    .update({
                        exercises_index: newExercisesIndex,
                    })
                    .eq("id", newUnit.id);

                await loadTrainingUnit();
            }
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
        const sourceUnit = units.value.find((u) =>
            u.id.toString() === sourceUnitId.toString()
        );
        const targetUnit = units.value.find((u) =>
            u.id.toString() === targetUnitId.toString()
        );

        if (!sourceUnit || !targetUnit) {
            console.error("Source or target unit not found");
            return;
        }

        try {
            const sourceExercisesIndex = [
                ...new Set(sourceUnit.exercises_index || []),
            ];
            const targetExercisesIndex = [
                ...new Set(targetUnit.exercises_index || []),
            ];

            const isSameUnit = sourceUnitId === targetUnitId;
            const sourceIndex = sourceExercisesIndex.indexOf(exerciseId);

            if (sourceIndex === -1) {
                console.warn(
                    `Exercise ID ${exerciseId} not found in source unit's exercises_index`,
                );
            }

            console.log("sourceIndex", sourceIndex);
            console.log("newPosition", newPosition);

            if (isSameUnit) {
                const adjustedPosition = newPosition > sourceIndex
                    ? newPosition - 1
                    : newPosition;
                const workingArray = [...targetExercisesIndex];

                console.log("adjustedPosition", adjustedPosition);

                workingArray.splice(sourceIndex, 1);
                workingArray.splice(adjustedPosition, 0, exerciseId);

                await supabase
                    .from("units")
                    .update({
                        exercises_index: workingArray,
                    })
                    .eq("id", targetUnitId);
            } else {
                let sourceContainedExercise = false;
                for (let i = sourceExercisesIndex.length - 1; i >= 0; i--) {
                    if (sourceExercisesIndex[i] === exerciseId) {
                        sourceExercisesIndex.splice(i, 1);
                        sourceContainedExercise = true;
                    }
                }

                for (let i = targetExercisesIndex.length - 1; i >= 0; i--) {
                    if (targetExercisesIndex[i] === exerciseId) {
                        targetExercisesIndex.splice(i, 1);
                    }
                }

                const safeNewPosition = Math.min(
                    Math.max(0, newPosition),
                    targetExercisesIndex.length,
                );
                console.log("safeNewPosition", safeNewPosition);

                targetExercisesIndex.splice(safeNewPosition, 0, exerciseId);

                console.log("sourceExercisesIndex", sourceExercisesIndex);
                console.log("targetExercisesIndex", targetExercisesIndex);

                await supabase
                    .from("units")
                    .update({
                        exercises_index: sourceExercisesIndex,
                    })
                    .eq("id", sourceUnitId);

                await supabase
                    .from("units")
                    .update({
                        exercises_index: targetExercisesIndex,
                    })
                    .eq("id", targetUnitId);
            }

            await loadTrainingUnit();
        } catch (err) {
            console.error("Error saving position:", err);
            toast({
                title: "Error",
                description:
                    "Failed to update exercise position. Please try again.",
                variant: "destructive",
            });

            await loadTrainingUnit();
        } finally {
            dragInProgress.value = false;
        }
    }

    async function initializeNewUnitFromTemplate(templateId: string) {
        try {
            let templateData: Tables<"default_units"> | Tables<"units"> | null =
                null;

            let { data: defaultTemplateData, error: defaultError } =
                await supabase
                    .from("default_units")
                    .select("*")
                    .eq("id", templateId)
                    .single();

            if (defaultError || !defaultTemplateData) {
                let { data: customTemplateData, error: customError } =
                    await supabase
                        .from("units")
                        .select("*")
                        .eq("id", templateId)
                        .single();

                if (customError || !customTemplateData) {
                    console.error(
                        "Template not found:",
                        defaultError || customError,
                    );
                    return;
                }

                templateData = customTemplateData;
            } else {
                templateData = defaultTemplateData;
            }

            if (!templateData) {
                console.error("Template data is null");
                return;
            }

            const newUnit: TablesInsert<"units"> = {
                name: templateData.name || "New Unit",
                description: templateData.description || null,
                patient_uid: selectedPatientId.value || "",
                therapist_uid: supabaseUser.value?.id || "",
                exercises_index: [],
                is_template: false,
            };

            const { data, error: insertError } = await supabase
                .from("units")
                .insert([newUnit])
                .select();

            if (insertError) {
                console.error(
                    "Error creating unit from template:",
                    insertError,
                );
                return;
            }

            if (data && data[0]) {
                if (
                    (templateData as Tables<"default_units">).exercises_index &&
                    (templateData as Tables<"default_units">).exercises_index!
                            .length > 0
                ) {
                    await copyExercisesFromTemplate(templateData, data[0]);
                }

                await loadTrainingUnit();

                const createdUnit = units.value.find((u) => {
                    if (!data[0]) {
                        return false;
                    }
                    return u.id.toString() === data[0].id.toString();
                });
                if (createdUnit) {
                    selectUnit(createdUnit);
                }
            }
        } catch (error) {
            console.error("Error initializing unit from template:", error);
        }
    }

    async function copyExercisesFromTemplate(templateUnit: any, newUnit: any) {
        try {
            if (
                !templateUnit.exercises_index ||
                !templateUnit.exercises_index.length
            ) {
                return;
            }

            const { data: templateExercises, error: exerciseError } =
                await supabase
                    .from("exercises")
                    .select("*")
                    .in("id", templateUnit.exercises_index);

            if (exerciseError || !templateExercises) {
                console.error(
                    "Error fetching template exercises:",
                    exerciseError,
                );
                return;
            }

            const newExercisesIndex: string[] = [];

            for (const exercise of templateExercises) {
                const newExerciseData: TablesInsert<"exercises"> = {
                    name: exercise.name,
                    focus_type: exercise.focus_type || "strength",
                    family_scene_adjustment_access:
                        exercise.family_scene_adjustment_access || false,
                    therapist_uid: supabaseUser.value?.id || "",
                    repetitions_goal: exercise.repetitions_goal || 10,
                    duration_seconds_goal: exercise.duration_seconds_goal || 30,
                    is_template: false,
                };

                const { data, error } = await supabase
                    .from("exercises")
                    .insert([newExerciseData])
                    .select();

                if (error) {
                    console.error(
                        "Error creating exercise from template:",
                        error,
                    );
                } else if (data && data[0]) {
                    newExercisesIndex.push(data[0].id);
                }
            }

            if (newExercisesIndex.length > 0) {
                const { error } = await supabase
                    .from("units")
                    .update({
                        exercises_index: newExercisesIndex,
                    })
                    .eq("id", newUnit.id);

                if (error) {
                    console.error(
                        "Error updating new unit's exercises_index:",
                        error,
                    );
                }
            }
        } catch (error) {
            console.error("Error copying exercises from template:", error);
        }
    }

    async function createExerciseFromTemplate(
        unitId: string,
        templateId: string,
    ) {
        try {
            let templateData:
                | Tables<"default_exercises">
                | Tables<"exercises">
                | null = null;

            let { data: defaultTemplateData, error: defaultError } =
                await supabase
                    .from("default_exercises")
                    .select("*")
                    .eq("id", templateId)
                    .single();

            if (defaultError || !defaultTemplateData) {
                let { data: customTemplateData, error: customError } =
                    await supabase
                        .from("exercises")
                        .select("*")
                        .eq("id", templateId)
                        .single();

                if (customError || !customTemplateData) {
                    console.error(
                        "Template not found:",
                        defaultError || customError,
                    );
                    return;
                }

                templateData = customTemplateData;
            } else {
                templateData = defaultTemplateData;
            }

            if (!templateData) {
                console.error("Template data is null");
                return;
            }

            const newExerciseData: TablesInsert<"exercises"> = {
                name: templateData.name || "New Exercise",
                focus_type: templateData.focus_type || "strength",
                therapist_uid: supabaseUser.value?.id || "",
                repetitions_goal: templateData.repetitions_goal || 10,
                duration_seconds_goal: templateData.duration_seconds_goal || 30,
                is_template: false,
            };

            const { data, error: createError } = await supabase
                .from("exercises")
                .insert([newExerciseData])
                .select();

            if (createError) {
                console.error(
                    "Error creating exercise from template:",
                    createError,
                );
                return;
            }

            if (data && data[0]) {
                const newExerciseId = data[0].id;

                const unit = units.value.find((u) =>
                    u.id.toString() === unitId.toString()
                );
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

                await loadTrainingUnit();
                selectExercise(data[0]);
            }
        } catch (error) {
            console.error("Error creating exercise from template:", error);
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
        getExerciseById,
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
        initializeNewUnitFromTemplate,
        createExerciseFromTemplate,
    };
});
