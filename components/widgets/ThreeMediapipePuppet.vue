<template>
  <div class="pose-avatar-container">
    <div class="video-section">
      <video
        class="input_video"
        ref="source"
        v-show="showVideo"
      ></video>
      <canvas
        class="output_canvas"
        :class="{ loading_canvas: loadingCanvas }"
        :width="videoWidth"
        :height="videoHeight"
        ref="canvas"
      ></canvas>
    </div>

    <div class="model-section">
      <div
        class="three-container"
        ref="container"
      ></div>
      <div
        v-if="modelLoadError"
        class="error-message"
      >
        {{ modelLoadError }}
      </div>
    </div>

    <!-- Debug panel -->
    <div
      v-if="showDebug"
      class="debug-panel"
    >
      <div>VRM Loaded: {{ !!vrm }}</div>
      <div>Pose Landmarks: {{ !!mediapipeResults?.poseLandmarks }}</div>
      <div>
        Model Type:
        {{ isVRMModel ? "VRM" : isMixamoModel ? "Mixamo/GLTF" : "Unknown" }}
      </div>
      <!-- Add landmark count -->
      <div v-if="mediapipeResults?.poseLandmarks">
        Landmarks: {{ mediapipeResults.poseLandmarks.length }}
      </div>
      <div>
        <label>
          <input
            type="checkbox"
            v-model="showRawPoseData"
          />
          Show Raw Pose Data
        </label>
      </div>
      <!-- Show raw pose data if enabled -->
      <pre
        v-if="showRawPoseData && mediapipeResults?.poseLandmarks"
        class="pose-data"
      >
        {{ JSON.stringify(mediapipeResults.poseLandmarks[0], null, 2) }}
        </pre
      >
      <div>
        <select v-model="debugBoneName">
          <option value="">Select bone to debug</option>
          <option
            v-for="(_, name) in vrmBoneMap"
            :key="name"
            :value="name"
          >
            {{ name }}
          </option>
        </select>
        <button @click="logBoneInfo">Log Bone Info</button>
      </div>
      <div>
        <button @click="calibratePose">Calibrate Pose</button>
        <input
          type="range"
          v-model="interpolationSpeed"
          min="0.1"
          max="1"
          step="0.1"
        />
        <span>Speed: {{ interpolationSpeed }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, onBeforeUnmount } from "vue";
import { PoseService, LogService } from "~/assets/js/pose_service";
import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls.js";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader.js";
import { VRMUtils, VRMLoaderPlugin } from "@pixiv/three-vrm";
import { PoseAvatarMapper } from "~/assets/js/pose-avatar-mapper.ts";

const props = defineProps({
  modelPath: {
    type: String,
    required: true,
  },
  scale: {
    type: Number,
    default: 1,
  },
  showVideo: {
    type: Boolean,
    default: true,
  },
});

const modelLoadError = ref("");

// Debug options
const showDebug = ref(true);
const debugBoneName = ref("");
const interpolationSpeed = ref(0.2); // Slower for smoother transitions
const isVRMModel = ref(false);
const isMixamoModel = ref(false);

// References to DOM elements
const source = ref<HTMLVideoElement | null>(null);
const canvas = ref<HTMLCanvasElement | null>(null);
const container = ref<HTMLDivElement | null>(null);
const loadingCanvas = ref(true);
const logService = new LogService();
const mediapipeResults = ref<any>(null);

// Add debug option to see pose data
const showRawPoseData = ref(false);

const videoWidth = ref(400);
const videoHeight = ref(300);

// Three.js variables
let scene: THREE.Scene;
let camera: THREE.PerspectiveCamera;
let renderer: THREE.WebGLRenderer;
let controls: OrbitControls;
let model: THREE.Object3D;
let vrm: any; // VRM model
let clock: THREE.Clock;
let animationId: number;

// Bone mappings
const vrmBoneMap = {
  hips: "hips",
  spine: "spine",
  chest: "chest",
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
};

