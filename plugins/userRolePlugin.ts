import { useUserRoleStore } from "~/stores/userRoleStore";

export default defineNuxtPlugin(async () => {
    const userRoleStore = useUserRoleStore();
    const supabaseUser = useSupabaseUser();

    watch(supabaseUser, async (newUser) => {
        if (newUser) {
            await userRoleStore.determineUserRole();
        } else {
            userRoleStore.role = "anonymous";
        }
    }, { immediate: true });

    await userRoleStore.checkIfMobile();
});
