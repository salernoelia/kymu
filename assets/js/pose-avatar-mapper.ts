import * as THREE from "three";

/**
 * Utility class to map MediaPipe pose data to 3D avatar bones
 */
export class PoseAvatarMapper {
    // Store quaternions for bone rotations
    private readonly quaternions: Record<string, THREE.Quaternion> = {};
    // Previous rotations for smoothing
    private readonly prevRotations: Record<string, THREE.Quaternion> = {};
    // Rotation limits to prevent unrealistic poses
    private readonly rotationLimits: Record<
        string,
        { min: number; max: number }
    > = {
        head: { min: -Math.PI / 4, max: Math.PI / 4 },
        spine: { min: -Math.PI / 6, max: Math.PI / 6 },
        leftUpperArm: { min: -Math.PI / 2, max: Math.PI / 2 },
        rightUpperArm: { min: -Math.PI / 2, max: Math.PI / 2 },
    };

    // MediaPipe landmark indices for key body points
    private readonly LANDMARK_INDICES = {
        NOSE: 0,
        LEFT_EYE_INNER: 1,
        LEFT_EYE: 2,
        LEFT_EYE_OUTER: 3,
        RIGHT_EYE_INNER: 4,
        RIGHT_EYE: 5,
        RIGHT_EYE_OUTER: 6,
        LEFT_EAR: 7,
        RIGHT_EAR: 8,
        MOUTH_LEFT: 9,
        MOUTH_RIGHT: 10,
        LEFT_SHOULDER: 11,
        RIGHT_SHOULDER: 12,
        LEFT_ELBOW: 13,
        RIGHT_ELBOW: 14,
        LEFT_WRIST: 15,
        RIGHT_WRIST: 16,
        LEFT_PINKY: 17,
        RIGHT_PINKY: 18,
        LEFT_INDEX: 19,
        RIGHT_INDEX: 20,
        LEFT_THUMB: 21,
        RIGHT_THUMB: 22,
        LEFT_HIP: 23,
        RIGHT_HIP: 24,
        LEFT_KNEE: 25,
        RIGHT_KNEE: 26,
        LEFT_ANKLE: 27,
        RIGHT_ANKLE: 28,
        LEFT_HEEL: 29,
        RIGHT_HEEL: 30,
        LEFT_FOOT_INDEX: 31,
        RIGHT_FOOT_INDEX: 32,
    };

    constructor() {
        // Initialize quaternions with identity rotations
        const boneNames = [
            "spine",
            "chest",
            "neck",
            "head",
            "leftShoulder",
            "leftUpperArm",
            "leftLowerArm",
            "leftHand",
            "rightShoulder",
            "rightUpperArm",
            "rightLowerArm",
            "rightHand",
            "leftUpperLeg",
            "leftLowerLeg",
            "leftFoot",
            "rightUpperLeg",
            "rightLowerLeg",
            "rightFoot",
        ];

        boneNames.forEach((bone) => {
            this.quaternions[bone] = new THREE.Quaternion();
            this.prevRotations[bone] = new THREE.Quaternion();
        });
    }

    /**
     * Calculate rotations for humanoid bones based on MediaPipe pose landmarks
     */
    public calculateBoneRotations(
        poseLandmarks: any[],
    ): Record<string, THREE.Quaternion> {
        if (!poseLandmarks || poseLandmarks.length < 33) {
            console.warn(
                `Insufficient landmarks: ${
                    poseLandmarks?.length || 0
                }, expected 33`,
            );
            return this.quaternions;
        }

        try {
            // Convert landmarks to normalized Vector3 objects
            // MediaPipe uses y-down, while Three.js uses y-up
            const points: THREE.Vector3[] = poseLandmarks.map(
                (landmark) =>
                    new THREE.Vector3(
                        // Flip X to mirror the movement, adjust range from [0,1] to [-0.5,0.5]
                        -landmark.x + 0.5,
                        // Flip Y since MediaPipe is y-down
                        -landmark.y + 0.5,
                        // Z needs to be negated and scaled (MediaPipe Z is opposite to Three.js)
                        -landmark.z * 0.5 || 0,
                    ),
            );

            // Calculate all rotations with dampening for stability
            this.calculateHead(points);
            this.calculateTorso(points);
            this.calculateArms(points);
            this.calculateLegs(points);
            this.calculateHands(points); // New method for hand rotations

            // Apply smoothing
            this.applySmoothing(0.7); // 0.7 means 70% previous rotation, 30% new

            return this.quaternions;
        } catch (error) {
            console.error("Error in calculateBoneRotations:", error);
            return this.quaternions;
        }
    }