// Mixamo bone name mapping
const mixamoBoneMap = {
  spine: "Spine",
  chest: "Spine1",
  neck: "Neck",
  head: "Head",
  leftShoulder: "LeftShoulder",
  leftUpperArm: "LeftArm",
  leftLowerArm: "LeftForeArm",
  leftHand: "LeftHand",
  rightShoulder: "RightShoulder",
  rightUpperArm: "RightArm",
  rightLowerArm: "RightForeArm",
  rightHand: "RightHand",
  leftUpperLeg: "LeftUpLeg",
  leftLowerLeg: "LeftLeg",
  leftFoot: "LeftFoot",
  rightUpperLeg: "RightUpLeg",
  rightLowerLeg: "RightLeg",
  rightFoot: "RightFoot",
};

// Current and target rotations for smoother transitions
const currentRotations = ref({});
const targetRotations = ref({});
watch(
  () => mediapipeResults.value?.poseLandmarks,
  (newLandmarks) => {
    if (newLandmarks) {
      console.log("Pose landmarks updated", new Date().toISOString());
    }
  },
  { deep: true }
);

// Create the pose mapper
const poseMapper = new PoseAvatarMapper();

// Initialize Three.js scene
const initScene = () => {
  if (!container.value) return;

  const width = container.value.clientWidth;
  const height = container.value.clientHeight;

  // Set up scene
  scene = new THREE.Scene();
  scene.background = new THREE.Color(0xf0f0f0);

  // Set up camera
  camera = new THREE.PerspectiveCamera(45, width / height, 0.1, 1000);
  camera.position.set(0, 1, 3);
  camera.lookAt(0, 1, 0);

  // Set up renderer
  renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setSize(width, height);
  renderer.setPixelRatio(window.devicePixelRatio);

  // Add lighting
  const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
  scene.add(ambientLight);

  const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
  directionalLight.position.set(1, 1, 1);
  scene.add(directionalLight);

  // Add grid helper
  const gridHelper = new THREE.GridHelper(10, 10);
  scene.add(gridHelper);

  // Append renderer to DOM
  container.value.appendChild(renderer.domElement);

  // Set up controls
  controls = new OrbitControls(camera, renderer.domElement);
  controls.enableDamping = true;
  controls.dampingFactor = 0.25;
  controls.target.set(0, 1, 0);

  clock = new THREE.Clock();

  loadModel();
};

const useFallbackModel = ref(false);

// Update the loadModel function
const loadModel = () => {
  // Clear previous error
  modelLoadError.value = "";

  console.log("Attempting to load model from path:", props.modelPath);

  // Check if model path is empty or undefined
  if (!props.modelPath) {
    console.error("Model path is empty");
    modelLoadError.value = "Model path is empty";
    createFallbackModel();
    return;
  }

  const loader = new GLTFLoader();

  // Detect model type based on extension
  if (props.modelPath.toLowerCase().endsWith(".vrm")) {
    isVRMModel.value = true;

    // Register the VRM plugin with the loader
    loader.register((parser) => {
      return new VRMLoaderPlugin(parser);
    });
  } else {
    isMixamoModel.value = true;
  }

  // Load the model
  try {
    loader.load(
      props.modelPath,
      (gltf) => {
        try {
          if (isVRMModel.value) {
            // The VRM model is now available in gltf.userData.vrm
            vrm = gltf.userData.vrm;

            if (vrm) {
              model = vrm.scene;
              console.log("VRM model loaded successfully");
              logAllBones();
            } else {
              console.warn(
                "Loaded file is not a valid VRM model, treating as standard glTF"
              );
              isMixamoModel.value = true;
              isVRMModel.value = false;
              model = gltf.scene;
            }
          } else {
            // Standard GLTF/GLB model (likely Mixamo)
            model = gltf.scene;
            console.log("Standard GLTF model loaded successfully");

            // Find and log all bones
            model.traverse((node) => {
              if (node.isBone) {
                console.log("Found bone:", node.name);
              }
            });
          }

          if (!model) {
            throw new Error("Failed to initialize model from loaded data");
          }

          // Set up the model
          model.scale.set(props.scale, props.scale, props.scale);
          scene.add(model);

          // Center the model
          const box = new THREE.Box3().setFromObject(model);
          const center = box.getCenter(new THREE.Vector3());
          model.position.x = -center.x;
          model.position.z = -center.z;

          animate();
        } catch (innerError) {
          console.error("Error processing loaded model:", innerError);
          modelLoadError.value = `Error processing loaded model: ${innerError.message}`;
          createFallbackModel();
        }
      },
      (xhr) => {
        // Progress callback
        console.log(`${(xhr.loaded / xhr.total) * 100}% loaded`);
      },
      (error) => {
        // Error callback
        console.error("Error loading model:", error);
        modelLoadError.value = `Failed to load model: ${error.message}`;
        createFallbackModel();
      }
    );
  } catch (error) {
    console.error("Exception during model loading setup:", error);
    modelLoadError.value = `Exception during model loading: ${error.message}`;
    createFallbackModel();
  }
};

