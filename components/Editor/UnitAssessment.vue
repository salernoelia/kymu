<template>
  <div
    class="assessment-card"
    :id="`assessment-${id}`"
    :class="{
      'assessment-start': position === 'start',
      'assessment-end': position === 'end',
    }"
  >
    <div class="assessment-icon">
      <Icon
        name="material-symbols:clinical-notes"
        size="1.5rem"
      />
    </div>
    <div class="flex flex-col">
      <slot></slot>
    </div>

    <Icon
      class="edit icon-single cursor-pointer"
      size="1.25rem"
      name="material-symbols-light:edit-square-outline"
      @click="() => store.selectAssessment(assessment)"
    />
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  id: string;
  assessment: Tables<"assessments">;
  position: "start" | "end";
}>();

const store = useEditorStore();
</script>

<style scoped lang="scss">
.assessment-card {
  border: 1px solid var(--color-Gray-400);
  padding: 1rem;
  margin: 0.7rem 0;
  position: relative;
  transition: all 0.2s ease;
  display: flex;
  flex-direction: row;
  align-items: center;
  border-radius: 0.5rem;
  gap: 0.5rem;

  &.assessment-start {
    background-color: rgba(
      33,
      150,
      243,
      0.1
    ); /* Light blue for start assessments */
    border-left: 4px solid #2196f3;
  }

  &.assessment-end {
    background-color: rgba(
      156,
      39,
      176,
      0.1
    ); /* Light purple for end assessments */
    border-left: 4px solid #9c27b0;
  }

  &:hover {
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }
}

.assessment-icon {
  color: #666;
}

.edit {
  position: absolute;
  right: 0.5rem;
  top: 0.5rem;
  cursor: pointer;
}
</style>