    /**
     * Apply smoothing between frames to avoid jittering
     */
    private applySmoothing(smoothFactor: number): void {
        for (const bone in this.quaternions) {
            if (!this.prevRotations[bone]) {
                this.prevRotations[bone] = this.quaternions[bone].clone();
            } else {
                // Create a temporary quaternion that is a blend between previous and current
                const smoothed = new THREE.Quaternion().copy(
                    this.prevRotations[bone],
                );
                smoothed.slerp(this.quaternions[bone], 1 - smoothFactor);

                // Update the current rotation with the smoothed value
                this.quaternions[bone].copy(smoothed);

                // Store current as previous for next frame
                this.prevRotations[bone].copy(this.quaternions[bone]);
            }
        }
    }

    /**
     * Calculate head rotation using MediaPipe face landmarks
     */
    private calculateHead(points: THREE.Vector3[]): void {
        try {
            const {
                NOSE,
                LEFT_EYE,
                RIGHT_EYE,
                LEFT_EAR,
                RIGHT_EAR,
                LEFT_SHOULDER,
                RIGHT_SHOULDER,
            } = this.LANDMARK_INDICES;

            // Key points for head orientation
            const nose = points[NOSE];
            const leftEye = points[LEFT_EYE];
            const rightEye = points[RIGHT_EYE];
            const leftEar = points[LEFT_EAR];
            const rightEar = points[RIGHT_EAR];

            // Calculate shoulder midpoint for reference
            const shoulderMid = new THREE.Vector3().addVectors(
                points[LEFT_SHOULDER],
                points[RIGHT_SHOULDER],
            ).multiplyScalar(0.5);

            // Face center (between eyes)
            const faceCenter = new THREE.Vector3().addVectors(leftEye, rightEye)
                .multiplyScalar(0.5);

            // Forward direction (face to shoulder mid)
            const forwardDir = new THREE.Vector3().subVectors(
                faceCenter,
                shoulderMid,
            ).normalize();

            // Side direction (ear to ear)
            const sideDir = new THREE.Vector3().subVectors(rightEar, leftEar)
                .normalize();

            // Up direction (cross product of forward and side)
            const upDir = new THREE.Vector3().crossVectors(forwardDir, sideDir)
                .normalize();

            // Recalculate side direction to ensure orthogonality
            const adjustedSideDir = new THREE.Vector3().crossVectors(
                upDir,
                forwardDir,
            ).normalize();

            // Create rotation matrix from these orthogonal directions
            const rotMatrix = new THREE.Matrix4();
            rotMatrix.makeBasis(adjustedSideDir, upDir, forwardDir.negate());

            // Convert to quaternion
            const headQuat = new THREE.Quaternion().setFromRotationMatrix(
                rotMatrix,
            );

            // Apply to head and neck with subtle differences
            this.quaternions["head"] = headQuat;
            this.quaternions["neck"] = headQuat.clone().premultiply(
                new THREE.Quaternion().setFromAxisAngle(
                    new THREE.Vector3(0, 0, 1),
                    0.1,
                ),
            );
        } catch (error) {
            console.error("Error in calculateHead:", error);
        }
    }

    /**
     * Calculate spine and torso rotations
     */
    private calculateTorso(points: THREE.Vector3[]): void {
        try {
            const { LEFT_SHOULDER, RIGHT_SHOULDER, LEFT_HIP, RIGHT_HIP } =
                this.LANDMARK_INDICES;

            // Key points
            const leftShoulder = points[LEFT_SHOULDER];
            const rightShoulder = points[RIGHT_SHOULDER];
            const leftHip = points[LEFT_HIP];
            const rightHip = points[RIGHT_HIP];

            // Calculate center points
            const shoulderMid = new THREE.Vector3().addVectors(
                leftShoulder,
                rightShoulder,
            ).multiplyScalar(0.5);

            const hipMid = new THREE.Vector3().addVectors(
                leftHip,
                rightHip,
            ).multiplyScalar(0.5);

            // Define primary directions
            // Up direction (spine)
            const upVector = new THREE.Vector3().subVectors(shoulderMid, hipMid)
                .normalize();

            // Shoulder direction (from left to right)
            const shoulderVector = new THREE.Vector3().subVectors(
                rightShoulder,
                leftShoulder,
            ).normalize();

            // Forward direction (perpendicular to shoulder and spine)
            const forwardVector = new THREE.Vector3().crossVectors(
                shoulderVector,
                upVector,
            ).normalize();

            // Recalculate side direction to ensure orthogonality
            const sideVector = new THREE.Vector3().crossVectors(
                upVector,
                forwardVector,
            ).normalize();

            // Create rotation matrix
            const spineMatrix = new THREE.Matrix4();
            spineMatrix.makeBasis(sideVector, upVector, forwardVector);

            // Convert to quaternion
            const spineQuat = new THREE.Quaternion().setFromRotationMatrix(
                spineMatrix,
            );

            // Apply to spine and chest with slight variations
            this.quaternions["spine"] = spineQuat.clone();
            this.quaternions["chest"] = spineQuat.clone();
        } catch (error) {
            console.error("Error in calculateTorso:", error);
        }
    }

