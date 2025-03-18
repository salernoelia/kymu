<template>
  <div style="height: 500px; position: absolute">
    <div
      class="three-container"
      ref="container"
    ></div>
    <div
      v-if="isLoaded"
      class="pose-editor-controls"
    >
      <div class="actions">
        <button
          @click="resetPose"
          class="control-button"
        >
          Reset Pose
        </button>
        <button
          @click="showExportDialog = true"
          class="control-button"
        >
          Export Pose
        </button>
        <button
          @click="showImportDialog = true"
          class="control-button"
        >
          Import Pose
        </button>
      </div>

      <div class="joint-groups">
        <button
          v-for="group in jointGroups"
          :key="group.name"
          :class="['group-button', { active: selectedGroup === group.name }]"
          @click="selectedGroup = group.name"
        >
          {{ group.name }}
        </button>
      </div>

      <div class="joint-sliders">
        <div
          v-if="selectedGroup"
          class="joint-group-container"
        >
          <div
            v-for="joint in getSelectedGroupJoints"
            :key="joint.fullPath"
            class="joint-control"
          >
            <div class="joint-name">{{ joint.name }}</div>
            <div class="axis-sliders">
              <div class="axis-slider">
                <label>X</label>
                <input
                  type="range"
                  :min="joint.min.x"
                  :max="joint.max.x"
                  v-model.number="joint.rotation.x"
                  @input="
                    updateJointRotation(joint.fullPath, 'x', joint.rotation.x)
                  "
                />
                <span class="value">{{ Math.round(joint.rotation.x) }}°</span>
              </div>
              <div class="axis-slider">
                <label>Y</label>
                <input
                  type="range"
                  :min="joint.min.y"
                  :max="joint.max.y"
                  v-model.number="joint.rotation.y"
                  @input="
                    updateJointRotation(joint.fullPath, 'y', joint.rotation.y)
                  "
                />
                <span class="value">{{ Math.round(joint.rotation.y) }}°</span>
              </div>
              <div class="axis-slider">
                <label>Z</label>
                <input
                  type="range"
                  :min="joint.min.z"
                  :max="joint.max.z"
                  v-model.number="joint.rotation.z"
                  @input="
                    updateJointRotation(joint.fullPath, 'z', joint.rotation.z)
                  "
                />
                <span class="value">{{ Math.round(joint.rotation.z) }}°</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Export Dialog -->
    <div
      v-if="showExportDialog"
      class="dialog-overlay"
    >
      <div class="dialog">
        <h3>Export Pose</h3>
        <textarea
          v-model="exportedPose"
          rows="10"
          readonly
        ></textarea>
        <div class="dialog-actions">
          <button
            @click="copyToClipboard"
            class="control-button"
          >
            Copy to Clipboard
          </button>
          <button
            @click="showExportDialog = false"
            class="control-button"
          >
            Close
          </button>
        </div>
      </div>
    </div>

    <!-- Import Dialog -->
    <div
      v-if="showImportDialog"
      class="dialog-overlay"
    >
      <div class="dialog">
        <h3>Import Pose</h3>
        <textarea
          v-model="importPoseData"
          rows="10"
          placeholder="Paste pose JSON data here..."
        ></textarea>
        <div class="dialog-actions">
          <button
            @click="importPoseFromData"
            class="control-button"
          >
            Import
          </button>
          <button
            @click="showImportDialog = false"
            class="control-button"
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls.js";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader.js";
import { ref, watch, onMounted, onBeforeUnmount, computed } from "vue";
import { usePoseEditor } from "~/composables/usePoseEditor";

const props = defineProps({
  modelPath: {
    type: String,
    required: true,
  },
  scale: {
    type: Number,
    default: 1,
  },
});

const emit = defineEmits(["poseUpdated"]);

const container = ref<HTMLDivElement>();
const showExportDialog = ref(false);
const showImportDialog = ref(false);
const exportedPose = ref("");
const importPoseData = ref("");

// Use the pose editor composable
const {
  isLoaded,
  jointGroups,
  selectedGroup,
  initializeModel,
  updateJointRotation,
  resetPose,
  exportPose,
  importPose,
} = usePoseEditor();

const getSelectedGroupJoints = computed(() => {
  const group = jointGroups.find((g) => g.name === selectedGroup.value);
  return group ? group.joints : [];
});

let camera: THREE.OrthographicCamera;
let scene: THREE.Scene;
let renderer: THREE.WebGLRenderer;
let controls: OrbitControls;
let animationId: number;
let model: THREE.Object3D;
let clock: THREE.Clock;

