<template>
  <div class="therapy-builder">
    <div class="layout-container">
      <!-- Left Panel: 3D Model with Visualization -->
      <div class="model-panel">
        <div class="model-container">
          <ThreeModelEditor
            ref="modelRef"
            modelPath="/models/OVRBodyFromPoseThumbsDown.glb"
            :scale="2"
            @model-loaded="handleModelLoaded"
          />
        </div>

        <div class="visualization-controls">
          <div class="timeline-control">
            <div class="timeline-labels">
              <span>Start Position</span>
              <span>End Position</span>
            </div>
            <input
              type="range"
              min="0"
              max="100"
              v-model.number="movementProgress"
              @input="previewAtProgress"
              class="timeline-slider"
            />
          </div>

          <div class="position-actions">
            <button
              @click="captureStartPosition"
              class="position-button start-btn"
              :disabled="!currentMovement"
            >
              Capture Start Position
            </button>

            <button
              @click="captureEndPosition"
              class="position-button end-btn"
              :disabled="!currentMovement"
            >
              Capture End Position
            </button>
          </div>
        </div>
      </div>

      <!-- Right Panel: Clinical Parameters -->
      <div class="clinical-panel">
        <div
          v-if="!currentMovement"
          class="select-exercise"
        >
          <h2>Select Exercise Template</h2>

          <div class="region-filter">
            <label>Filter by Body Region:</label>
            <div class="region-buttons">
              <button
                v-for="region in bodyRegions"
                :key="region"
                class="region-btn"
                :class="{ active: selectedRegion === region }"
                @click="selectedRegion = region"
              >
                {{ region }}
              </button>
            </div>
          </div>

          <div class="exercise-grid">
            <div
              v-for="template in filteredTemplates"
              :key="template.id"
              class="exercise-card"
              @click="selectTemplate(template.id)"
            >
              <div class="exercise-card-header">
                <h3>{{ template.name }}</h3>
                <span
                  class="complexity-badge"
                  :class="template.complexity.toLowerCase()"
                >
                  {{ template.complexity }}
                </span>
              </div>
              <p class="exercise-description">{{ template.description }}</p>
              <div class="exercise-meta">
                <span class="movement-type">{{ template.movementType }}</span>
                <span class="body-region">{{ template.bodyRegion }}</span>
              </div>
            </div>

            <div
              class="exercise-card new-exercise"
              @click="showNewExerciseModal = true"
            >
              <div class="add-icon">+</div>
              <h3>Create New Exercise</h3>
            </div>
          </div>
        </div>

        <div
          v-else
          class="exercise-editor"
        >
          <div class="editor-header">
            <h2>{{ currentMovement.name }}</h2>
            <button
              class="back-btn"
              @click="backToSelection"
            >
              ← Back to Templates
            </button>
          </div>

          <div class="exercise-details">
            <div class="form-group">
              <label>Exercise Name</label>
              <input
                type="text"
                v-model="currentMovement.name"
              />
            </div>

            <div class="form-group">
              <label>Instructions</label>
              <textarea
                v-model="currentMovement.instructions"
                rows="2"
              ></textarea>
            </div>

            <div class="editor-section">
              <h3>Movement Parameters</h3>

              <div class="param-row">
                <div class="param-group">
                  <label>Complexity</label>
                  <div class="complexity-selector">
                    <button
                      v-for="level in ['Beginner', 'Intermediate', 'Advanced']"
                      :key="level"
                      :class="[
                        'complexity-btn',
                        { active: currentMovement.complexity === level },
                      ]"
                      @click="setExerciseComplexity(level)"
                    >
                      {{ level }}
                    </button>
                  </div>
                </div>
              </div>

              <div class="param-row">
                <div class="param-group range-group">
                  <label
                    >Range of Motion:
                    {{ currentMovement.rangeOfMotionPercentage }}%</label
                  >
                  <input
                    type="range"
                    min="20"
                    max="100"
                    v-model.number="currentMovement.rangeOfMotionPercentage"
                    @input="updateRangeOfMotion"
                  />
                  <div class="range-labels">
                    <span>Limited</span>
                    <span>Full Range</span>
                  </div>
                </div>
              </div>
            </div>

            <div class="editor-section">
              <h3>Prescription Details</h3>

              <div class="param-row">
                <div class="param-card">
                  <div class="param-title">Sets</div>
                  <div class="param-control">
                    <button @click="decrementSets">-</button>
                    <span>{{ currentMovement.targetSets }}</span>
                    <button @click="incrementSets">+</button>
                  </div>
                </div>

                <div class="param-card">
                  <div class="param-title">Reps</div>
                  <div class="param-control">
                    <button @click="decrementReps">-</button>
                    <span>{{ currentMovement.targetRepetitions }}</span>
                    <button @click="incrementReps">+</button>
                  </div>
                </div>
              </div>

              <div class="param-row">
                <div class="param-card">
                  <div class="param-title">Hold (sec)</div>
                  <div class="param-control">
                    <button @click="decrementHoldTime">-</button>
                    <span>{{ currentMovement.holdTime }}</span>
                    <button @click="incrementHoldTime">+</button>
                  </div>
                </div>

                <div class="param-card">
                  <div class="param-title">Rest (sec)</div>
                  <div class="param-control">
                    <button @click="decrementRestTime">-</button>
                    <span>{{ currentMovement.restTime }}</span>
                    <button @click="incrementRestTime">+</button>
                  </div>
                </div>
              </div>
            </div>

            <div class="action-buttons">
              <button
                class="preview-btn"
                @click="previewFullExercise"
              >
                Preview Exercise
              </button>
              <button
                class="save-btn"
                @click="saveExercise"
              >
                Save Exercise
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- New Exercise Modal -->
    <div
      v-if="showNewExerciseModal"
      class="modal-overlay"
    >
      <div class="modal-content">
        <h3>Create New Exercise</h3>

        <div class="form-group">
          <label>Body Region</label>
          <select v-model="newExerciseRegion">
            <option
              v-for="region in bodyRegions"
              :key="region"
              :value="region"
            >
              {{ region }}
            </option>
          </select>
        </div>

        <div class="form-group">
          <label>Movement Type</label>
          <select v-model="newExerciseMovement">
            <option
              v-for="movement in movementTypes"
              :key="movement"
              :value="movement"
            >
              {{ movement }}
            </option>
          </select>
        </div>

        <div class="modal-actions">
          <button
            @click="createNewExercise"
            class="create-btn"
          >
            Create
          </button>
          <button
            @click="showNewExerciseModal = false"
            class="cancel-btn"
          >
            Cancel
          </button>
        </div>
      </div>
    </div>

    <!-- Preview Modal -->
    <div
      v-if="showPreviewModal"
      class="modal-overlay"
    >
      <div class="preview-modal">
        <h3>Exercise Preview</h3>
        <div class="preview-info">
          <p>
            <strong>{{ currentMovement?.name }}</strong> -
            {{ currentMovement?.description }}
          </p>
          <p class="preview-instructions">
            {{ currentMovement?.instructions }}
          </p>

          <div class="preview-details">
            <div class="preview-detail">
              <strong>Sets:</strong> {{ currentMovement?.targetSets }}
            </div>
            <div class="preview-detail">
              <strong>Reps:</strong> {{ currentMovement?.targetRepetitions }}
            </div>
            <div class="preview-detail">
              <strong>Hold:</strong> {{ currentMovement?.holdTime }}s
            </div>
            <div class="preview-detail">
              <strong>Rest:</strong> {{ currentMovement?.restTime }}s
            </div>
          </div>
        </div>

        <div class="preview-timeline">
          <div class="preview-progress-bar">
            <div
              class="preview-progress"
              :style="{ width: `${previewAnimationProgress}%` }"
            ></div>
          </div>
        </div>

        <div class="preview-modal-actions">
          <button
            @click="stopPreview"
            class="stop-btn"
          >
            Stop Preview
          </button>
          <button
            @click="showPreviewModal = false"
            class="close-btn"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, onBeforeUnmount } from "vue";
