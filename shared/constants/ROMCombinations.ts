import { threshold } from "three/tsl";

export const ROMCombinations = {
    shoulder_abduction_left: {
        pivot: 11,
        movable: 13,
        reference: 23,
        threshold: 25,
    },
    shoulder_abduction_right: {
        pivot: 12,
        movable: 14,
        reference: 24,
        threshold: 25,
    },

    elbow_flexion_left: {
        pivot: 13,
        movable: 15,
        reference: 11,
        threshold: 25,
    },
    elbow_flexion_right: {
        pivot: 14,
        movable: 16,
        reference: 12,
        threshold: 25,
    },

    wrist_flexion_left: {
        pivot: 15,
        movable: 17,
        reference: 13,
        threshold: 25,
    },
    wrist_flexion_right: {
        pivot: 16,
        movable: 18,
        reference: 14,
        threshold: 25,
    },
    hip_flexion_left: {
        pivot: 23,
        movable: 25,
        reference: 11,
        threshold: 25,
    },
    hip_flexion_right: {
        pivot: 24,
        movable: 26,
        reference: 12,
        threshold: 25,
    },
    knee_flexion_left: {
        pivot: 25,
        movable: 27,
        reference: 23,
        threshold: 25,
    },
    knee_flexion_right: {
        pivot: 26,
        movable: 28,
        reference: 24,
        threshold: 25,
    },
    ankle_flexion_left: {
        pivot: 27,
        movable: 31,
        reference: 25,
        threshold: 25,
    },
    ankle_flexion_right: {
        pivot: 28,
        movable: 32,
        reference: 26,
        threshold: 25,
    },
};
