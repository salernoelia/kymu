<template>
  <div>
    <div
      class="three-container"
      ref="container"
    ></div>
  </div>
</template>

<script setup lang="ts">
import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls.js";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader.js";

const container = ref<HTMLDivElement>();

let camera: THREE.OrthographicCamera;
let scene: THREE.Scene;
let renderer: THREE.WebGLRenderer;
let cube: THREE.Mesh;
let controls: OrbitControls;
let animationId: number;
let model: THREE.Object3D;

const loadModel = () => {
  const loader = new GLTFLoader();
  loader.load(
    "/models/male.glb",
    (gltf: GLTFLoader) => {
      model = gltf.scene;

      const box = new THREE.Box3().setFromObject(model);
      const center = box.getCenter(new THREE.Vector3());
      model.position.sub(center);

      model.scale.set(0.05, 0.05, 0.05);
      box.setFromObject(model);
      const size = box.getSize(new THREE.Vector3());
      model.position.y = 0 - size.y / 2;
      model.position.x = 0;
      model.position.z = 0;

      scene.add(model);
    },
    (xhr: any) => {
      console.log((xhr.loaded / xhr.total) * 100 + "% loaded");
    },
    (error: any) => {
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

  loadModel();
  animate();
};

const animate = () => {
  animationId = requestAnimationFrame(animate);

  if (cube) {
    cube.rotation.x += 0.01;
    cube.rotation.y += 0.005;
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

onMounted(() => {
  if (container.value) {
    // container.value.style.width = "100%";
    // container.value.style.height = "400px";

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
</style>
