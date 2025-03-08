<template>
  <div class="avatar-mirror">
    <h1>3D Avatar Mirror Demo</h1>
    <p>
      Stand in front of the camera to control the 3D avatar with your movements
    </p>

    <!-- Add model selector -->
    <div class="model-selector">
      <label>
        <input
          type="radio"
          v-model="selectedModel"
          value="vrm"
        />
        VRM Model
      </label>
      <label>
        <input
          type="radio"
          v-model="selectedModel"
          value="mixamo"
        />
        Mixamo Model
      </label>
      <label>
        <input
          type="radio"
          v-model="selectedModel"
          value="readyplayerme"
        />
        ReadyPlayerMe Avatar
      </label>
    </div>

    <WidgetsThreeMediapipePuppet
      :modelPath="modelPath"
      :scale="1.5"
      :showVideo="true"
    />

    <div class="info-section">
      <h2>How it works</h2>
      <p>
        This demo uses MediaPipe Pose to track your movements and maps them to a
        3D avatar in real-time.
      </p>
      <p>
        Try moving your arms, legs, and head to see the avatar mimic your
        actions.
      </p>
      <p><strong>Current model:</strong> {{ modelPath }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
// Available model paths - update these with your actual model paths
const models = {
  vrm: "/models/model.vrm",
  mixamo: "/models/male.glb",
  // readyplayerme: "https://models.readyplayer.me/65c3d52cd96586c9fa5f5cdc.glb"
};

const selectedModel = ref("vrm");
const modelPath = ref(models.vrm);

// Update model path when selection changes
watch(selectedModel, (newValue) => {
  modelPath.value = models[newValue] || models.vrm;
});
</script>

<style scoped>
.avatar-mirror {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

h1 {
  text-align: center;
  margin-bottom: 20px;
}

.info-section {
  margin-top: 40px;
  background-color: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
}

.model-selector {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.model-selector label {
  margin: 0 10px;
  cursor: pointer;
}
</style>
