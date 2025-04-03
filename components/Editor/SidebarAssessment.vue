<template>
  <div id="container">
    <div class="field">
      <label>Assessment Name</label>
      <input
        type="text"
        v-model="assessment.name"
        placeholder="Assessment name"
      />
    </div>

    <div class="field">
      <label>Tests</label>
      <div class="tests-list">
        <div
          v-if="!assessment.test_ids || assessment.test_ids.length === 0"
          class="no-tests"
        >
          No tests added to this assessment
        </div>
        <div
          v-for="testId in assessment.test_ids"
          :key="testId"
          class="test-item"
        >
          {{ getTestName(testId) }}
          <button @click="removeTest(testId)">Remove</button>
        </div>
      </div>
      <button @click="isTestSelectorOpen = true">Add Test</button>
    </div>

    <!-- Position select -->
    <div class="field">
      <label>Position in Unit</label>
      <select v-model="assessmentPosition">
        <option value="start">Start of Unit</option>
        <option value="end">End of Unit</option>
      </select>
    </div>

    <div class="actions">
      <button @click="saveAssessment">Save Changes</button>
      <button
        v-if="assessment.id !== 'new'"
        @click="store.deleteAssessment(assessment.id)"
      >
        Delete Assessment
      </button>
    </div>

    <!-- Test Selector Modal -->
    <div
      v-if="isTestSelectorOpen"
      class="test-selector-modal"
    >
      <div class="modal-content">
        <h3>Select a Test</h3>
        <div
          v-if="availableTests.length === 0"
          class="no-tests"
        >
          No tests available
        </div>
        <div
          v-else
          class="test-options"
        >
          <div
            v-for="test in availableTests"
            :key="test.id"
            class="test-option"
            @click="addTest(test.id)"
          >
            <h4>{{ test.name }}</h4>
            <p>{{ test.description || "No description available" }}</p>
          </div>
        </div>
        <div class="modal-actions">
          <button @click="isTestSelectorOpen = false">Cancel</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const store = useEditorStore();
const assessment = reactive({ ...store.selectedAssessment! });

// Fix the position determination logic
function determineInitialPosition() {
  if (!store.targetUnit) return "start";

  if (assessment.id === "new") {
    // For new assessments, use the selected position from the UI
    return store.sidebarMode === "create" ? "start" : "end";
  }

  // For existing assessments, check if it's a start or end assessment
  if (store.targetUnit.start_assessment_id === assessment.id) {
    return "start";
  } else if (store.targetUnit.end_assessment_id === assessment.id) {
    return "end";
  }

  // Default to start if we can't determine
  return "start";
}

const assessmentPosition = ref<"start" | "end">(determineInitialPosition());

const tests = ref<any[]>([]);
const isTestSelectorOpen = ref(false);

onMounted(async () => {
  await loadTests();
});

const availableTests = computed(() => {
  if (!assessment.test_ids) return tests.value;
  return tests.value.filter((test) => !assessment.test_ids?.includes(test.id));
});

const loadTests = async () => {
  try {
    const supabase = useSupabaseClient<Database>();
    const { data, error } = await supabase.from("default_tests").select("*");

    if (error) {
      console.error("Error loading tests:", error);
      return;
    }

    tests.value = data || [];
  } catch (error) {
    console.error("Error loading tests:", error);
  }
};

const getTestName = (testId: string) => {
  const test = tests.value.find((t) => t.id === testId);
  return test ? test.name : `Test ${testId}`;
};

const removeTest = (testId: string) => {
  if (!assessment.test_ids) return;
  assessment.test_ids = assessment.test_ids.filter((id) => id !== testId);
};

const addTest = (testId: string) => {
  if (!assessment.test_ids) {
    assessment.test_ids = [];
  }

  if (!assessment.test_ids.includes(testId)) {
    assessment.test_ids.push(testId);
  }

  isTestSelectorOpen.value = false;
};

const saveAssessment = async () => {
  await store.saveAssessment(assessment, assessmentPosition.value);

  let parent = getCurrentInstance()?.parent;
  while (parent && !parent.exposed?.reloadAssessments) {
    parent = parent.parent;
  }

  if (parent && parent.exposed && parent.exposed?.reloadAssessments) {
    setTimeout(() => {
      if (!parent.exposed) return;
      parent.exposed.reloadAssessments();
    }, 100);
  }
};
</script>

<style scoped>
#container {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  padding: 1rem;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

label {
  font-weight: bold;
  font-size: 0.9rem;
}

input,
textarea,
select {
  padding: 0.75rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 1rem;
}

.actions {
  display: flex;
  gap: 1rem;
  margin-top: 1rem;
}

button {
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.2s;
}

.save-btn {
  background-color: #4caf50;
  color: white;
  border: none;
}

.save-btn:hover {
  background-color: #3e8e41;
}

.delete-btn {
  background-color: #f44336;
  color: white;
  border: none;
}

.delete-btn:hover {
  background-color: #d32f2f;
}

.tests-list {
  margin-top: 0.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.test-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.5rem;
  background-color: #f5f5f5;
  border-radius: 4px;
  border: 1px solid #e0e0e0;
}

.no-tests {
  padding: 1rem;
  color: #666;
  font-style: italic;
  border: 1px dashed #ccc;
  border-radius: 4px;
  text-align: center;
}

.add-test-btn {
  margin-top: 0.5rem;
  background-color: #2196f3;
  color: white;
}

.add-test-btn:hover {
  background-color: #0b7dda;
}

.remove-test-btn {
  padding: 0.25rem 0.5rem;
  background-color: #f44336;
  color: white;
  font-size: 0.8rem;
}

.test-selector-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  width: 90%;
  max-width: 500px;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  padding: 20px;
  max-height: 80vh;
  overflow-y: auto;
}

.modal-content h3 {
  margin-top: 0;
  margin-bottom: 1rem;
  font-size: 1.25rem;
}

.test-options {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin: 15px 0;
}

.test-option {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  cursor: pointer;
}

.test-option:hover {
  background-color: #f5f5f5;
  border-color: #2196f3;
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 1rem;
}
</style>
