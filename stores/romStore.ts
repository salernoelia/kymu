export const useRomStore = defineStore("romStore", () => {
    const resultAngle = ref(0);
    const painMomentAngles = ref<number[]>([]);
    const startedRecording = ref<boolean>(false);

    return {
        resultAngle,
        painMomentAngles,
        startedRecording,
    };
});