import { useTherapyBuilder } from "~/composables/useTherapyBuilder";

const modelRef = ref(null);
const movementProgress = ref(0);
const selectedRegion = ref(null);
const showNewExerciseModal = ref(false);
const showPreviewModal = ref(false);
const previewAnimationProgress = ref(0);
const newExerciseRegion = ref("Shoulder");
const newExerciseMovement = ref("Flexion");
let previewInterval: number | null = null;

const {
  availableTemplates,
  currentMovement,
  bodyRegions,
  movementTypes,
  isAnimating,
  initializeJointMap,
  selectMovementTemplate,
  previewMovementProgress,
  setRangeOfMotion,
  setComplexity,
  createCustomMovement,
  captureCurrentPose,
  resetModel,
  animateMovement,
  stopAnimation,
  saveMovement,
} = useTherapyBuilder();

// Filter templates by selected body region
const filteredTemplates = computed(() => {
  if (!selectedRegion.value) return availableTemplates;
  return availableTemplates.filter(
    (t) => t.bodyRegion === selectedRegion.value
  );
});

// Handle model loaded
const handleModelLoaded = (model) => {
  initializeJointMap(model);
};

// Select a template
const selectTemplate = (templateId) => {
  selectMovementTemplate(templateId);
  // Reset progress to start position
  movementProgress.value = 0;
  previewAtProgress();
};

