-app/pages/kalidokit.vue
<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from "vue";
import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls.js";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader.js";
import { VRMLoaderPlugin, VRM } from "@pixiv/three-vrm";
import * as Kalidokit from "kalidokit";
import { Camera } from "@mediapipe/camera_utils";
import { Holistic } from "@mediapipe/holistic";
import {
  POSE_CONNECTIONS,
  FACEMESH_TESSELATION,
  HAND_CONNECTIONS,
} from "@mediapipe/holistic";
import { drawConnectors, drawLandmarks } from "@mediapipe/drawing_utils";

// Constants and refs setup
const showDebug = ref(true);
const modelPath = "/models/model.vrm";
const videoElement = ref<HTMLVideoElement | null>(null);
const canvasElement = ref<HTMLCanvasElement | null>(null);
const modelContainer = ref<HTMLDivElement | null>(null);
const clock = new THREE.Clock();
const isPoseReady = ref(false);
const errorMessage = ref("");
const isModelLoaded = ref(false);
const isLoading = ref(true);
const holisticResults = ref(null);
const debugInfo = ref("");

// Three.js globals
let scene: THREE.Scene;
let camera: THREE.PerspectiveCamera;
let renderer: THREE.WebGLRenderer;
let currentVrm: VRM | null = null;
let controls: OrbitControls;

// Animation smoothing
const smoothing = 0.3;

// Holistic service class
class HolisticService {
  private readonly holistic;
  private readonly ctx: CanvasRenderingContext2D;
  private readonly camera: Camera;

  constructor(
    public readonly canvas: HTMLCanvasElement,
    public readonly source: HTMLVideoElement,
    public readonly canvasWidth: number,
    public readonly canvasHeight: number,
    public readonly onResults: (results: any) => void
  ) {
    this.holistic = new Holistic({
      locateFile: (file) => {
        return `https://cdn.jsdelivr.net/npm/@mediapipe/holistic@0.5.1635989137/${file}`;
      },
    });

    this.ctx = canvas.getContext("2d") as CanvasRenderingContext2D;

    source.addEventListener("loadedmetadata", () => {
      this.canvas.height = source.videoHeight;
      this.canvas.width = source.videoWidth;
    });

    // Initialize MediaPipe camera
    this.camera = new Camera(source, {
      onFrame: async () => {
        try {
          if (source.readyState >= 2) {
            await this.holistic.send({ image: source });
          }
        } catch (error) {
          console.warn("Error in holistic processing:", error);
        }
      },
      width: canvasWidth,
      height: canvasHeight,
    });
  }

  public setOptions(options: object): Promise<void> {
    this.holistic.onResults((results) => {
      this.render(results);
      this.onResults(results);
    });

    this.holistic.setOptions(options);
    return this.start();
  }

  public async start(): Promise<void> {
    try {
      await this.camera.start();
      console.log("Camera started successfully");
      return Promise.resolve();
    } catch (error) {
      console.error("Error starting camera:", error);
      return Promise.reject(error);
    }
  }

  public render(results: any): void {
    const { width, height } = this.canvas;

    this.ctx.save();
    this.ctx.clearRect(0, 0, width, height);
    this.ctx.drawImage(results.image, 0, 0, width, height);

    // Draw pose landmarks
    if (results.poseLandmarks) {
      drawConnectors(this.ctx, results.poseLandmarks, POSE_CONNECTIONS, {
        color: "#00FF00",
        lineWidth: 2,
      });
      drawLandmarks(this.ctx, results.poseLandmarks, {
        color: "#FF0000",
        lineWidth: 1,
      });
    }

    // Draw face mesh
    if (results.faceLandmarks) {
      drawConnectors(this.ctx, results.faceLandmarks, FACEMESH_TESSELATION, {
        color: "#00FFFF",
        lineWidth: 0.5,
      });
    }

    // Draw hands
    if (results.leftHandLandmarks) {
      drawConnectors(this.ctx, results.leftHandLandmarks, HAND_CONNECTIONS, {
        color: "#CC0000",
        lineWidth: 2,
      });
      drawLandmarks(this.ctx, results.leftHandLandmarks, {
        color: "#00FF00",
        lineWidth: 1,
      });
    }
    if (results.rightHandLandmarks) {
      drawConnectors(this.ctx, results.rightHandLandmarks, HAND_CONNECTIONS, {
        color: "#00CC00",
        lineWidth: 2,
      });
      drawLandmarks(this.ctx, results.rightHandLandmarks, {
        color: "#FF0000",
        lineWidth: 1,
      });
    }

    this.ctx.restore();
  }
}

