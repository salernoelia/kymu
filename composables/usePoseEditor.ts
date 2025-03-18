import { reactive, ref, watch } from "vue";
import * as THREE from "three";
import { YAML } from "yaml";

export interface JointControl {
    name: string;
    fullPath: string;
    rotation: {
        x: number;
        y: number;
        z: number;
    };
    min: {
        x: number;
        y: number;
        z: number;
    };
    max: {
        x: number;
        y: number;
        z: number;
    };
    originalRotation?: THREE.Euler;
}

export interface JointGroup {
    name: string;
    joints: JointControl[];
}

export function usePoseEditor() {
    const isLoaded = ref(false);
    const modelObject = ref<THREE.Object3D | null>(null);
    const jointGroups = reactive<JointGroup[]>([]);
    const selectedGroup = ref<string | null>(null);

    // Maps joint full paths to their THREE.Object3D references
    const jointMap = reactive<Record<string, THREE.Object3D>>({});

    // Organize joints into logical groups
    const groupJoints = () => {
        const groups: JointGroup[] = [
            { name: "Arms", joints: [] },
            { name: "Legs", joints: [] },
            { name: "Spine", joints: [] },
            { name: "Hands", joints: [] },
            { name: "Head", joints: [] },
        ];

        Object.entries(jointMap).forEach(([path, joint]) => {
            const name = path.split("/").pop() || "";

            // Skip mesh objects and other non-joint objects
            if (name.includes("_DELETE") || name === "body_mesh") return;

            const jointControl: JointControl = {
                name,
                fullPath: path,
                rotation: {
                    x: THREE.MathUtils.radToDeg(joint.rotation.x),
                    y: THREE.MathUtils.radToDeg(joint.rotation.y),
                    z: THREE.MathUtils.radToDeg(joint.rotation.z),
                },
                min: { x: -180, y: -180, z: -180 },
                max: { x: 180, y: 180, z: 180 },
                originalRotation: joint.rotation.clone(),
            };

            // Assign to appropriate group
            if (path.includes("Arm") || path.includes("Shoulder")) {
                groups[0].joints.push(jointControl);
            } else if (path.includes("Leg")) {
                groups[1].joints.push(jointControl);
            } else if (
                path.includes("Spine") || path.includes("Hips") ||
                path.includes("Chest")
            ) {
                groups[2].joints.push(jointControl);
            } else if (
                path.includes("Hand") || path.includes("Finger") ||
                path.includes("Thumb")
            ) {
                groups[3].joints.push(jointControl);
            } else if (
                path.includes("Head") || path.includes("Neck") ||
                path.includes("Eye") || path.includes("Jaw")
            ) {
                groups[4].joints.push(jointControl);
            } else {
                // Default to spine group if unmatched
                groups[2].joints.push(jointControl);
            }
        });

        // Only add groups that have joints
        jointGroups.splice(
            0,
            jointGroups.length,
            ...groups.filter((g) => g.joints.length > 0),
        );

        if (jointGroups.length > 0 && !selectedGroup.value) {
            selectedGroup.value = jointGroups[0].name;
        }
    };

    const initializeModel = (model: THREE.Object3D) => {
        modelObject.value = model;

        // Map all joints and build a path hierarchy
        const traverseJoint = (joint: THREE.Object3D, path: string = "") => {
            const currentPath = path ? `${path}/${joint.name}` : joint.name;
            jointMap[currentPath] = joint;

            joint.children.forEach((child) => {
                traverseJoint(child, currentPath);
            });
        };

        traverseJoint(model);
        groupJoints();
        console.log("Joint map:", jointMap);

        isLoaded.value = true;
    };

    const resetPose = () => {
        Object.values(jointGroups).forEach((group) => {
            group.joints.forEach((joint) => {
                if (joint.originalRotation && jointMap[joint.fullPath]) {
                    const obj = jointMap[joint.fullPath];
                    obj.rotation.copy(joint.originalRotation);

                    // Update the control values
                    joint.rotation.x = THREE.MathUtils.radToDeg(obj.rotation.x);
                    joint.rotation.y = THREE.MathUtils.radToDeg(obj.rotation.y);
                    joint.rotation.z = THREE.MathUtils.radToDeg(obj.rotation.z);
                }
            });
        });
    };

    const updateJointRotation = (
        jointPath: string,
        axis: "x" | "y" | "z",
        value: number,
    ) => {
        const joint = jointMap[jointPath];
        if (joint) {
            joint.rotation[axis] = THREE.MathUtils.degToRad(value);

            // Find and update the control object too
            for (const group of jointGroups) {
                const control = group.joints.find((j) =>
                    j.fullPath === jointPath
                );
                if (control) {
                    control.rotation[axis] = value;
                    break;
                }
            }
        }
    };

    const exportPose = () => {
        const pose: Record<string, Record<string, number>> = {};

        Object.entries(jointMap).forEach(([path, joint]) => {
            // Skip non-rotation joints or special nodes
            if (path.includes("_DELETE") || path === "body_mesh") return;

            pose[path] = {
                rotationX: THREE.MathUtils.radToDeg(joint.rotation.x),
                rotationY: THREE.MathUtils.radToDeg(joint.rotation.y),
                rotationZ: THREE.MathUtils.radToDeg(joint.rotation.z),
            };
        });

        return JSON.stringify(pose, null, 2);
    };

    const importPose = (poseData: string) => {
        try {
            const pose = JSON.parse(poseData);

            Object.entries(pose).forEach(([path, rotation]: [string, any]) => {
                if (jointMap[path]) {
                    const joint = jointMap[path];
                    joint.rotation.x = THREE.MathUtils.degToRad(
                        rotation.rotationX,
                    );
                    joint.rotation.y = THREE.MathUtils.degToRad(
                        rotation.rotationY,
                    );
                    joint.rotation.z = THREE.MathUtils.degToRad(
                        rotation.rotationZ,
                    );

                    // Update control values as well
                    for (const group of jointGroups) {
                        const control = group.joints.find((j) =>
                            j.fullPath === path
                        );
                        if (control) {
                            control.rotation.x = rotation.rotationX;
                            control.rotation.y = rotation.rotationY;
                            control.rotation.z = rotation.rotationZ;
                            break;
                        }
                    }
                }
            });
        } catch (error) {
            console.error("Failed to import pose:", error);
        }
    };

    return {
        isLoaded,
        jointGroups,
        selectedGroup,
        initializeModel,
        updateJointRotation,
        resetPose,
        exportPose,
        importPose,
    };
}