// Create a simple fallback model for testing
const createFallbackModel = () => {
  console.log("Creating fallback test model");
  useFallbackModel.value = true;

  try {
    // Create a simple humanoid model using basic geometry
    const geometry = new THREE.BoxGeometry(0.5, 1, 0.2);
    const material = new THREE.MeshStandardMaterial({ color: 0x2194ce });

    // Create torso
    const torso = new THREE.Mesh(geometry, material);
    model = torso;

    // Add head
    const head = new THREE.Mesh(
      new THREE.SphereGeometry(0.25, 16, 16),
      new THREE.MeshStandardMaterial({ color: 0xffccaa })
    );
    head.position.y = 0.7;
    head.name = "Head";
    head.userData.isTestBone = true;
    torso.add(head);

    // Left arm
    const leftArm = new THREE.Mesh(
      new THREE.BoxGeometry(0.1, 0.5, 0.1),
      new THREE.MeshStandardMaterial({ color: 0xff0000 })
    );
    leftArm.position.set(0.35, 0.3, 0);
    leftArm.name = "LeftArm";
    leftArm.userData.isTestBone = true;
    torso.add(leftArm);

    // Right arm
    const rightArm = new THREE.Mesh(
      new THREE.BoxGeometry(0.1, 0.5, 0.1),
      new THREE.MeshStandardMaterial({ color: 0x00ff00 })
    );
    rightArm.position.set(-0.35, 0.3, 0);
    rightArm.name = "RightArm";
    rightArm.userData.isTestBone = true;
    torso.add(rightArm);

    // Left leg
    const leftLeg = new THREE.Mesh(
      new THREE.BoxGeometry(0.12, 0.6, 0.12),
      new THREE.MeshStandardMaterial({ color: 0x0000ff })
    );
    leftLeg.position.set(0.2, -0.8, 0);
    leftLeg.name = "LeftLeg";
    leftLeg.userData.isTestBone = true;
    torso.add(leftLeg);

    // Right leg
    const rightLeg = new THREE.Mesh(
      new THREE.BoxGeometry(0.12, 0.6, 0.12),
      new THREE.MeshStandardMaterial({ color: 0x0000ff })
    );
    rightLeg.position.set(-0.2, -0.8, 0);
    rightLeg.name = "RightLeg";
    rightLeg.userData.isTestBone = true;
    torso.add(rightLeg);

    // Add model to scene
    model.scale.set(props.scale, props.scale, props.scale);
    scene.add(model);

    animate();
    console.log("Fallback model created and added to scene");
  } catch (error) {
    console.error("Error creating fallback model:", error);
    modelLoadError.value += " - Failed to create fallback model";
  }
};

// Update findBoneInModel to handle fallback model
const findBoneInModel = (boneName) => {
  if (!model) return null;

  if (useFallbackModel.value) {
    // Map pose bones to our simple test model
    let testBone = null;

    if (boneName === "head") {
      testBone = model.getObjectByName("Head");
    } else if (boneName === "leftUpperArm" || boneName === "leftLowerArm") {
      testBone = model.getObjectByName("LeftArm");
    } else if (boneName === "rightUpperArm" || boneName === "rightLowerArm") {
      testBone = model.getObjectByName("RightArm");
    } else if (boneName === "leftUpperLeg" || boneName === "leftLowerLeg") {
      testBone = model.getObjectByName("LeftLeg");
    } else if (boneName === "rightUpperLeg" || boneName === "rightLowerLeg") {
      testBone = model.getObjectByName("RightLeg");
    }

    return testBone;
  } else if (isVRMModel.value && vrm && vrm.humanoid) {
    return vrm.humanoid.getNormalizedBoneNode(vrmBoneMap[boneName]);
  } else if (isMixamoModel.value) {
    let foundBone = null;

    // Find bone in Mixamo model
    const mixamoBoneName = mixamoBoneMap[boneName];
    if (mixamoBoneName) {
      model.traverse((node) => {
        if (node.name === mixamoBoneName) {
          foundBone = node;
        }
      });
    }

    return foundBone;
  }

  return null;
};

