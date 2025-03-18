<template>
  <div class="joint-debugger">
    <h3>Joint Debugger</h3>
    <div class="search-bar">
      <input
        type="text"
        v-model="searchQuery"
        placeholder="Search for joint..."
        class="search-input"
      />
    </div>

    <div class="joint-list">
      <div
        v-for="(joint, path) in filteredJoints"
        :key="path"
        class="joint-item"
      >
        <div class="joint-name">{{ path }}</div>
        <div class="joint-angles">
          <span>X: {{ Math.round(radToDeg(joint.rotation.x)) }}°</span>
          <span>Y: {{ Math.round(radToDeg(joint.rotation.y)) }}°</span>
          <span>Z: {{ Math.round(radToDeg(joint.rotation.z)) }}°</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue";
import * as THREE from "three";

const props = defineProps({
  jointMap: {
    type: Object,
    required: true,
  },
});

const searchQuery = ref("");

const filteredJoints = computed(() => {
  if (!props.jointMap) return {};

  const result = {};
  for (const [path, joint] of Object.entries(props.jointMap)) {
    if (path.toLowerCase().includes(searchQuery.value.toLowerCase())) {
      result[path] = joint;
    }
  }
  return result;
});

const radToDeg = (radians) => {
  return radians * (180 / Math.PI);
};
</script>

<style scoped>
.joint-debugger {
  background-color: #f5f5f5;
  border-radius: 8px;
  padding: 15px;
  margin-top: 20px;
}

h3 {
  margin-top: 0;
  margin-bottom: 15px;
}

.search-bar {
  margin-bottom: 15px;
}

.search-input {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.joint-list {
  max-height: 300px;
  overflow-y: auto;
}

.joint-item {
  padding: 8px;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.joint-name {
  font-family: monospace;
  font-size: 0.9rem;
}

.joint-angles {
  display: flex;
  gap: 10px;
  font-size: 0.8rem;
  color: #666;
}
</style>
