<template>
  <div class="exercise-grid">
    <div
      class="exercise-card"
      v-for="exercise in exercises"
      :key="exercise.id"
    >
      <h3>{{ exercise.name }}</h3>
      <p>{{ exercise.description }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
const exercises = ref([
  {
    id: 1,
    name: "Reach and Place",
    description:
      "This exercise focuses on improving shoulder flexion and extension by asking the patient to reach forward and place objects at varying distances.",
  },
  {
    id: 2,
    name: "Arm Raise Sequence",
    description:
      "Designed to enhance shoulder abduction and adduction, patients raise their arm laterally to specified angles in a controlled motion.",
  },
  {
    id: 3,
    name: "Wrist Rotation Drill",
    description:
      "This activity improves wrist pronation and supination by having patients rotate their wrist to turn objects or simulate steering motions.",
  },
  {
    id: 4,
    name: "Elbow Flex and Extend",
    description:
      "Patients practice flexion and extension of the elbow by lifting and lowering a virtual or real lightweight object.",
  },
  {
    id: 5,
    name: "Stack the Blocks",
    description:
      "Patients work on hand-eye coordination and fine motor skills by stacking blocks, training wrist extension and flexion during the activity.",
  },
  {
    id: 6,
    name: "Target Tap",
    description:
      "Focuses on reaching movements and shoulder control as patients tap targets displayed on a screen or placed in different positions.",
  },
  {
    id: 7,
    name: "Cup Rotation Challenge",
    description:
      "Improves wrist rotation and grip strength as patients rotate a virtual cup or object into different orientations.",
  },
  {
    id: 8,
    name: "Guided Arm Path",
    description:
      "Patients follow a guided path with their hand to train smooth and controlled shoulder and elbow movements.",
  },
  {
    id: 9,
    name: "Push and Pull",
    description:
      "Develops shoulder stability and arm strength by simulating pushing and pulling motions, such as opening or closing a virtual door.",
  },
  {
    id: 10,
    name: "Virtual Painting",
    description:
      "Encourages wrist and shoulder coordination as patients simulate painting a canvas, using varied motions to strengthen mobility.",
  },
  {
    id: 11,
    name: "Overhead Reach",
    description:
      "Patients reach above their head to simulate activities such as placing items on a shelf, training shoulder elevation and coordination.",
  },
  {
    id: 12,
    name: "Wrist Lift Drill",
    description:
      "Enhances wrist extension and flexion by asking patients to lift a virtual weight or object repeatedly.",
  },
]);
</script>

<style scoped>
.exercise-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 16px;
}

.exercise-card {
  border: 1px solid #ccc;
  padding: 16px;
  border-radius: 8px;
  background-color: #f9f9f9;
}

p {
  padding-top: 10px;
  color: #808080;
}
</style>