// Preview at current progress
const previewAtProgress = () => {
  previewMovementProgress(movementProgress.value);
};

// Update range of motion
const updateRangeOfMotion = () => {
  setRangeOfMotion(currentMovement.value.rangeOfMotionPercentage);
  previewAtProgress();
};

// Set exercise complexity
const setExerciseComplexity = (complexity) => {
  setComplexity(complexity);
};

// Capture current position
const captureStartPosition = () => {
  captureCurrentPose(true);
};

const captureEndPosition = () => {
  captureCurrentPose(false);
};

// Create a new exercise
const createNewExercise = () => {
  createCustomMovement(newExerciseRegion.value, newExerciseMovement.value);
  showNewExerciseModal.value = false;
};

// Back to template selection
const backToSelection = () => {
  currentMovement.value = null;
  resetModel();
};

// Preview the full exercise animation
const previewFullExercise = () => {
  showPreviewModal.value = true;
  previewAnimationProgress.value = 0;

  // Animate the model
  animateMovement(() => {
    // Animation completed callback
    previewAnimationProgress.value = 100;
    setTimeout(() => {
      if (showPreviewModal.value) {
        showPreviewModal.value = false;
      }
    }, 1000);
  });

  // Update the progress bar
  previewInterval = window.setInterval(() => {
    if (isAnimating.value) {
      previewAnimationProgress.value = Math.min(
        100,
        previewAnimationProgress.value + 1
      );
    } else {
      clearInterval(previewInterval);
    }
  }, 50);
};

// Stop animation preview
const stopPreview = () => {
  stopAnimation();
  if (previewInterval) {
    clearInterval(previewInterval);
    previewInterval = null;
  }
};

// Save the exercise
const saveExercise = () => {
  const saved = saveMovement();
  if (saved) {
    alert(`Exercise "${saved.name}" saved successfully!`);
    backToSelection();
  }
};

// Increment/decrement functions for counters
const incrementSets = () => {
  if (currentMovement.value) {
    currentMovement.value.targetSets = Math.min(
      10,
      currentMovement.value.targetSets + 1
    );
  }
};

const decrementSets = () => {
  if (currentMovement.value) {
    currentMovement.value.targetSets = Math.max(
      1,
      currentMovement.value.targetSets - 1
    );
  }
};

const incrementReps = () => {
  if (currentMovement.value) {
    currentMovement.value.targetRepetitions = Math.min(
      30,
      currentMovement.value.targetRepetitions + 1
    );
  }
};