onMounted(async () => {
  isLoading.value = true;
  try {
    await requestCameraPermission();
    initScene();
    await loadVRMModel();
    await initHolistic();
  } catch (error) {
    console.error("Error during initialization:", error);
    errorMessage.value = `Setup error: ${
      error instanceof Error ? error.message : String(error)
    }`;
  } finally {
    isLoading.value = false;
  }
});

const requestCameraPermission = async () => {
  try {
    // Explicitly request camera permission
    await navigator.mediaDevices.getUserMedia({ video: true });
    console.log("Camera permission granted");
  } catch (error) {
    console.error("Error getting camera permission:", error);
    errorMessage.value =
      "Camera access denied. Please allow camera access and reload the page.";
    throw error;
  }
};

const initScene = () => {
  if (!modelContainer.value) {
    throw new Error("Model container not found");
  }

  scene = new THREE.Scene();
  scene.background = new THREE.Color(0xf0f0f0);

  camera = new THREE.PerspectiveCamera(
    30,
    modelContainer.value.clientWidth / modelContainer.value.clientHeight,
    0.1,
    20
  );
  camera.position.set(0, 1.3, 2.5);

  renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setSize(
    modelContainer.value.clientWidth,
    modelContainer.value.clientHeight
  );
  renderer.setPixelRatio(window.devicePixelRatio);
  modelContainer.value.appendChild(renderer.domElement);

  const light = new THREE.DirectionalLight(0xffffff, 1);
  light.position.set(1, 1, 1).normalize();
  scene.add(light);
  scene.add(new THREE.AmbientLight(0xcccccc));

  controls = new OrbitControls(camera, renderer.domElement);
  controls.target.set(0, 1.3, 0);
  controls.screenSpacePanning = true;

  const gridHelper = new THREE.GridHelper(10, 10);
  scene.add(gridHelper);

  animate();

  window.addEventListener("resize", handleResize);
};

const handleResize = () => {
  if (!modelContainer.value || !camera || !renderer) return;

  camera.aspect =
    modelContainer.value.clientWidth / modelContainer.value.clientHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(
    modelContainer.value.clientWidth,
    modelContainer.value.clientHeight
  );
};

const loadVRMModel = async () => {
  return new Promise<void>((resolve, reject) => {
    const loader = new GLTFLoader();
    loader.crossOrigin = "anonymous";

    loader.register((parser) => {
      return new VRMLoaderPlugin(parser);
    });

    loader.load(
      modelPath,
      (gltf) => {
        console.log("GLTF loaded, checking for VRM...");
        const vrm = gltf.userData.vrm;

        if (vrm) {
          currentVrm = vrm;
          currentVrm.scene.position.set(0, 0, 0);
          scene.add(currentVrm.scene);
          currentVrm.scene.rotation.y = Math.PI;

          // Debug: Log available humanoid bones
          if (currentVrm.humanoid) {
            const boneNames = Object.keys(currentVrm.humanoid.humanBones);
            console.log("Available VRM bones:", boneNames);
          } else {
            console.warn("VRM humanoid not found");
          }

          console.log("VRM model loaded successfully");
          isModelLoaded.value = true;
          resolve();
        } else {
          const error = new Error("VRM model not found in loaded GLTF");
          console.error(error);
          reject(error);
        }
      },
      (progress) =>
        console.log(
          "Loading model:",
          Math.round((progress.loaded / progress.total) * 100),
          "%"
        ),
      (error) => {
        console.error("Error loading VRM model:", error);
        reject(error);
      }
    );
  });
};

