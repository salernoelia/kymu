<template>
  <div class="video-effects">
    <h3>Video Effects</h3>
    <div
      v-if="selectedClip"
      class="effects-container"
    >
      <div
        class="effect-item"
        @click="applyEffect('brightness')"
      >
        <span>Brightness</span>
      </div>
      <div
        class="effect-item"
        @click="applyEffect('contrast')"
      >
        <span>Contrast</span>
      </div>
      <div
        class="effect-item"
        @click="applyEffect('rotate')"
      >
        <span>Rotate</span>
      </div>
      <div
        class="effect-item"
        @click="applyEffect('speed')"
      >
        <span>Speed</span>
      </div>
    </div>
    <div
      v-else
      class="no-clip-selected"
    >
      Select a clip to apply effects
    </div>

    <div
      v-if="showEffectSettings"
      class="effect-settings"
    >
      <h4>{{ currentEffectType }} Settings</h4>

      <div
        v-if="currentEffectType === 'brightness'"
        class="setting"
      >
        <label>Brightness</label>
        <input
          type="range"
          min="-100"
          max="100"
          v-model.number="effectSettings.value"
        />
        <span>{{ effectSettings.value }}%</span>
      </div>

      <div
        v-if="currentEffectType === 'contrast'"
        class="setting"
      >
        <label>Contrast</label>
        <input
          type="range"
          min="-100"
          max="100"
          v-model.number="effectSettings.value"
        />
        <span>{{ effectSettings.value }}%</span>
      </div>

      <div
        v-if="currentEffectType === 'rotate'"
        class="setting"
      >
        <label>Rotation</label>
        <select v-model.number="effectSettings.value">
          <option :value="90">90°</option>
          <option :value="180">180°</option>
          <option :value="270">270°</option>
        </select>
      </div>

      <div
        v-if="currentEffectType === 'speed'"
        class="setting"
      >
        <label>Playback Speed</label>
        <input
          type="range"
          min="0.25"
          max="2"
          step="0.25"
          v-model.number="effectSettings.value"
        />
        <span>{{ effectSettings.value }}x</span>
      </div>

      <div class="effect-actions">
        <button @click="saveEffect">Apply</button>
        <button @click="cancelEffect">Cancel</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { VideoClip, VideoEffect } from "~/shared/types/video";

const props = defineProps<{
  selectedClip: VideoClip | null;
}>();

const emit = defineEmits<{
  "effect-applied": [clipId: string, effect: VideoEffect];
}>();

const showEffectSettings = ref(false);
const currentEffectType = ref("");
const effectSettings = ref({ value: 0 });

const applyEffect = (effectType: string) => {
  showEffectSettings.value = true;
  currentEffectType.value = effectType;

  // Initialize settings based on effect type
  switch (effectType) {
    case "brightness":
    case "contrast":
      effectSettings.value = { value: 0 };
      break;
    case "rotate":
      effectSettings.value = { value: 90 };
      break;
    case "speed":
      effectSettings.value = { value: 1 };
      break;
  }
};

const saveEffect = () => {
  if (!props.selectedClip) return;

  const effect: VideoEffect = {
    id: Date.now().toString(),
    type: currentEffectType.value,
    params: { value: effectSettings.value.value },
  };

  emit("effect-applied", props.selectedClip.id, effect);
  showEffectSettings.value = false;
};

const cancelEffect = () => {
  showEffectSettings.value = false;
};
</script>

<style scoped>
.video-effects {
  width: 100%;
  padding: 10px;
  background-color: #f5f5f5;
}

.effects-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
  gap: 10px;
  margin-top: 10px;
}

.effect-item {
  padding: 10px;
  background-color: #e0e0e0;
  border-radius: 4px;
  text-align: center;
  cursor: pointer;
}

.effect-item:hover {
  background-color: #d0d0d0;
}

.no-clip-selected {
  margin-top: 10px;
  font-style: italic;
  color: #666;
}

.effect-settings {
  margin-top: 20px;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.setting {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 10px 0;
}

.setting label {
  width: 100px;
}

.setting input[type="range"] {
  flex: 1;
}

.effect-actions {
  display: flex;
  gap: 10px;
  margin-top: 15px;
}
</style>
