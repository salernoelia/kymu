<template>
  <div>
    <div
      class="three-container"
      ref="container"
    ></div>
    <div
      v-if="hasAnimations"
      class="animation-controls"
    >
      <select
        v-model="currentAnimationName"
        class="animation-select"
        @change="emit('exerciseVariant', currentAnimationName)"
      >
        <option
          v-for="name in animationNames"
          :key="name"
          :value="name"
        >
          {{ name }}
        </option>
      </select>
      <button
        @click="togglePlay"
        class="control-button"
      >
        {{ isPlaying ? "Pause" : "Play" }}
      </button>
      <input
        v-if="isPlaying"
        type="range"
        min="0"
        max="2"
        step="0.01"
        v-model="playbackSpeed"
        class="speed-slider"
      />
      <span
        v-if="isPlaying"
        class="speed-label"
        >{{ playbackSpeed }}x</span
      >
    </div>
  </div>
</template>

<script setup lang="ts">
import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls.js";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader.js";
import { ref, watch, onMounted, onBeforeUnmount } from "vue";

const props = defineProps({
  modelPath: {
    type: String,
    required: true,
  },
  scale: {
    type: Number,
    default: 1,
  },
  autoPlayAnimation: {
    type: Boolean,
    default: false,
  },
  defaultAnimationName: {
    type: String,
    default: "",
  },
  defaultPlaybackSpeed: {
    type: Number,
    default: 1.0,
  },
  loop: {
    type: Boolean,
    default: true,
  },
});

const emit = defineEmits([
  "animationLoaded",
  "animationStarted",
  "animationEnded",
  "exerciseVariant",
]);

const container = ref<HTMLDivElement>();
const animationNames = ref<string[]>([]);
const currentAnimationName = ref("");
const isPlaying = ref(false);
const playbackSpeed = ref(props.defaultPlaybackSpeed);
const hasAnimations = ref(false);

let camera: THREE.OrthographicCamera;
let scene: THREE.Scene;
let renderer: THREE.WebGLRenderer;
let controls: OrbitControls;
let animationId: number;
let model: THREE.Object3D;
let mixer: THREE.AnimationMixer;
let animations: THREE.AnimationClip[] = [];
let currentAction: THREE.AnimationAction | null = null;
let clock: THREE.Clock;

const loadModel = () => {
  const loader = new GLTFLoader();
  loader.load(
    props.modelPath,
    (gltf) => {
      model = gltf.scene;
      animations = gltf.animations || [];

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

      if (animations.length > 0) {
        hasAnimations.value = true;
        mixer = new THREE.AnimationMixer(model);

        animationNames.value = animations.map((clip) => clip.name);
        emit("animationLoaded", animationNames.value);

        if (props.autoPlayAnimation) {
          if (
            props.defaultAnimationName &&
            animationNames.value.includes(props.defaultAnimationName)
          ) {
            currentAnimationName.value = props.defaultAnimationName;
          } else if (
            animations.length > 0 &&
            typeof animationNames.value[0] === "string"
          ) {
            currentAnimationName.value = animationNames.value[0];
          }

          if (currentAnimationName.value) {
            isPlaying.value = true;
            playAnimation(currentAnimationName.value);
          }
        }
      }
    },
    (xhr) => {
      console.log((xhr.loaded / xhr.total) * 100 + "% loaded");
    },
    (error) => {
      console.error("Error loading model", error);
    }
  );
};

const playAnimation = (name: string) => {
  if (!mixer || !animations.length) return;

  const clip = animations.find((anim) => anim.name === name);
  if (!clip) return;

  if (currentAction) {
    currentAction.fadeOut(0.5);
  }

  currentAction = mixer.clipAction(clip);
  currentAction.setEffectiveTimeScale(playbackSpeed.value);
  currentAction.setLoop(
    props.loop ? THREE.LoopRepeat : THREE.LoopOnce,
    Infinity
  );
  currentAction.clampWhenFinished = !props.loop;
  currentAction.fadeIn(0.5);
  currentAction.play();

  emit("animationStarted", name);
};

const togglePlay = () => {
  isPlaying.value = !isPlaying.value;

  if (isPlaying.value) {
    if (currentAction) {
      currentAction.paused = false;
    } else if (currentAnimationName.value) {
      playAnimation(currentAnimationName.value);
    }
  } else if (currentAction) {
    currentAction.paused = true;
  }
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

  // if (cube) {
  //   cube.rotation.x += 0.01;
  //   cube.rotation.y += 0.005;
  // }

  if (mixer && isPlaying.value) {
    const delta = clock.getDelta();
    mixer.update(delta);
  }

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

watch(currentAnimationName, (newName) => {
  if (newName && isPlaying.value) {
    playAnimation(newName);
  } else if (!newName && currentAction) {
    currentAction.fadeOut(0.5);
    currentAction = null;
  }
});

watch(playbackSpeed, (newSpeed) => {
  if (currentAction) {
    currentAction.setEffectiveTimeScale(newSpeed);
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

  if (mixer) {
    mixer.stopAllAction();
  }
});
</script>

<style scoped>
.three-container {
  width: 100%;
  height: 400px;
  margin: 0 auto;
}

.animation-controls {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 10px;
  margin-top: 10px;
  padding: 5px;
  background-color: #f5f5f5;
  border-radius: 4px;
}

.animation-select {
  padding: 5px;
  width: 150px;
  border-radius: 4px;
  border: 1px solid #ccc;
}

.control-button {
  padding: 5px 10px;
  background-color: #000000;
  color: white;

  border: 1px solid #000000;
  border-radius: 4px;
  cursor: pointer;
  min-width: 80px;
}

.speed-slider {
  flex: 1;
  max-width: 150px;
}

.speed-label {
  min-width: 30px;
  text-align: center;
}
</style>