const animate = () => {
  requestAnimationFrame(animate);

  if (currentVrm) {
    currentVrm.update(clock.getDelta());
  }

  if (controls) controls.update();
  renderer.render(scene, camera);
};

const initHolistic = async () => {
  if (!videoElement.value || !canvasElement.value) {
    throw new Error("Video or canvas element not found");
  }

  canvasElement.value.width = 640;
  canvasElement.value.height = 480;

  await new Promise((resolve) => setTimeout(resolve, 500));

  try {
    const holisticService = new HolisticService(
      canvasElement.value,
      videoElement.value,
      640,
      480,
      (results) => {
        holisticResults.value = results;

        if (validateResults(results)) {
          isPoseReady.value = true;
          errorMessage.value = "";
          processHolisticResults(results);
        } else {
          isPoseReady.value = false;
        }
      }
    );

    await holisticService.setOptions({
      modelComplexity: 1,
      smoothLandmarks: true,
      minDetectionConfidence: 0.5,
      minTrackingConfidence: 0.5,
      refineFaceLandmarks: true,
      enableSegmentation: false,
    });
  } catch (error) {
    console.error("Failed to initialize holistic detection:", error);
    errorMessage.value = `Holistic error: ${
      error instanceof Error ? error.message : String(error)
    }`;
    throw error;
  }
};

const validateResults = (results) => {
  if (!results.poseLandmarks || !Array.isArray(results.poseLandmarks)) {
    return false;
  }

  if (results.poseLandmarks.length < 33) {
    return false;
  }

  const keyIndices = [0, 11, 12, 23, 24]; // nose, shoulders, hips
  for (const idx of keyIndices) {
    const landmark = results.poseLandmarks[idx];
    if (
      !landmark ||
      typeof landmark.x !== "number" ||
      typeof landmark.y !== "number" ||
      isNaN(landmark.x) ||
      isNaN(landmark.y) ||
      (landmark.visibility && landmark.visibility < 0.5)
    ) {
      return false;
    }
  }

  return true;
};

const processHolisticResults = (results) => {
  if (!currentVrm) {
    console.warn("VRM not available for animation");
    return;
  }

  try {
    // Process body pose
    if (results.poseLandmarks) {
      const landmarks = results.poseLandmarks.map((landmark) => ({
        x: landmark.x,
        y: landmark.y,
        z: landmark.z || 0,
        visibility: landmark.visibility || 1.0,
      }));

      const pose = Kalidokit.Pose.solve(landmarks, {
        runtime: "mediapipe",
        video: {
          width: videoElement.value?.videoWidth || 640,
          height: videoElement.value?.videoHeight || 480,
        },
        enableLegs: true,
      });

      if (pose) {
        console.log("Pose data:", pose); // Log the pose data
        animatePose(pose);
        // Update debug info to confirm pose data
        debugInfo.value = `Head rot: ${pose.head?.x.toFixed(
          2
        )}, ${pose.head?.y.toFixed(2)}, ${pose.head?.z.toFixed(2)}`;
      }
    }

    // Process face
    if (results.faceLandmarks && results.faceLandmarks.length > 0) {
      const face = Kalidokit.Face.solve(results.faceLandmarks, {
        runtime: "mediapipe",
        smoothBlink: true,
      });

      if (face) {
        animateFace(face);
      }
    }

    // Process hands
    if (results.rightHandLandmarks) {
      const hand = Kalidokit.Hand.solve(results.rightHandLandmarks, "Right");
      if (hand) {
        animateHand(hand, "right");
      }
    }

    if (results.leftHandLandmarks) {
      const hand = Kalidokit.Hand.solve(results.leftHandLandmarks, "Left");
      if (hand) {
        animateHand(hand, "left");
      }
    }
  } catch (error) {
    console.error("Error processing holistic results:", error);
  }
};

