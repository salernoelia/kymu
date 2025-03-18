<template>
  <div class="pose-page">
    <h1>3D Pose Editor</h1>
    <p class="description">
      Adjust joint rotations to create custom poses. Use the group tabs to
      navigate between different joint sets.
    </p>

    <ThreeModelEditor
      modelPath="/models/OVRBodyFromPoseThumbsDown.glb"
      :scale="2"
      @pose-updated="handlePoseUpdate"
    />
  </div>
</template>

<script setup lang="ts">
const handlePoseUpdate = (pose: any) => {
  console.log("Pose updated:", pose);
};
</script>

<style scoped>
.pose-page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

h1 {
  margin-bottom: 10px;
}

.description {
  margin-bottom: 20px;
  color: #666;
}
</style>
