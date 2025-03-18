import { computed, reactive, ref } from "vue";
import * as THREE from "three";

// Define clinically relevant movement patterns
export interface MovementPattern {
    name: string;
    description: string;
    targetJoints: string[];
    minROM: number; // 0-100% of full anatomical range
    maxROM: number; // 0-100% of full anatomical range
    difficulty: number; // 1-5 scale
    anatomicalPlane: "sagittal" | "frontal" | "transverse";
    jointValues: Record<string, {
        axis: "x" | "y" | "z";
        minAngle: number;
        maxAngle: number;
        neutralAngle: number;
    }>;
}

export function useExerciseBuilder() {
    const availablePatterns = reactive<MovementPattern[]>([
        {
            name: "Shoulder Flexion",
            description: "Raising arm forward and upward",
            targetJoints: ["LeftShoulder", "RightShoulder"],
            minROM: 0,
            maxROM: 100,
            difficulty: 3,
            anatomicalPlane: "sagittal",
            jointValues: {
                "LeftShoulder": {
                    axis: "y",
                    minAngle: -10,
                    maxAngle: -90,
                    neutralAngle: -10,
                },
                "RightShoulder": {
                    axis: "y",
                    minAngle: 10,
                    maxAngle: 90,
                    neutralAngle: 10,
                },
            },
        },
        {
            name: "Shoulder Abduction",
            description: "Raising arm sideways away from body",
            targetJoints: ["LeftShoulder", "RightShoulder"],
            minROM: 0,
            maxROM: 100,
            difficulty: 3,
            anatomicalPlane: "frontal",
            jointValues: {
                "LeftShoulder": {
                    axis: "z",
                    minAngle: 10,
                    maxAngle: 90,
                    neutralAngle: 10,
                },
                "RightShoulder": {
                    axis: "z",
                    minAngle: -10,
                    maxAngle: -90,
                    neutralAngle: -10,
                },
            },
        },
        {
            name: "Elbow Flexion",
            description: "Bending elbow",
            targetJoints: ["LeftArmLower", "RightArmLower"],
            minROM: 0,
            maxROM: 100,
            difficulty: 2,
            anatomicalPlane: "sagittal",
            jointValues: {
                "LeftArmLower": {
                    axis: "z",
                    minAngle: -145,
                    maxAngle: -45,
                    neutralAngle: -145,
                },
                "RightArmLower": {
                    axis: "z",
                    minAngle: 32,
                    maxAngle: 120,
                    neutralAngle: 32,
                },
            },
        },
        {
            name: "Neck Rotation",
            description: "Turning head side to side",
            targetJoints: ["Neck"],
            minROM: 0,
            maxROM: 100,
            difficulty: 2,
            anatomicalPlane: "transverse",
            jointValues: {
                "Neck": {
                    axis: "x",
                    minAngle: -30,
                    maxAngle: 30,
                    neutralAngle: 0,
                },
            },
        },
        {
            name: "Knee Flexion",
            description: "Bending knee",
            targetJoints: ["LeftLegLower", "RightLegLower"],
            minROM: 0,
            maxROM: 100,
            difficulty: 3,
            anatomicalPlane: "sagittal",
            jointValues: {
                "LeftLegLower": {
                    axis: "z",
                    minAngle: 0,
                    maxAngle: 120,
                    neutralAngle: 0,
                },
                "RightLegLower": {
                    axis: "z",
                    minAngle: 0,
                    maxAngle: 120,
                    neutralAngle: 0,
                },
            },
        },
    ]);

    // Currently selected movement pattern
    const selectedPattern = ref<MovementPattern | null>(null);

    // Joint map of 3D objects from the model
    const jointMap = ref<Record<string, THREE.Object3D>>({});

    // Current state of exercise creation
    const currentExercise = reactive({
        name: "",
        description: "",
        patterns: [] as MovementPattern[],
        repetitions: 10,
        sets: 3,
        holdTime: 5,
        restTime: 30,
    });

    // Initialize joint map from the 3D model
    const initializeJointMap = (model: THREE.Object3D) => {
        const traverseJoint = (joint: THREE.Object3D, path: string = "") => {
            const currentPath = path ? `${path}/${joint.name}` : joint.name;
            jointMap.value[joint.name] = joint;

            joint.children.forEach((child) => {
                traverseJoint(child, currentPath);
            });
        };

        traverseJoint(model);
    };

    // Calculate actual joint angle based on ROM percentage
    const calculateAngleFromROM = (
        pattern: MovementPattern,
        jointName: string,
    ) => {
        const jointConfig = pattern.jointValues[jointName];
        if (!jointConfig) return null;

        const range = jointConfig.maxAngle - jointConfig.neutralAngle;
        const angle = jointConfig.neutralAngle +
            (range * (pattern.minROM / 100));
        return angle;
    };

    // Apply movement pattern to model with current ROM settings
    const applyMovementPattern = (pattern: MovementPattern) => {
        pattern.targetJoints.forEach((jointName) => {
            const joint = jointMap.value[jointName];
            const jointConfig = pattern.jointValues[jointName];

            if (joint && jointConfig) {
                // Calculate angle based on ROM percentage
                const neutralToMax = jointConfig.maxAngle -
                    jointConfig.neutralAngle;
                const targetAngle = jointConfig.neutralAngle +
                    (neutralToMax * (pattern.minROM / 100));

                // Apply to model
                joint.rotation[jointConfig.axis] = THREE.MathUtils.degToRad(
                    targetAngle,
                );
            }
        });
    };

    // Update pattern difficulty (1-5 scale)
    const setPatternDifficulty = (
        pattern: MovementPattern,
        difficulty: number,
    ) => {
        // Clamp difficulty between 1-5
        const clampedDifficulty = Math.max(1, Math.min(5, difficulty));
        pattern.difficulty = clampedDifficulty;

        // Adjust ROM based on difficulty
        // Easier = less range of motion, harder = more range of motion
        const romPercentage = clampedDifficulty * 20; // 20% per difficulty level
        pattern.maxROM = Math.min(100, romPercentage);
    };

    // Add current pattern to exercise
    const addPatternToExercise = () => {
        if (selectedPattern.value) {
            currentExercise.patterns.push({ ...selectedPattern.value });
        }
    };

    // Create a complete exercise prescription
    const createExercise = () => {
        // Return full exercise definition that can be saved
        return {
            ...currentExercise,
            createdAt: new Date().toISOString(),
        };
    };

    // Preview full exercise movement sequence
    const previewExercise = () => {
        // Logic to animate through all patterns in sequence
        // This would show the full exercise to the therapist
    };

    return {
        availablePatterns,
        selectedPattern,
        currentExercise,
        initializeJointMap,
        applyMovementPattern,
        setPatternDifficulty,
        addPatternToExercise,
        createExercise,
        previewExercise,
    };
}