// Animation loop
const animate = () => {
  animationId = requestAnimationFrame(animate);

  const poseData = mediapipeResults.value;
  if (poseData && poseData.poseLandmarks?.length) {
    // Only log every 30 frames to avoid console spam
    if (Math.floor(Date.now() / 1000) % 3 === 0) {
      console.log("Landmark count:", poseData.poseLandmarks.length);
      // Log a few key landmarks for debugging
      const keyPoints = [0, 11, 12, 23, 24]; // nose, shoulders, hips
      console.log(
        "Key landmarks:",
        keyPoints.map((i) => poseData.poseLandmarks[i])
      );
    }

    updatePose(poseData.poseLandmarks);

    // Apply interpolated rotations to bones
    Object.entries(targetRotations.value).forEach(
      ([boneName, targetQuat]: [string, any]) => {
        const currentQuat = currentRotations.value[boneName];
        if (!currentQuat) return;

        // Interpolate towards target rotation
        currentQuat.slerp(targetQuat, interpolationSpeed.value);

        // Find and update the bone
        const bone = findBoneInModel(boneName);
        if (bone) {
          bone.quaternion.copy(currentQuat);

          // Special handling for VRM model
          if (isVRMModel.value && vrm) {
            // Force the VRM update to apply the rotation
            vrm.update(0);
          }
        }
      }
    );
  }

  if (vrm) {
    vrm.update(clock.getDelta());
  }

  controls.update();
  renderer.render(scene, camera);
};

// Update the pose based on MediaPipe landmarks
const updatePose = (poseLandmarks) => {
  try {
    // Calculate target bone rotations from pose landmarks
    const boneRotations = poseMapper.calculateBoneRotations(poseLandmarks);

    // Log a sample rotation for debugging
    if (Math.floor(Date.now() / 1000) % 5 === 0) {
      const sampleBone = "rightUpperArm";
      if (boneRotations[sampleBone]) {
        console.log(`${sampleBone} rotation:`, boneRotations[sampleBone]);
      }
    }

    // Update target rotations
    Object.entries(boneRotations).forEach(
      ([boneName, rotation]: [string, any]) => {
        if (!targetRotations.value[boneName]) {
          targetRotations.value[boneName] = new THREE.Quaternion().copy(
            rotation
          );
        } else {
          targetRotations.value[boneName].copy(rotation);
        }

        // Initialize current rotation if needed
        if (!currentRotations.value[boneName]) {
          currentRotations.value[boneName] = new THREE.Quaternion().copy(
            rotation
          );
        }
      }
    );
  } catch (error) {
    console.error("Error calculating pose rotations:", error);
  }
};

// Legacy function that directly applies rotations (no interpolation)
const updateVRMPose = (poseLandmarks) => {
  if (!vrm || !vrm.humanoid) return;

  // Calculate bone rotations from pose landmarks
  const boneRotations = poseMapper.calculateBoneRotations(poseLandmarks);

  // Apply rotations to VRM model bones
  Object.entries(boneRotations).forEach(
    ([boneName, rotation]: [string, any]) => {
      const boneNode = vrm.humanoid.getBoneNode(boneName);
      if (boneNode) {
        boneNode.quaternion.copy(rotation);
      }
    }
  );
};

// Handle window resize
const handleResize = () => {
  if (!container.value || !camera || !renderer) return;

  const width = container.value.clientWidth;
  const height = container.value.clientHeight;

  camera.aspect = width / height;
  camera.updateProjectionMatrix();
  renderer.setSize(width, height);
};

