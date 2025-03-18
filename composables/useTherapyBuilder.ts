import { computed, reactive, ref } from "vue";
import * as THREE from "three";

// Clinical movement terminology
type MovementType =
    | "Flexion"
    | "Extension"
    | "Abduction"
    | "Adduction"
    | "Rotation"
    | "Circumduction"
    | "Protraction"
    | "Retraction"
    | "Elevation"
    | "Depression";

// Body regions in clinical terminology
type BodyRegion =
    | "Cervical"
    | "Shoulder"
    | "Elbow"
    | "Wrist"
    | "Hand"
    | "Thoracic"
    | "Lumbar"
    | "Hip"
    | "Knee"
    | "Ankle"
    | "Foot";

// Define exercise complexity for progression
type ExerciseComplexity = "Beginner" | "Intermediate" | "Advanced";

// Pose definition for start and end positions
interface PosePosition {
    name: string;
    jointAngles: Record<string, Record<string, number>>;
    isStartPosition: boolean;
}

// Movement definition for therapy
interface TherapyMovement {
    id: string;
    name: string;
    bodyRegion: BodyRegion;
    movementType: MovementType;
    description: string;
    complexity: ExerciseComplexity;
    startPosition: PosePosition;
    endPosition: PosePosition;
    rangeOfMotionPercentage: number; // How much of full ROM to use
    instructions: string;
    targetRepetitions: number;
    targetSets: number;
    holdTime: number; // seconds
    restTime: number; // seconds
    // Biomechanical mappings for the model
    jointMappings: Record<string, string[]>;
}