    /**
     * Calculate arm rotations
     */
    private calculateArms(points: THREE.Vector3[]): void {
        try {
            const {
                LEFT_SHOULDER,
                LEFT_ELBOW,
                LEFT_WRIST,
                RIGHT_SHOULDER,
                RIGHT_ELBOW,
                RIGHT_WRIST,
            } = this.LANDMARK_INDICES;

            // Left arm
            this.calculateArmRotation(
                points[LEFT_SHOULDER],
                points[LEFT_ELBOW],
                points[LEFT_WRIST],
                "left",
            );

            // Right arm
            this.calculateArmRotation(
                points[RIGHT_SHOULDER],
                points[RIGHT_ELBOW],
                points[RIGHT_WRIST],
                "right",
            );
        } catch (error) {
            console.error("Error in calculateArms:", error);
        }
    }

    /**
     * Helper method to calculate arm rotations
     */
    private calculateArmRotation(
        shoulder: THREE.Vector3,
        elbow: THREE.Vector3,
        wrist: THREE.Vector3,
        side: "left" | "right",
    ): void {
        try {
            // Calculate bone directions
            const upperArmDir = new THREE.Vector3().subVectors(elbow, shoulder)
                .normalize();
            const forearmDir = new THREE.Vector3().subVectors(wrist, elbow)
                .normalize();

            // For upper arm
            const upperArmQuat = new THREE.Quaternion();

            // Define reference directions (default arm points down in anatomical position)
            const defaultDir = new THREE.Vector3(0, -1, 0);

            // Calculate the rotation from default to current direction
            upperArmQuat.setFromUnitVectors(defaultDir, upperArmDir);

            // For forearm, we need to calculate relative to upper arm
            const forearmQuat = new THREE.Quaternion();
            forearmQuat.setFromUnitVectors(defaultDir, forearmDir);

            // Apply rotations with side-appropriate names
            const prefix = side;
            this.quaternions[`${prefix}Shoulder`] = upperArmQuat.clone()
                .premultiply(
                    new THREE.Quaternion().setFromAxisAngle(
                        new THREE.Vector3(0, 0, 1),
                        side === "left" ? 0.1 : -0.1,
                    ),
                );
            this.quaternions[`${prefix}UpperArm`] = upperArmQuat;
            this.quaternions[`${prefix}LowerArm`] = forearmQuat;
        } catch (error) {
            console.error(`Error in calculateArmRotation (${side}):`, error);
        }
    }

