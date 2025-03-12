import { defineStore } from "pinia";
import type { Database, Tables } from "~/shared/types/database.types";

interface UnitsWithExercises extends Tables<"units"> {
    exercises: Tables<"exercises">[];
}

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
    const draggingExercise = ref<
        null | { id: number; unitId: number; position: number }
    >(null);
    const dragInProgress = ref(false);

    const sidebarTitle = computed(() => {
        if (sidebarVariant.value === "exercise") {
            return "Exercise Details";
        }
        if (sidebarVariant.value === "unit") {
            return "Unit Details";
        }
        return "Details";
    });

    function setSelectedPatientId(id: string | null) {
        selectedPatientId.value = id;
    }

    function getExercisesForUnit(unitId: number) {
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

    function getExercisePosition(unit: UnitsWithExercises, exerciseId: number) {
        if (!unit.exercises_index) return 0;
        return unit.exercises_index.indexOf(exerciseId);
    }

    function selectExercise(exercise: Tables<"exercises">) {
        selectedExercise.value = exercise;
        sidebarVariant.value = "exercise";
        sidebarOpen.value = true;
    }

    function selectUnit(unit: UnitsWithExercises) {
        selectedUnit.value = unit;
        sidebarVariant.value = "unit";
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
    }

    function handleDragStart(
        data: { id: number; unitId: number; position: number },
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

        const { data, error } = await supabase
            .from("units")
            .select(
                `
        id, 
        created_at, 
        name, 
        description, 
        patient_uid, 
        therapist_uid, 
        exercises_index,
        is_template,
        exercises(*)
        `,
            )
            .eq("patient_uid", selectedPatientId.value);

        if (error) {
            console.error("Error loading training units:", error);
            navigateTo(localePath(`/editor`));
            return;
        }

        if (data) {
            units.value = data as UnitsWithExercises[];
        }
    }

    async function createExercise(unitId: number) {
        const unit = units.value.find((u) => u.id === unitId);
        if (!unit) {
            console.error("Unit not found");
            return;
        }

        const { data, error } = await supabase
            .from("exercises")
            .insert([
                {
                    name: "New Exercise",
                    default_exercise_id: 1,
                    training_unit_id: unitId,
                    focus_type: "strength",
                    family_scene_adjustment_access: false,
                    therapist_uid: supabaseUser.value?.id || "",
                },
            ])
            .select();

        if (error) {
            console.error("Error creating exercise:", error);
            return;
        }

        if (data && data[0]) {
            const newExerciseId = data[0].id;
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

    async function deleteExercise(exerciseId: number) {
        if (!confirm("Are you sure you want to delete this exercise?")) {
            return;
        }

        const exercise = selectedExercise.value;
        if (!exercise) return;

        try {
            const { data: unitData } = await supabase
                .from("units")
                .select("id, exercises_index")
                .eq("id", exercise.training_unit_id)
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

    async function deleteUnit(unitId: number) {
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
                .eq("training_unit_id", unitId);

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
        exerciseId: number;
        sourceUnitId: number;
        targetUnitId: number;
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
                        training_unit_id: targetUnitId,
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

    return {
        units,
        selectedExercise,
        selectedUnit,
        selectedPatientId,
        sidebarOpen,
        sidebarVariant,
        sidebarTitle,
        draggingExercise,
        dragInProgress,
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
        createExercise,
        saveExercise,
        deleteExercise,
        saveUnit,
        deleteUnit,
        handleExerciseDrop,
    };
});
