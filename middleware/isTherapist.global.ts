export default defineNuxtRouteMiddleware(async (to, from) => {
    const supabase = useSupabaseClient();
    const supabaseUser = useSupabaseUser();
    const localePath = useLocalePath();

    if (to.path === "/dashboard") {
        if (!supabaseUser.value?.id) {
            console.log("No user found");
            alert("No user found");
            return navigateTo(localePath("/login"));
        }

        const { data: therapistData, error } = await supabase
            .from("therapists")
            .select("*")
            .eq("uid", supabaseUser.value.id)
            .single();

        if (error) {
            alert("User is not a therapist");
            console.error("Error fetching therapist data:", error);
            return navigateTo(localePath("/"));
        }

        if (!therapistData) {
            console.log("User is not a therapist");
            return navigateTo(localePath("/"));
        }
    }
});