    /**
     * Calculate hand rotations using wrist, index, pinky, and thumb landmarks
     */
    private calculateHands(points: THREE.Vector3[]): void {
        try {
            const {
                LEFT_WRIST,
                LEFT_INDEX,
                LEFT_PINKY,
                LEFT_THUMB,
                RIGHT_WRIST,
                RIGHT_INDEX,
                RIGHT_PINKY,
                RIGHT_THUMB,
            } = this.LANDMARK_INDICES;

            // Calculate left hand rotation
            const leftWrist = points[LEFT_WRIST];
            const leftIndex = points[LEFT_INDEX];
            const leftPinky = points[LEFT_PINKY];
            const leftThumb = points[LEFT_THUMB];

            // Hand plane normal (for left hand)
            const leftHandUp = new THREE.Vector3().subVectors(
                leftIndex,
                leftWrist,
            ).normalize();
            const leftHandSide = new THREE.Vector3().subVectors(
                leftPinky,
                leftWrist,
            ).normalize();
            const leftHandForward = new THREE.Vector3().crossVectors(
                leftHandSide,
                leftHandUp,
            ).normalize();

            // Create matrix and quaternion
            const leftHandMatrix = new THREE.Matrix4();
            leftHandMatrix.makeBasis(leftHandSide, leftHandUp, leftHandForward);
            const leftHandQuat = new THREE.Quaternion().setFromRotationMatrix(
                leftHandMatrix,
            );

            // Right hand calculations
            const rightWrist = points[RIGHT_WRIST];
            const rightIndex = points[RIGHT_INDEX];
            const rightPinky = points[RIGHT_PINKY];
            const rightThumb = points[RIGHT_THUMB];

            // Hand plane normal (for right hand)
            const rightHandUp = new THREE.Vector3().subVectors(
                rightIndex,
                rightWrist,
            ).normalize();
            const rightHandSide = new THREE.Vector3().subVectors(
                rightPinky,
                rightWrist,
            ).normalize();
            const rightHandForward = new THREE.Vector3().crossVectors(
                rightHandUp,
                rightHandSide,
            ).normalize();

            // Create matrix and quaternion
            const rightHandMatrix = new THREE.Matrix4();
            rightHandMatrix.makeBasis(
                rightHandSide,
                rightHandUp,
                rightHandForward,
            );
            const rightHandQuat = new THREE.Quaternion().setFromRotationMatrix(
                rightHandMatrix,
            );

            // Apply to hand bones
            this.quaternions["leftHand"] = leftHandQuat;
            this.quaternions["rightHand"] = rightHandQuat;
        } catch (error) {
            console.error("Error in calculateHands:", error);
        }
    }

    /**
     * Calculate leg rotations
     */
    private calculateLegs(points: THREE.Vector3[]): void {
        try {
            const {
                LEFT_HIP,
                LEFT_KNEE,
                LEFT_ANKLE,
                LEFT_FOOT_INDEX,
                LEFT_HEEL,
                RIGHT_HIP,
                RIGHT_KNEE,
                RIGHT_ANKLE,
                RIGHT_FOOT_INDEX,
                RIGHT_HEEL,
            } = this.LANDMARK_INDICES;

            // Left leg
            this.calculateLegRotation(
                points[LEFT_HIP],
                points[LEFT_KNEE],
                points[LEFT_ANKLE],
                points[LEFT_FOOT_INDEX],
                points[LEFT_HEEL],
                "left",
            );

            // Right leg
            this.calculateLegRotation(
                points[RIGHT_HIP],
                points[RIGHT_KNEE],
                points[RIGHT_ANKLE],
                points[RIGHT_FOOT_INDEX],
                points[RIGHT_HEEL],
                "right",
            );
        } catch (error) {
            console.error("Error in calculateLegs:", error);
        }
    }

    /**
     * Helper method to calculate leg rotations
     */
    private calculateLegRotation(
        hip: THREE.Vector3,
        knee: THREE.Vector3,
        ankle: THREE.Vector3,
        footIndex: THREE.Vector3,
        heel: THREE.Vector3,
        side: "left" | "right",
    ): void {
        try {
            // Calculate bone directions
            const upperLegDir = new THREE.Vector3().subVectors(knee, hip)
                .normalize();
            const lowerLegDir = new THREE.Vector3().subVectors(ankle, knee)
                .normalize();

            // For foot rotation
            const footDir = new THREE.Vector3().subVectors(footIndex, ankle)
                .normalize();
            const heelToAnkle = new THREE.Vector3().subVectors(heel, ankle)
                .normalize();
            const footSide = new THREE.Vector3().crossVectors(
                heelToAnkle,
                footDir,
            ).normalize();
            const footUp = new THREE.Vector3().crossVectors(footDir, footSide)
                .normalize();

            // Default direction for legs (pointing down)
            const defaultDir = new THREE.Vector3(0, -1, 0);

            // Calculate quaternions
            const upperLegQuat = new THREE.Quaternion().setFromUnitVectors(
                defaultDir,
                upperLegDir,
            );
            const lowerLegQuat = new THREE.Quaternion().setFromUnitVectors(
                defaultDir,
                lowerLegDir,
            );

            // For foot
            const footMatrix = new THREE.Matrix4();
            footMatrix.makeBasis(footSide, footUp, footDir);
            const footQuat = new THREE.Quaternion().setFromRotationMatrix(
                footMatrix,
            );

            // Apply with appropriate side prefix
            const prefix = side;
            this.quaternions[`${prefix}UpperLeg`] = upperLegQuat;
            this.quaternions[`${prefix}LowerLeg`] = lowerLegQuat;
            this.quaternions[`${prefix}Foot`] = footQuat;
        } catch (error) {
            console.error(`Error in calculateLegRotation (${side}):`, error);
        }
    }
}