// VRM 0.x bone names - add these common mappings
const VRM_BONE_MAPPING = {
  // Standard VRM bone names
  hips: "hips",
  spine: "spine",
  chest: "chest",
  upperChest: "upperChest",
  neck: "neck",
  head: "head",
  leftShoulder: "leftShoulder",
  leftUpperArm: "leftUpperArm",
  leftLowerArm: "leftLowerArm",
  leftHand: "leftHand",
  rightShoulder: "rightShoulder",
  rightUpperArm: "rightUpperArm",
  rightLowerArm: "rightLowerArm",
  rightHand: "rightHand",
  leftUpperLeg: "leftUpperLeg",
  leftLowerLeg: "leftLowerLeg",
  leftFoot: "leftFoot",
  rightUpperLeg: "rightUpperLeg",
  rightLowerLeg: "rightLowerLeg",
  rightFoot: "rightFoot",

  // Alternative names used in some models
  upper_arm_L: "leftUpperArm",
  lower_arm_L: "leftLowerArm",
  hand_L: "leftHand",
  upper_arm_R: "rightUpperArm",
  lower_arm_R: "rightLowerArm",
  hand_R: "rightHand",
  upper_leg_L: "leftUpperLeg",
  lower_leg_L: "leftLowerLeg",
  upper_leg_R: "rightUpperLeg",
  lower_leg_R: "rightLowerLeg",
};

const animatePose = (pose) => {
  if (!currentVrm || !currentVrm.humanoid) {
    console.warn("VRM or humanoid not available for pose animation");
    return;
  }

  try {
    // Animate head and neck
    if (pose.head) {
      rigRotation("head", pose.head, 0.7);
      rigRotation("neck", pose.head, 0.7);
    }

    // Animate spine
    if (pose.spine) {
      rigRotation("spine", pose.spine, 0.7);
      rigRotation("chest", pose.spine, 0.7);
      rigRotation("upperChest", pose.spine, 0.7);
    }

    // Animate hips
    if (pose.hips) {
      rigRotation("hips", pose.hips, 0.7);
    }

    // Animate upper body
    if (pose.leftShoulder) rigRotation("leftShoulder", pose.leftShoulder, 0.7);
    if (pose.rightShoulder)
      rigRotation("rightShoulder", pose.rightShoulder, 0.7);

    // Animate arms
    if (pose.leftUpperArm) rigRotation("leftUpperArm", pose.leftUpperArm, 1);
    if (pose.leftLowerArm) rigRotation("leftLowerArm", pose.leftLowerArm, 1);
    if (pose.rightUpperArm) rigRotation("rightUpperArm", pose.rightUpperArm, 1);
    if (pose.rightLowerArm) rigRotation("rightLowerArm", pose.rightLowerArm, 1);

    // Animate hands
    if (pose.leftHand) rigRotation("leftHand", pose.leftHand, 1);
    if (pose.rightHand) rigRotation("rightHand", pose.rightHand, 1);

    // Animate legs
    if (pose.leftUpperLeg) rigRotation("leftUpperLeg", pose.leftUpperLeg, 1);
    if (pose.leftLowerLeg) rigRotation("leftLowerLeg", pose.leftLowerLeg, 1);
    if (pose.leftFoot) rigRotation("leftFoot", pose.leftFoot, 1);
    if (pose.rightUpperLeg) rigRotation("rightUpperLeg", pose.rightUpperLeg, 1);
    if (pose.rightLowerLeg) rigRotation("rightLowerLeg", pose.rightLowerLeg, 1);
    if (pose.rightFoot) rigRotation("rightFoot", pose.rightFoot, 1);
  } catch (error) {
    console.error("Error in animatePose:", error);
  }
};

