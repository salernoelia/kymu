import { useUserRoleStore } from "~/stores/userRoleStore";

export default defineNuxtRouteMiddleware(async (to) => {
    if (to.path === "/auth/login" || to.path === "/auth/signup") {
        console.log("returning");
        return;
    }

    const userRoleStore = useUserRoleStore();
    const supabaseUser = useSupabaseUser();
    const localePath = useLocalePath();

    await userRoleStore.checkIfMobile();

    if (!supabaseUser.value) {
        return navigateTo(localePath("/auth/login"));
    }

    if (userRoleStore.role === "anonymous") {
        await userRoleStore.determineUserRole();
    }

    if (userRoleStore.isLoading) {
        return;
    }

    if (to.path === "/" || to.path === "" || to.path === "/auth/confirm") {
        if (userRoleStore.isMobileDevice) {
            if (userRoleStore.role === "patient") {
                return navigateTo(localePath("/family"));
            } else if (userRoleStore.role === "therapist") {
                return navigateTo(localePath("/admin"));
            }
        } else {
            if (userRoleStore.role === "patient") {
                return navigateTo(localePath("/tv"));
                // return;
            } else if (userRoleStore.role === "therapist") {
                return navigateTo(localePath("/admin"));
                // return;
            }
            return;
        }
    }

    if (to.path.startsWith("/family") && userRoleStore.role !== "patient") {
        return navigateTo(localePath("/auth/access-denied"));
    }

    if (
        (to.path.startsWith("/admin")) &&
        userRoleStore.role !== "therapist"
    ) {
        return navigateTo(localePath("/auth/access-denied"));
    }
});
