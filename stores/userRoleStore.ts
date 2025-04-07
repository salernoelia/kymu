import { defineStore } from "pinia";

export const useUserRoleStore = defineStore("userRole", () => {
    const role = ref<UserRole>("anonymous");
    const isLoading = ref(true);
    const isMobileDevice = ref(false);

    const checkIfMobile = async () => {
        try {
            const { Device } = await import("@capacitor/device");
            const info = await Device.getInfo();
            if (!info.platform || info.platform === "web") {
                isMobileDevice.value = false;
                return false;
            }
            console.log(info);
            isMobileDevice.value = true;
            return true;
        } catch (error) {
            isMobileDevice.value = false;
            return false;
        }
    };

    const determineUserRole = async () => {
        isLoading.value = true;
        const supabase = useSupabaseClient();
        const user = useSupabaseUser();

        if (!user.value) {
            role.value = "anonymous";
            isLoading.value = false;
            return;
        }

        try {
            const { data: therapistData, error: therapistError } =
                await supabase
                    .from("therapists")
                    .select("*")
                    .eq("uid", user.value.id)
                    .single();

            if (therapistData && !therapistError) {
                role.value = "therapist";
                isLoading.value = false;
                console.log("therapist logged in!");
                return;
            }

            const { data: patientData, error: patientError } = await supabase
                .from("patients")
                .select("*")
                .eq("uid", user.value.id)
                .single();

            if (patientData && !patientError) {
                role.value = "patient";
                isLoading.value = false;
                console.log("patient logged in!");
                return;
            }

            role.value = "anonymous";
        } catch (error) {
            console.error("Error determining user role:", error);
            role.value = "anonymous";
        } finally {
            isLoading.value = false;
        }
    };

    return {
        role,
        isLoading,
        isMobileDevice,
        determineUserRole,
        checkIfMobile,
    };
});
