<template>
  <div class="type-selector">
    <h2>What do you want to add?</h2>

    <div class="options">
      <button
        class="option-button"
        @click="selectType('exercise')"
      >
        <div class="option-icon">
          <Icon
            name="material-symbols:fitness-center"
            size="2rem"
          />
        </div>
        <div class="option-info">
          <h3>Exercise</h3>
          <p>Add an exercise that patients can perform</p>
        </div>
      </button>

      <button
        class="option-button"
        @click="selectType('assessment')"
      >
        <div class="option-icon">
          <Icon
            name="material-symbols:clinical-notes"
            size="2rem"
          />
        </div>
        <div class="option-info">
          <h3>Assessment</h3>
          <p>Add an assessment to evaluate patient progress</p>
        </div>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
const emit = defineEmits<{
  (e: "select", type: "exercise" | "assessment"): void;
}>();

const selectType = (type: "exercise" | "assessment") => {
  emit("select", type);
};
</script>

<style scoped lang="scss">
.type-selector {
  padding: 1rem;
  height: 100%;
  overflow-y: auto;
}

h2 {
  font-size: 1.5rem;
  margin-bottom: 2rem;
  color: #333;
  text-align: center;
}

.options {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.option-button {
  display: flex;
  align-items: center;
  width: 100%;
  padding: 1.5rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  transition: all 0.2s ease;
  text-align: left;
  background-color: #fff;
  cursor: pointer;
}

.option-button:hover {
  border-color: #4caf50;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.option-icon {
  margin-right: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 60px;
  height: 60px;
  flex-shrink: 0;
  color: #555;
  background-color: #f9f9f9;
  border-radius: 50%;
}

.option-info {
  flex: 1;
}

.option-info h3 {
  font-size: 1.2rem;
  margin: 0 0 0.5rem;
}

.option-info p {
  font-size: 1rem;
  color: #666;
  margin: 0;
}
</style>