const loadModel = () => {
  const loader = new GLTFLoader();
  loader.load(
    props.modelPath,
    (gltf) => {
      model = gltf.scene;

      const box = new THREE.Box3().setFromObject(model);
      const center = box.getCenter(new THREE.Vector3());
      model.position.sub(center);

      model.scale.set(props.scale, props.scale, props.scale);
      box.setFromObject(model);
      const size = box.getSize(new THREE.Vector3());
      model.position.y = 0 - size.y / 2;
      model.position.x = 0;
      model.position.z = 0;

      scene.add(model);

      // Initialize the pose editor with the loaded model
      initializeModel(model);
    },
    (xhr) => {
      console.log((xhr.loaded / xhr.total) * 100 + "% loaded");
    },
    (error) => {
      console.error("Error loading model", error);
    }
  );
};

const initScene = () => {
  const width = container.value?.clientWidth || window.innerWidth / 2;
  const height = container.value?.clientHeight || window.innerHeight / 2;
  const aspect = width / height;

  const frustumSize = 10;
  camera = new THREE.OrthographicCamera(
    (frustumSize * aspect) / -2,
    (frustumSize * aspect) / 2,
    frustumSize / 2,
    frustumSize / -2,
    0.1,
    1000
  );
  camera.position.set(5, 5, 5);
  camera.lookAt(0, 0, 0);

  scene = new THREE.Scene();
  scene.background = new THREE.Color(0xffffff);

  const ambientLight = new THREE.AmbientLight(0x404040);
  scene.add(ambientLight);

  const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
  directionalLight.position.set(1, 1, 1);
  scene.add(directionalLight);

  const gridHelper = new THREE.GridHelper(10, 10);
  scene.add(gridHelper);

  renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setSize(width, height);
  renderer.setPixelRatio(window.devicePixelRatio);

  if (container.value) {
    container.value.innerHTML = "";
    container.value.appendChild(renderer.domElement);
  }

  controls = new OrbitControls(camera, renderer.domElement);
  controls.enableDamping = true;
  controls.dampingFactor = 0.25;
  controls.enableZoom = true;

  clock = new THREE.Clock();

  loadModel();
  animate();
};

const animate = () => {
  animationId = requestAnimationFrame(animate);
  controls.update();
  renderer.render(scene, camera);
};

const handleResize = () => {
  if (!container.value) return;

  const width = container.value.clientWidth;
  const height = container.value.clientHeight;
  const aspect = width / height;

  const frustumSize = 10;
  camera.left = (-frustumSize * aspect) / 2;
  camera.right = (frustumSize * aspect) / 2;
  camera.top = frustumSize / 2;
  camera.bottom = -frustumSize / 2;
  camera.updateProjectionMatrix();

  renderer.setSize(width, height);
};

const copyToClipboard = () => {
  navigator.clipboard
    .writeText(exportedPose.value)
    .then(() => alert("Pose copied to clipboard"))
    .catch((err) => console.error("Failed to copy pose: ", err));
};

const importPoseFromData = () => {
  if (importPoseData.value) {
    importPose(importPoseData.value);
    showImportDialog.value = false;
  }
};

// Generate and set the exported pose when dialog is opened
watch(showExportDialog, (value) => {
  if (value) {
    exportedPose.value = exportPose();
  }
});

onMounted(() => {
  if (container.value) {
    initScene();
    window.addEventListener("resize", handleResize);
  }
});

onBeforeUnmount(() => {
  window.removeEventListener("resize", handleResize);
  if (animationId) cancelAnimationFrame(animationId);

  scene.clear();
  renderer?.dispose();
});
</script>

<style scoped>
.three-container {
  width: 100%;
  height: 400px;
  margin: 0 auto;
}

.pose-editor-controls {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-top: 20px;
  padding: 15px;
  background-color: #f5f5f5;
  border-radius: 8px;
}

.actions {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
}

.control-button {
  padding: 8px 12px;
  background-color: #000000;
  color: white;
  border: 1px solid #000000;
  border-radius: 4px;
  cursor: pointer;
  min-width: 80px;
}

.control-button:hover {
  background-color: #333;
}

.joint-groups {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 15px;
}

.group-button {
  padding: 6px 12px;
  background-color: #eaeaea;
  border: 1px solid #ccc;
  border-radius: 4px;
  cursor: pointer;
}

.group-button.active {
  background-color: #000;
  color: white;
}

.joint-sliders {
  max-height: 400px;
  overflow-y: auto;
  padding-right: 10px;
}

.joint-control {
  margin-bottom: 12px;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background-color: white;
}

.joint-name {
  font-weight: bold;
  margin-bottom: 8px;
}

.axis-sliders {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.axis-slider {
  display: flex;
  align-items: center;
  gap: 10px;
}

.axis-slider label {
  font-weight: bold;
  width: 20px;
}

.axis-slider input {
  flex: 1;
}

.value {
  width: 50px;
  text-align: right;
}

.dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 100;
}

.dialog {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  width: 80%;
  max-width: 600px;
  max-height: 80vh;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.dialog h3 {
  margin-top: 0;
}

.dialog textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-family: monospace;
}

.dialog-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>