export function useTherapyBuilder() {
    const model = ref<THREE.Object3D | null>(null);
    const currentMovement = ref<TherapyMovement | null>(null);
    const availableTemplates = reactive<TherapyMovement[]>([]);
    const jointMap = ref<Record<string, THREE.Object3D>>({});
    const isAnimating = ref(false);

    // Start with common rehabilitation patterns
    const initializeTemplates = () => {
        availableTemplates.push(
            // Shoulder Flexion Exercise
            {
                id: "shoulder-flexion",
                name: "Shoulder Flexion",
                bodyRegion: "Shoulder",
                movementType: "Flexion",
                description: "Raising the arm forward and upward",
                complexity: "Beginner",
                startPosition: {
                    name: "Arms at sides",
                    jointAngles: {
                        "LeftShoulder": { y: -10 },
                        "RightShoulder": { y: 10 },
                    },
                    isStartPosition: true,
                },
                endPosition: {
                    name: "Arms raised forward",
                    jointAngles: {
                        "LeftShoulder": { y: -90 },
                        "RightShoulder": { y: 90 },
                    },
                    isStartPosition: false,
                },
                rangeOfMotionPercentage: 80,
                instructions: "Raise your arms forward to shoulder height",
                targetRepetitions: 10,
                targetSets: 3,
                holdTime: 3,
                restTime: 30,
                jointMappings: {
                    "shoulder": ["LeftShoulder", "RightShoulder"],
                },
            },
            // Elbow Flexion Exercise
            {
                id: "elbow-flexion",
                name: "Elbow Flexion",
                bodyRegion: "Elbow",
                movementType: "Flexion",
                description: "Bending the elbow",
                complexity: "Beginner",
                startPosition: {
                    name: "Arms extended",
                    jointAngles: {
                        "LeftArmLower": { z: -145 },
                        "RightArmLower": { z: 32 },
                    },
                    isStartPosition: true,
                },
                endPosition: {
                    name: "Elbow bent",
                    jointAngles: {
                        "LeftArmLower": { z: -45 },
                        "RightArmLower": { z: 120 },
                    },
                    isStartPosition: false,
                },
                rangeOfMotionPercentage: 100,
                instructions:
                    "Bend your elbow bringing your hand toward your shoulder",
                targetRepetitions: 12,
                targetSets: 3,
                holdTime: 2,
                restTime: 20,
                jointMappings: {
                    "elbow": ["LeftArmLower", "RightArmLower"],
                },
            },
            // Knee Extension Exercise
            {
                id: "knee-extension",
                name: "Knee Extension",
                bodyRegion: "Knee",
                movementType: "Extension",
                description: "Straightening the knee",
                complexity: "Beginner",
                startPosition: {
                    name: "Knee bent",
                    jointAngles: {
                        "LeftLegLower": { z: 90 },
                        "RightLegLower": { z: 90 },
                    },
                    isStartPosition: true,
                },
                endPosition: {
                    name: "Leg straight",
                    jointAngles: {
                        "LeftLegLower": { z: 0 },
                        "RightLegLower": { z: 0 },
                    },
                    isStartPosition: false,
                },
                rangeOfMotionPercentage: 100,
                instructions:
                    "Straighten your knee fully, then slowly return to bent position",
                targetRepetitions: 15,
                targetSets: 2,
                holdTime: 5,
                restTime: 30,
                jointMappings: {
                    "knee": ["LeftLegLower", "RightLegLower"],
                },
            },
            // Cervical Rotation Exercise
            {
                id: "neck-rotation",
                name: "Cervical Rotation",
                bodyRegion: "Cervical",
                movementType: "Rotation",
                description: "Turning the head side to side",
                complexity: "Beginner",
                startPosition: {
                    name: "Head forward",
                    jointAngles: {
                        "Neck": { y: 0 },
                    },
                    isStartPosition: true,
                },
                endPosition: {
                    name: "Head turned",
                    jointAngles: {
                        "Neck": { y: 45 },
                    },
                    isStartPosition: false,
                },
                rangeOfMotionPercentage: 75,
                instructions:
                    "Slowly turn your head to look over your shoulder",
                targetRepetitions: 10,
                targetSets: 2,
                holdTime: 5,
                restTime: 15,
                jointMappings: {
                    "neck": ["Neck"],
                },
            },
            // Hip Abduction Exercise
            {
                id: "hip-abduction",
                name: "Hip Abduction",
                bodyRegion: "Hip",
                movementType: "Abduction",
                description: "Moving leg out to the side",
                complexity: "Beginner",
                startPosition: {
                    name: "Standing",
                    jointAngles: {
                        "LeftLegUpper": { z: 0 },
                        "RightLegUpper": { z: 0 },
                    },
                    isStartPosition: true,
                },
                endPosition: {
                    name: "Leg abducted",
                    jointAngles: {
                        "LeftLegUpper": { z: 45 },
                        "RightLegUpper": { z: -45 },
                    },
                    isStartPosition: false,
                },
                rangeOfMotionPercentage: 70,
                instructions: "Slowly raise your leg out to the side",
                targetRepetitions: 12,
                targetSets: 2,
                holdTime: 3,
                restTime: 20,
                jointMappings: {
                    "hip": ["LeftLegUpper", "RightLegUpper"],
                },
            },
            // Trunk Rotation Exercise
            {
                id: "trunk-rotation",
                name: "Trunk Rotation",
                bodyRegion: "Thoracic",
                movementType: "Rotation",
                description: "Rotating the upper body",
                complexity: "Intermediate",
                startPosition: {
                    name: "Facing forward",
                    jointAngles: {
                        "SpineUpper": { y: 0 },
                        "SpineMiddle": { y: 0 },
                    },
                    isStartPosition: true,
                },
                endPosition: {
                    name: "Rotated",
                    jointAngles: {
                        "SpineUpper": { y: 30 },
                        "SpineMiddle": { y: 20 },
                    },
                    isStartPosition: false,
                },
                rangeOfMotionPercentage: 75,
                instructions: "Rotate your upper body to each side",
                targetRepetitions: 10,
                targetSets: 2,
                holdTime: 2,
                restTime: 20,
                jointMappings: {
                    "spine": ["SpineUpper", "SpineMiddle"],
                },
            },
        );
    };

    // Update this function to correctly initialize the joint mapping
    const initializeJointMap = (modelObject: THREE.Object3D) => {
        model.value = modelObject;

        // Create a mapping of joint names to their full paths
        const jointPathMap: Record<string, string> = {};

        // Recursively traverse the model to find all joints
        const traverseJoint = (joint: THREE.Object3D, path: string = "") => {
            const currentPath = path ? `${path}/${joint.name}` : joint.name;
            jointMap.value[currentPath] = joint;

            // Store the short name to full path mapping
            jointPathMap[joint.name] = currentPath;

            joint.children.forEach((child) =>
                traverseJoint(child, currentPath)
            );
        };

        traverseJoint(modelObject);

        console.log("Found joints:", Object.keys(jointMap.value).length);

        // Debug: Print out the actual bone structure to help with mapping
        console.log(
            "Available joint paths:",
            Object.keys(jointMap.value)
                .filter((path) => path.includes("Bones"))
                .join("\n"),
        );

        return jointPathMap;
    };

    // Select an exercise template
    const selectMovementTemplate = (templateId: string) => {
        const template = availableTemplates.find((t) => t.id === templateId);
        if (template) {
            currentMovement.value = JSON.parse(JSON.stringify(template));
        }
    };

    // Helper function to find the full path of a joint by its name
    const findJointByName = (name: string): THREE.Object3D | null => {
        // First try exact match with the name
        if (jointMap.value[name]) return jointMap.value[name];

        // If not found, try to find it by searching for the name in all paths
        for (const [path, joint] of Object.entries(jointMap.value)) {
            if (path.endsWith(`/${name}`)) {
                console.log(`Found joint ${name} at path ${path}`);
                return joint;
            }
        }

        // If still not found, try partial matching (useful for model variations)
        for (const [path, joint] of Object.entries(jointMap.value)) {
            if (path.includes(name)) {
                console.log(`Found similar joint to ${name} at path ${path}`);
                return joint;
            }
        }

        console.warn(`Joint not found: ${name}`);
        return null;
    };

    // Apply a pose position to the model
    const applyPosition = (
        position: PosePosition,
        percentage: number = 100,
    ) => {
        if (!model.value) return;

        Object.entries(position.jointAngles).forEach(([jointName, angles]) => {
            const joint = jointMap.value[jointName];
            if (!joint) return;

            Object.entries(angles).forEach(([axis, angle]) => {
                // Apply percentage of full range
                const scaledAngle = typeof angle === "number"
                    ? THREE.MathUtils.degToRad(angle * (percentage / 100))
                    : 0;

                // Apply to the model
                if (axis === "x") joint.rotation.x = scaledAngle;
                if (axis === "y") joint.rotation.y = scaledAngle;
                if (axis === "z") joint.rotation.z = scaledAngle;
            });
        });
    };

    /// Update the preview function to handle joint path resolution
    const previewMovementProgress = (percentage: number) => {
        if (!currentMovement.value || !model.value) return;

        // Apply ROM scaling
        const scaledPercentage = percentage *
            (currentMovement.value.rangeOfMotionPercentage / 100);

        // If at 0%, show start position
        if (percentage <= 0) {
            Object.entries(currentMovement.value.startPosition.jointAngles)
                .forEach(
                    ([jointName, angles]) => {
                        const joint = findJointByName(jointName);
                        if (!joint) {
                            console.warn(`Joint not found: ${jointName}`);
                            return;
                        }

                        // Apply angles
                        Object.entries(angles).forEach(([axis, angle]) => {
                            if (axis === "x") {
                                joint.rotation.x = THREE.MathUtils.degToRad(
                                    angle,
                                );
                            }
                            if (axis === "y") {
                                joint.rotation.y = THREE.MathUtils.degToRad(
                                    angle,
                                );
                            }
                            if (axis === "z") {
                                joint.rotation.z = THREE.MathUtils.degToRad(
                                    angle,
                                );
                            }
                        });
                    },
                );
            return;
        }

        // If at 100%, show end position with ROM limitation
        if (percentage >= 100) {
            Object.entries(currentMovement.value.endPosition.jointAngles)
                .forEach(
                    ([jointName, endAngles]) => {
                        const joint = findJointByName(jointName);
                        if (!joint) return;

                        // Get start angles for this joint
                        const startAngles = currentMovement.value?.startPosition
                            .jointAngles[jointName] || {};

                        Object.entries(endAngles).forEach(
                            ([axis, endAngle]) => {
                                const startAngle = startAngles[axis] || 0;

                                // Scale the end angle based on ROM percentage
                                const scaledEndAngle = startAngle +
                                    ((endAngle - startAngle) *
                                        (currentMovement.value
                                            ?.rangeOfMotionPercentage || 100) /
                                        100);

                                // Apply to model
                                if (axis === "x") {
                                    joint.rotation.x = THREE.MathUtils.degToRad(
                                        scaledEndAngle,
                                    );
                                }
                                if (axis === "y") {
                                    joint.rotation.y = THREE.MathUtils.degToRad(
                                        scaledEndAngle,
                                    );
                                }
                                if (axis === "z") {
                                    joint.rotation.z = THREE.MathUtils.degToRad(
                                        scaledEndAngle,
                                    );
                                }
                            },
                        );
                    },
                );
            return;
        }

        // Interpolate between start and end positions
        Object.entries(currentMovement.value.endPosition.jointAngles).forEach(
            ([jointName, endAngles]) => {
                const joint = findJointByName(jointName);
                if (!joint) return;

                // Get start angles for this joint
                const startAngles = currentMovement.value?.startPosition
                    .jointAngles[jointName] || {};

                Object.entries(endAngles).forEach(([axis, endAngle]) => {
                    const startAngle = startAngles[axis] || 0;

                    // Scale the end angle based on ROM percentage
                    const scaledEndAngle = startAngle +
                        ((endAngle - startAngle) *
                            (currentMovement.value?.rangeOfMotionPercentage ||
                                100) /
                            100);

                    // Interpolate between start and scaled end angles
                    const interpolatedAngle = startAngle +
                        ((scaledEndAngle - startAngle) * (percentage / 100));
                    const radians = THREE.MathUtils.degToRad(interpolatedAngle);

                    // Apply to model
                    if (axis === "x") joint.rotation.x = radians;
                    if (axis === "y") joint.rotation.y = radians;
                    if (axis === "z") joint.rotation.z = radians;
                });
            },
        );
    };

    // Adjust ROM percentage
    const setRangeOfMotion = (percentage: number) => {
        if (!currentMovement.value) return;

        // Clamp value between 0-100
        const clampedPercentage = Math.max(0, Math.min(100, percentage));
        currentMovement.value.rangeOfMotionPercentage = clampedPercentage;

        // Update visualization
        previewMovementProgress(50); // Show midpoint of movement
    };

    // Reset model to neutral position
    const resetModel = () => {
        if (!model.value) return;

        // Traverse all joints and reset rotations
        model.value.traverse((object) => {
            // Reset only joints that would be manipulated
            if (object instanceof THREE.Object3D) {
                // Preserve overall model position
                if (object !== model.value) {
                    object.rotation.set(0, 0, 0);
                }
            }
        });
    };

    // Adjust exercise complexity
    const setComplexity = (complexity: ExerciseComplexity) => {
        if (!currentMovement.value) return;

        currentMovement.value.complexity = complexity;

        // Adjust other parameters based on complexity
        switch (complexity) {
            case "Beginner":
                currentMovement.value.targetSets = 2;
                currentMovement.value.rangeOfMotionPercentage = 60;
                currentMovement.value.holdTime = 3;
                break;
            case "Intermediate":
                currentMovement.value.targetSets = 3;
                currentMovement.value.rangeOfMotionPercentage = 80;
                currentMovement.value.holdTime = 5;
                break;
            case "Advanced":
                currentMovement.value.targetSets = 4;
                currentMovement.value.rangeOfMotionPercentage = 100;
                currentMovement.value.holdTime = 8;
                break;
        }

        // Update visualization
        previewMovementProgress(50);
    };

    // Create a new custom movement
    const createCustomMovement = (
        bodyRegion: BodyRegion,
        movementType: MovementType,
    ) => {
        const id =
            `custom-${bodyRegion.toLowerCase()}-${movementType.toLowerCase()}-${Date.now()}`;
        currentMovement.value = {
            id,
            name: `${bodyRegion} ${movementType}`,
            bodyRegion,
            movementType,
            description: `Custom ${bodyRegion} ${movementType} exercise`,
            complexity: "Beginner",
            startPosition: {
                name: "Starting position",
                jointAngles: {},
                isStartPosition: true,
            },
            endPosition: {
                name: "Target position",
                jointAngles: {},
                isStartPosition: false,
            },
            rangeOfMotionPercentage: 70,
            instructions: "Perform movement slowly with control",
            targetRepetitions: 10,
            targetSets: 2,
            holdTime: 3,
            restTime: 30,
            jointMappings: {},
        };

        // Suggest relevant joints based on body region
        const suggestedJoints = getSuggestedJointsForRegion(bodyRegion);
        currentMovement.value.jointMappings[bodyRegion.toLowerCase()] =
            suggestedJoints;

        // Reset model first
        resetModel();
    };

    // Update the joint mappings based on your actual model structure
    // These should match the names in your model hierarchy
    const getSuggestedJointsForRegion = (region: BodyRegion): string[] => {
        switch (region) {
            case "Shoulder":
                return ["LeftShoulder", "RightShoulder"];
            case "Elbow":
                return ["LeftArmLower", "RightArmLower"];
            case "Wrist":
                return ["LeftHandWrist", "RightHandWrist"];
            case "Cervical":
                return ["Neck", "Head"];
            case "Thoracic":
                return ["SpineUpper", "Chest"];
            case "Lumbar":
                return ["SpineLower", "SpineMiddle"];
            case "Hip":
                return ["LeftLegUpper", "RightLegUpper"];
            case "Knee":
                return ["LeftLegLower", "RightLegLower"];
            case "Ankle":
                return ["LeftFootTwist", "RightFootTwist"];
            default:
                return [];
        }
    };

    // Update capture function to use joint finding method
    const captureCurrentPose = (isStartPosition: boolean) => {
        if (!currentMovement.value || !model.value) return;

        const position: PosePosition = {
            name: isStartPosition ? "Starting position" : "Target position",
            jointAngles: {},
            isStartPosition,
        };

        // Iterate through joints relevant to the current body region
        const relevantJoints = Object.values(
            currentMovement.value.jointMappings,
        ).flat();

        relevantJoints.forEach((jointName) => {
            const joint = findJointByName(jointName);
            if (!joint) {
                console.warn(`Could not find joint ${jointName} for capturing`);
                return;
            }

            position.jointAngles[jointName] = {
                x: THREE.MathUtils.radToDeg(joint.rotation.x),
                y: THREE.MathUtils.radToDeg(joint.rotation.y),
                z: THREE.MathUtils.radToDeg(joint.rotation.z),
            };
        });

        if (isStartPosition) {
            currentMovement.value.startPosition = position;
        } else {
            currentMovement.value.endPosition = position;
        }
    };

    // Animate movement sequence
    const animateMovement = (onComplete: () => void) => {
        if (!currentMovement.value || isAnimating.value) return;

        isAnimating.value = true;
        let progress = 0;
        let direction = 1;
        let repetition = 0;

        const animate = () => {
            // Update progress
            progress += direction * 2;

            // Check direction change or completion
            if (progress >= 100) {
                // Hold at top position
                setTimeout(() => {
                    direction = -1;
                }, currentMovement.value?.holdTime || 3 * 1000);
            } else if (progress <= 0 && direction === -1) {
                // Completed one rep
                repetition++;

                if (
                    repetition >=
                        (currentMovement.value?.targetRepetitions || 1)
                ) {
                    // End animation
                    isAnimating.value = false;
                    onComplete();
                    return;
                }

                // Reset for next rep after brief pause
                setTimeout(() => {
                    direction = 1;
                }, 500);
            }

            // Apply movement at current progress
            previewMovementProgress(progress);

            // Continue animation
            if (isAnimating.value) {
                requestAnimationFrame(animate);
            }
        };

        // Start animation
        animate();
    };

    // Stop animation
    const stopAnimation = () => {
        isAnimating.value = false;
    };

    // Save movement to collection
    const saveMovement = () => {
        if (!currentMovement.value) return null;

        // Add to available templates if it's new
        if (
            !availableTemplates.some((t) => t.id === currentMovement.value?.id)
        ) {
            availableTemplates.push(
                JSON.parse(JSON.stringify(currentMovement.value)),
            );
        } else {
            // Update existing template
            const index = availableTemplates.findIndex((t) =>
                t.id === currentMovement.value?.id
            );
            if (index >= 0) {
                availableTemplates[index] = JSON.parse(
                    JSON.stringify(currentMovement.value),
                );
            }
        }

        return currentMovement.value;
    };

    // Computed properties for UI organization
    const bodyRegions = computed(() => {
        const regions: BodyRegion[] = [
            "Cervical",
            "Shoulder",
            "Elbow",
            "Wrist",
            "Hand",
            "Thoracic",
            "Lumbar",
            "Hip",
            "Knee",
            "Ankle",
            "Foot",
        ];
        return regions;
    });

    const movementTypes = computed(() => {
        const types: MovementType[] = [
            "Flexion",
            "Extension",
            "Abduction",
            "Adduction",
            "Rotation",
            "Circumduction",
            "Protraction",
            "Retraction",
            "Elevation",
            "Depression",
        ];
        return types;
    });

    // Initialize templates
    initializeTemplates();

    return {
        availableTemplates,
        currentMovement,
        bodyRegions,
        movementTypes,
        isAnimating,
        initializeJointMap,
        selectMovementTemplate,
        previewMovementProgress,
        setRangeOfMotion,
        setComplexity,
        createCustomMovement,
        captureCurrentPose,
        resetModel,
        saveMovement,
        animateMovement,
        stopAnimation,
        findJointByName,
    };
}