const animateFace = (face) => {
  if (!currentVrm || !currentVrm.expressionManager) {
    return;
  }

  try {
    // Mouth expressions
    if (face.mouth) {
      const { mouth } = face;

      if (mouth.shape) {
        // A (aa), I (ih), U (ou), E (E), O (oh)
        // Try both common expression naming patterns
        const expressions = [
          { key: "aa", value: mouth.shape.A },
          { key: "ih", value: mouth.shape.I },
          { key: "ou", value: mouth.shape.U },
          { key: "ee", value: mouth.shape.E },
          { key: "oh", value: mouth.shape.O },

          // Alternative names
          { key: "a", value: mouth.shape.A },
          { key: "i", value: mouth.shape.I },
          { key: "u", value: mouth.shape.U },
          { key: "e", value: mouth.shape.E },
          { key: "o", value: mouth.shape.O },
        ];

        expressions.forEach(({ key, value }) => {
          if (
            typeof value === "number" &&
            key in currentVrm.expressionManager
          ) {
            try {
              currentVrm.expressionManager.setValue(key, value);
            } catch (err) {
              // Ignore errors with unsupported expressions
            }
          }
        });
      }
    }

    // Eye expressions
    if (face.eye) {
      const { eye } = face;

      const eyeExpressions = [
        { key: "blink_l", value: eye.l },
        { key: "blink_r", value: eye.r },
        { key: "blinkLeft", value: eye.l },
        { key: "blinkRight", value: eye.r },
      ];

      eyeExpressions.forEach(({ key, value }) => {
        if (typeof value === "number" && key in currentVrm.expressionManager) {
          try {
            currentVrm.expressionManager.setValue(key, value);
          } catch (err) {
            // Ignore errors with unsupported expressions
          }
        }
      });
    }
  } catch (error) {
    console.error("Error in animateFace:", error);
  }
};

const animateHand = (hand, side: "left" | "right") => {
  if (!currentVrm || !currentVrm.humanoid) return;

  try {
    const prefix = side === "left" ? "left" : "right";

    // Try different finger naming patterns that might be in your VRM
    const fingerRotations = [
      { type: "Thumb", parts: hand.thumb },
      { type: "Index", parts: hand.index },
      { type: "Middle", parts: hand.middle },
      { type: "Ring", parts: hand.ring },
      { type: "Little", parts: hand.pinky },
    ];

    fingerRotations.forEach(({ type, parts }) => {
      if (!parts) return;

      // Try different bone naming patterns
      const boneNames = [
        `${prefix}${type}Metacarpal`,
        `${prefix}${type}Proximal`,
        `${prefix}${type}Intermediate`,
        `${prefix}${type}Distal`,
      ];

      if (parts.metacarpal) rigRotation(boneNames[0], parts.metacarpal, 1);
      if (parts.proximal) rigRotation(boneNames[1], parts.proximal, 1);
      if (parts.intermediate) rigRotation(boneNames[2], parts.intermediate, 1);
      if (parts.distal) rigRotation(boneNames[3], parts.distal, 1);
    });

    // Main wrist rotation
    if (hand.wrist) {
      rigRotation(`${prefix}Hand`, hand.wrist, 1);
    }
  } catch (error) {
    console.error(`Error animating ${side} hand:`, error);
  }
};

const rigRotation = (boneName, rotation, dampener = 1) => {
  if (!currentVrm || !rotation) {
    return;
  }

  try {
    if (
      typeof rotation.x !== "number" ||
      typeof rotation.y !== "number" ||
      typeof rotation.z !== "number" ||
      isNaN(rotation.x) ||
      isNaN(rotation.y) ||
      isNaN(rotation.z)
    ) {
      return;
    }

    // Look up mapped bone name if available
    const mappedBoneName = VRM_BONE_MAPPING[boneName] || boneName;

    // Try to get the bone
    const bone = currentVrm.humanoid?.getBoneNode(mappedBoneName);

    if (bone) {
      console.log(`Rotating bone: ${mappedBoneName}, rotation:`, rotation); // Log bone and rotation
      // Create rotation values with dampening
      const euler = new THREE.Euler(
        rotation.x * dampener,
        rotation.y * dampener,
        rotation.z * dampener,
        rotation.rotationOrder || "XYZ"
      );

      // Apply rotation with smooth interpolation
      const quaternion = new THREE.Quaternion().setFromEuler(euler);
      bone.quaternion.slerp(quaternion, smoothing);
    } else {
      // Only log for important bones
      const importantBones = [
        "head",
        "neck",
        "spine",
        "hips",
        "leftUpperArm",
        "rightUpperArm",
      ];
      if (importantBones.includes(mappedBoneName)) {
        console.debug(
          `Bone not found: ${mappedBoneName} (original: ${boneName})`
        );
      }
    }
  } catch (error) {
    console.error(`Error rotating bone ${boneName}:`, error);
  }
};

