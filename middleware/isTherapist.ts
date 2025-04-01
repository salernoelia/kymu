export default defineNuxtRouteMiddleware(async (to, from) => {
    // Initialize composables inside the middleware function
    const supabase = useSupabaseClient();
    const supabaseUser = useSupabaseUser();

    // check if user is on therapist table
    if (to.path === "/dashboard") {
        if (!supabaseUser.value?.id) {
            console.log("No user found");
            return navigateTo("/login");
        }

        const { data: therapistData, error } = await supabase
            .from("therapist")
            .select("*")
            .eq("user_id", supabaseUser.value.id)
            .single();

        if (error) {
            console.error("Error fetching therapist data:", error);
            return navigateTo("/");
        }

        console.log("Therapist data:", therapistData);

        if (!therapistData) {
            console.log("User is not a therapist");
            return navigateTo("/");
        }
    }
});