// Debug functions
const logBoneInfo = () => {
  if (!debugBoneName.value) return;

  const bone = findBoneInModel(debugBoneName.value);

  console.log("Selected bone:", debugBoneName.value);
  console.log("Bone exists:", !!bone);

  if (bone) {
    console.log("Bone position:", bone.position);
    console.log("Bone rotation:", bone.rotation);
    console.log("Bone quaternion:", bone.quaternion);
  }
};

// Log all available bones in the model
const logAllBones = () => {
  if (isVRMModel.value && vrm && vrm.humanoid) {
    console.log("Available VRM bones:");
    for (const [boneName, bone] of Object.entries(vrm.humanoid.humanBones)) {
      console.log(`${boneName}: ${(bone as any).node.name}`);
    }
  } else if (model) {
    console.log("Model bones:");
    model.traverse((node) => {
      if (node.isBone) {
        console.log(node.name);
      }
    });
  }
};

// Reset pose to default
const calibratePose = () => {
  if (isVRMModel.value && vrm) {
    console.log("Calibrating VRM pose...");
    Object.values(vrmBoneMap).forEach((boneName) => {
      const bone = vrm.humanoid.getNormalizedBoneNode(boneName);
      if (bone) {
        bone.quaternion.identity();
      }
    });
  } else if (isMixamoModel.value && model) {
    console.log("Calibrating standard model pose...");
    model.traverse((node) => {
      if (node.isBone) {
        node.quaternion.identity();
      }
    });
  }

  // Reset all rotation trackers
  currentRotations.value = {};
  targetRotations.value = {};
};

// Component lifecycle hooks
onMounted(async () => {
  // Initialize MediaPipe pose detection
  if (canvas.value && source.value) {
    await new PoseService(
      canvas.value,
      source.value,
      videoWidth.value,
      videoHeight.value,
      document.createElement("div"), // Placeholder for landmark container
      loadingCanvas,
      mediapipeResults
    ).setOptions({
      modelComplexity: 1,
      smoothLandmarks: true,
      minDetectionConfidence: 0.6, // Increased from 0.5
      minTrackingConfidence: 0.6, // Increased from 0.5
      enableSegmentation: false, // Disable unnecessary features for performance
    });
  }

  // Initialize Three.js scene
  initScene();

  // Add resize event listener
  window.addEventListener("resize", handleResize);

  // Add a delay to check model bones after loading
  setTimeout(() => {
    logAllBones();
  }, 3000);
});

onBeforeUnmount(() => {
  window.removeEventListener("resize", handleResize);
  if (animationId) cancelAnimationFrame(animationId);

  if (scene) scene.clear();
  if (renderer) renderer.dispose();

  // Dispose VRM resources
  if (vrm) {
    vrm.dispose();
  }
});
</script>

<style scoped>
.pose-avatar-container {
  display: flex;
  flex-direction: row;
  gap: 20px;
  width: 100%;
  height: 600px;
}

.video-section {
  flex: 1;
  position: relative;
  max-width: 400px;
}

.model-section {
  flex: 2;
}

.input_video {
  width: 100%;
  height: auto;
}

.output_canvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: auto;
}

.loading_canvas {
  background: url("https://media.giphy.com/media/8agqybiK5LW8qrG3vJ/giphy.gif")
    center no-repeat;
}

.three-container {
  width: 100%;
  height: 100%;
}

.debug-panel {
  position: fixed;
  bottom: 10px;
  right: 10px;
  background-color: rgba(0, 0, 0, 0.7);
  color: white;
  padding: 10px;
  border-radius: 4px;
  font-family: monospace;
  z-index: 1000;
  max-width: 300px;
}

.debug-panel button,
.debug-panel select {
  margin: 5px;
  padding: 3px 8px;
}

@media (max-width: 768px) {
  .pose-avatar-container {
    flex-direction: column;
    height: auto;
  }

  .video-section,
  .model-section {
    width: 100%;
    max-width: none;
  }

  .three-container {
    height: 400px;
  }
}

.error-message {
  color: #ff3333;
  background-color: #ffeeee;
  padding: 10px;
  border-radius: 4px;
  margin-top: 10px;
  font-family: monospace;
}
</style>