const decrementReps = () => {
  if (currentMovement.value) {
    currentMovement.value.targetRepetitions = Math.max(
      1,
      currentMovement.value.targetRepetitions - 1
    );
  }
};

const incrementHoldTime = () => {
  if (currentMovement.value) {
    currentMovement.value.holdTime = Math.min(
      20,
      currentMovement.value.holdTime + 1
    );
  }
};

const decrementHoldTime = () => {
  if (currentMovement.value) {
    currentMovement.value.holdTime = Math.max(
      1,
      currentMovement.value.holdTime - 1
    );
  }
};

const incrementRestTime = () => {
  if (currentMovement.value) {
    currentMovement.value.restTime = Math.min(
      120,
      currentMovement.value.restTime + 5
    );
  }
};

const decrementRestTime = () => {
  if (currentMovement.value) {
    currentMovement.value.restTime = Math.max(
      5,
      currentMovement.value.restTime - 5
    );
  }
};

// Clean up on component unmount
onBeforeUnmount(() => {
  if (previewInterval) {
    clearInterval(previewInterval);
  }
  stopAnimation();
});
</script>

<style scoped>
.therapy-builder {
  width: 100%;
  height: 100%;
}

.layout-container {
  display: flex;
  gap: 20px;
}

/* Model Panel */
.model-panel {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.model-container {
  height: 500px;
  background-color: #f5f5f5;
  border-radius: 8px;
  overflow: hidden;
}

.visualization-controls {
  background-color: white;
  padding: 15px;
  border-radius: 8px;
  margin-top: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.timeline-control {
  margin-bottom: 15px;
}

.timeline-labels {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;
  font-size: 0.9rem;
  color: #666;
}

.timeline-slider {
  width: 100%;
  height: 6px;
}

.position-actions {
  display: flex;
  gap: 10px;
}

.position-button {
  flex: 1;
  padding: 10px;
  border: none;
  border-radius: 4px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.start-btn {
  background-color: #e6f7ff;
  color: #0066cc;
  border: 1px solid #b3d9ff;
}

.end-btn {
  background-color: #fff1e6;
  color: #cc6600;
  border: 1px solid #ffd9b3;
}

.position-button:hover:not(:disabled) {
  transform: translateY(-2px);
}

.position-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Clinical Panel */
.clinical-panel {
  flex: 1;
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  max-height: 700px;
  overflow-y: auto;
}

.select-exercise h2,
.exercise-editor h2 {
  margin-top: 0;
  margin-bottom: 20px;
}

.region-filter {
  margin-bottom: 20px;
}

.region-filter label {
  display: block;
  margin-bottom: 10px;
  font-weight: 500;
}

.region-buttons {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.region-btn {
  padding: 6px 12px;
  border: 1px solid #ddd;
  border-radius: 20px;
  background-color: white;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s;
}

.region-btn:hover {
  background-color: #f5f5f5;
}

.region-btn.active {
  background-color: #000;
  color: white;
  border-color: #000;
}

.exercise-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 15px;
}

.exercise-card {
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  padding: 15px;
  background-color: white;
  cursor: pointer;
  transition: all 0.2s;
  height: 170px;
  display: flex;
  flex-direction: column;
}

.exercise-card:hover {
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  transform: translateY(-3px);
}

.exercise-card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 10px;
}

.exercise-card h3 {
  margin: 0;
  font-size: 1.1rem;
}

.complexity-badge {
  font-size: 0.75rem;
  padding: 3px 8px;
  border-radius: 12px;
  font-weight: 500;
}

.beginner {
  background-color: #e6f7ff;
  color: #0066cc;
}

.intermediate {
  background-color: #fff1e6;
  color: #cc6600;
}

.advanced {
  background-color: #ffe6e6;
  color: #cc0000;
}

.exercise-description {
  flex-grow: 1;
  margin: 0 0 15px 0;
  font-size: 0.9rem;
  color: #666;
}

.exercise-meta {
  display: flex;
  justify-content: space-between;
  font-size: 0.8rem;
}

.movement-type,
.body-region {
  padding: 2px 8px;
  background-color: #f5f5f5;
  border-radius: 12px;
}

.new-exercise {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border-style: dashed;
  background-color: #fafafa;
}

.add-icon {
  font-size: 2rem;
  margin-bottom: 10px;
  color: #999;
}

.new-exercise h3 {
  color: #666;
}

.editor-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.back-btn {
  padding: 6px 12px;
  border: none;
  background-color: transparent;
  color: #666;
  cursor: pointer;
  font-size: 0.9rem;
}

.back-btn:hover {
  color: #000;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
}

.form-group input,
.form-group textarea,
.form-group select {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
}

.form-group select {
  height: 38px;
}

.editor-section {
  margin: 25px 0;
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.editor-section h3 {
  margin-top: 0;
  margin-bottom: 15px;
  font-size: 1.1rem;
}

.param-row {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
}

.param-group {
  flex: 1;
}

.complexity-selector {
  display: flex;
  gap: 10px;
}

.complexity-btn {
  flex: 1;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background: white;
  cursor: pointer;
  transition: all 0.2s;
}

.complexity-btn.active {
  background-color: #000;
  color: white;
  border-color: #000;
}

.range-group input {
  width: 100%;
  margin: 10px 0;
}

.range-labels {
  display: flex;
  justify-content: space-between;
  font-size: 0.8rem;
  color: #666;
}

.param-card {
  flex: 1;
  border: 1px solid #eee;
  border-radius: 8px;
  padding: 15px;
  text-align: center;
}

.param-title {
  font-weight: 500;
  margin-bottom: 10px;
}

.param-control {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 15px;
}

.param-control button {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  border: none;
  background-color: #f5f5f5;
  color: #333;
  font-weight: bold;
  cursor: pointer;
}

.param-control span {
  font-size: 1.2rem;
  font-weight: 500;
  min-width: 30px;
}

.action-buttons {
  display: flex;
  gap: 15px;
  margin-top: 30px;
}

.preview-btn,
.save-btn {
  flex: 1;
  padding: 12px;
  border: none;
  border-radius: 4px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.preview-btn {
  background-color: #f5f5f5;
  color: #333;
}

.save-btn {
  background-color: #000;
  color: white;
}

.preview-btn:hover,
.save-btn:hover {
  transform: translateY(-2px);
}

/* Modals */
.modal-overlay {
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

.modal-content,
.preview-modal {
  background-color: white;
  border-radius: 8px;
  padding: 25px;
  width: 450px;
  max-width: 90%;
}

.preview-modal {
  width: 600px;
}

.modal-content h3,
.preview-modal h3 {
  margin-top: 0;
  margin-bottom: 20px;
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 25px;
}

.create-btn,
.cancel-btn,
.close-btn,
.stop-btn {
  padding: 8px 15px;
  border-radius: 4px;
  font-weight: 500;
  cursor: pointer;
}

.create-btn {
  background-color: #000;
  color: white;
  border: none;
}

.cancel-btn,
.close-btn {
  background-color: white;
  color: #666;
  border: 1px solid #ddd;
}

.stop-btn {
  background-color: #ffe6e6;
  color: #cc0000;
  border: 1px solid #ffcccc;
}

.preview-info {
  margin-bottom: 20px;
}

.preview-instructions {
  font-style: italic;
  color: #666;
  margin-bottom: 15px;
}

.preview-details {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  margin-top: 15px;
}

.preview-detail {
  padding: 5px 10px;
  background-color: #f5f5f5;
  border-radius: 4px;
  font-size: 0.9rem;
}

.preview-timeline {
  margin: 25px 0;
}

.preview-progress-bar {
  height: 8px;
  background-color: #f0f0f0;
  border-radius: 4px;
  overflow: hidden;
}

.preview-progress {
  height: 100%;
  background-color: #0066cc;
  transition: width 0.3s ease;
}

.preview-modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>
