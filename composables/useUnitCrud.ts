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
     * Get all units for a specific patient with their assesments and exercises
     */
    const getWithDetails = async (): Promise<Unit[]> => {
        const { data, error } = await supabase
            .from("units")
            .select("*,
                assessments(*),
                ")
            .eq("patient_uid", patientId.value)
            .order("created_at", { ascending: false });

        if (error) throw error;
        return data || [];
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
        getById,
        create,
        update,
        deleteUnit,
        toggleUnitFocus,
    };
};