onBeforeUnmount(() => {
  window.removeEventListener("resize", handleResize);
  if (renderer) {
    renderer.dispose();
  }
});
</script>

<template>
  <div class="container">
    <div
      v-if="isLoading"
      class="loading-overlay"
    >
      <div class="loading-spinner"></div>
      <div class="loading-text">Loading resources...</div>
    </div>

    <div
      v-if="errorMessage"
      class="error-message"
    >
      {{ errorMessage }}
    </div>

    <div
      class="video-container"
      v-show="showDebug"
    >
      <video
        ref="videoElement"
        class="input-video"
        autoplay
        playsinline
        muted
      ></video>
      <canvas
        ref="canvasElement"
        class="output-canvas"
      ></canvas>
      <div
        class="status-badge"
        :class="{ 'status-error': !isPoseReady, 'status-ready': isPoseReady }"
      >
        {{ isPoseReady ? "Tracking active" : "Waiting for pose..." }}
      </div>
      <div
        class="status-badge model-status"
        :class="{
          'status-error': !isModelLoaded,
          'status-ready': isModelLoaded,
        }"
      >
        {{ isModelLoaded ? "Model loaded" : "Loading model..." }}
      </div>
      <div
        v-if="debugInfo"
        class="debug-info"
      >
        {{ debugInfo }}
      </div>
    </div>

    <div
      class="model-container"
      ref="modelContainer"
    ></div>

    <div class="controls">
      <button
        @click="requestCameraPermission"
        class="control-button"
      >
        Reset Camera
      </button>
      <button
        @click="handleResize"
        class="control-button"
      >
        Reset View
      </button>
    </div>
  </div>
</template>

<style scoped>
.container {
  position: relative;
  width: 100%;
  height: 600px;
  overflow: hidden;
  border-radius: 8px;
  background-color: #f5f5f5;
}

.video-container {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 200px;
  height: 150px;
  z-index: 10;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.input-video {
  width: 100%;
  height: 100%;
  object-fit: cover;
  opacity: 0.5;
  position: absolute;
}

.output-canvas {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.model-container {
  width: 100%;
  height: 100%;
}

.status-badge {
  position: absolute;
  bottom: 8px;
  left: 8px;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
  background-color: rgba(0, 0, 0, 0.5);
  color: white;
}

.model-status {
  bottom: 38px;
}

.status-error {
  background-color: rgba(255, 59, 48, 0.7);
}

.status-ready {
  background-color: rgba(52, 199, 89, 0.7);
}

.error-message {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: rgba(255, 59, 48, 0.8);
  color: white;
  padding: 12px 20px;
  border-radius: 8px;
  z-index: 100;
  text-align: center;
  max-width: 80%;
}

.loading-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  color: white;
}

.loading-spinner {
  width: 48px;
  height: 48px;
  border: 5px solid #fff;
  border-bottom-color: transparent;
  border-radius: 50%;
  display: inline-block;
  animation: spin 1s linear infinite;
  margin-bottom: 16px;
}

.loading-text {
  font-size: 16px;
  font-weight: bold;
}

.debug-info {
  position: absolute;
  top: 8px;
  left: 8px;
  font-size: 10px;
  background-color: rgba(0, 0, 0, 0.5);
  color: white;
  padding: 2px 4px;
  border-radius: 4px;
}

.controls {
  position: absolute;
  bottom: 10px;
  left: 10px;
  display: flex;
  gap: 8px;
}

.control-button {
  padding: 8px 12px;
  background-color: rgba(0, 0, 0, 0.7);
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.control-button:hover {
  background-color: rgba(0, 0, 0, 0.8);
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>
