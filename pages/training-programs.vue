<template>
  <div>
    <h1>Training Programs</h1>
    <ul class="program-list">
      <li
        v-for="program in trainingPrograms"
        :key="program.id"
        class="program-item"
      >
        <h2 class="text-lg font-medium">{{ program.name }}</h2>
        <p class="text-gray-600">{{ program.description }}</p>
      </li>
    </ul>
  </div>
</template>

<script setup lang="ts">
// selectedProgram = ref(null)

// function selectProgram(program) {
//   this.selectedProgram = program;
// }

const trainingPrograms = ref<any>([
  {
    id: 1,
    name: "Reach and Place Training",
    description: "Focuses on improving shoulder and elbow movements.",
    details:
      "This program includes exercises like reaching forward to place objects and lateral arm raises. Targeted movements include shoulder flexion, extension, and abduction.",
  },
  {
    id: 2,
    name: "Wrist Mobility Exercises",
    description: "Enhances wrist rotation and flexibility.",
    details:
      "Patients practice wrist pronation and supination by turning objects or following guided wrist rotation tasks. These exercises are designed for mild to moderate wrist impairments.",
  },
  {
    id: 3,
    name: "Grasp and Release Training",
    description: "Improves grip strength and fine motor skills.",
    details:
      "Exercises focus on picking up small objects, grasping, and releasing them to simulate daily activities like holding cutlery or pens. This program strengthens hand-eye coordination.",
  },
  {
    id: 4,
    name: "Elbow Extension Workouts",
    description: "Strengthens the ability to extend and flex the elbow.",
    details:
      "Patients practice controlled elbow flexion and extension motions, such as lifting objects or performing virtual pushing tasks.",
  },
  {
    id: 5,
    name: "2D Obstacle Runner",
    description: "Trains wrist movement through game-based interaction.",
    details:
      "Using wrist flexion and extension, patients guide a runner character to avoid obstacles in a fun and engaging virtual environment.",
  },
  {
    id: 6,
    name: "Overhead Reach and Stretch",
    description: "Targets shoulder elevation and coordination.",
    details:
      "This program simulates activities like placing items on a high shelf, improving shoulder elevation and overall arm flexibility.",
  },
  {
    id: 7,
    name: "Snake Path Navigation",
    description: "Develops wrist control using phone gyroscope.",
    details:
      "Patients guide a virtual snake along a path by rotating their wrist, helping improve wrist supination, pronation, and fine control.",
  },
  {
    id: 8,
    name: "Daily Living Activities Simulation",
    description: "Replicates real-world tasks for functional recovery.",
    details:
      "Exercises simulate everyday activities like pouring water, opening jars, and setting tables. Movements include elbow flexion, shoulder abduction, and wrist extension.",
  },
  {
    id: 9,
    name: "Stacking Blocks",
    description: "Develops coordination and wrist control.",
    details:
      "Patients stack virtual blocks to train wrist extension and hand coordination, simulating precise object placement.",
  },
  {
    id: 10,
    name: "Shoulder Stability Training",
    description: "Strengthens shoulder muscles for stability.",
    details:
      "Patients perform exercises like controlled arm lifts and rotations to improve shoulder joint stability and range of motion.",
  },
  {
    id: 11,
    name: "Push-Pull Resistance Training",
    description: "Enhances pushing and pulling strength.",
    details:
      "Simulates actions like opening and closing doors, targeting shoulder and elbow strength through resistance-based virtual exercises.",
  },
  {
    id: 12,
    name: "Virtual Painting",
    description: "Combines creativity and upper limb mobility.",
    details:
      "Patients simulate painting a virtual canvas, encouraging smooth wrist and shoulder coordination while performing circular and linear strokes.",
  },
]);
</script>

<style scoped>
.program-list {
  list-style: none;
  padding: 0;
}

.program-item {
  margin-bottom: 1rem;
  padding: 1rem;
  border: 1px solid #ccc;
  border-radius: 8px;
  background-color: #fff;
  cursor: pointer;
  transition: transform 0.2s, background-color 0.2s;
}

.program-item:hover {
  background-color: #f9f9f9;
}

.selected-program {
  margin-top: 2rem;
  border: 1px solid #ccc;
  background-color: #e6f7ff;
}
</style>
