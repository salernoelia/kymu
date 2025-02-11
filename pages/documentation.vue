<template>
  <div class="documentation">
    <h1 class="text-2xl font-semibold mb-6">Patient Documentation</h1>
    <form @submit.prevent="submitForm" class="form-container">
      <div class="form-group">
        <label for="name" class="form-label">Name:</label>
        <input type="text" id="name" v-model="patient.name" class="form-input" placeholder="Enter patient's name"
          required />
      </div>

      <div class="form-group">
        <label for="age" class="form-label">Age:</label>
        <input type="number" id="age" v-model="patient.age" class="form-input" placeholder="Enter patient's age"
          required />
      </div>

      <div class="form-group">
        <label for="gender" class="form-label">Gender:</label>
        <select id="gender" v-model="patient.gender" class="form-input" required>
          <option disabled value="">Select gender</option>
          <option value="male">Male</option>
          <option value="female">Female</option>
          <option value="other">Other</option>
        </select>
      </div>

      <div class="form-group">
        <label for="diagnosis" class="form-label">Diagnosis:</label>
        <textarea id="diagnosis" v-model="patient.diagnosis" class="form-input"
          placeholder="Describe diagnosis or condition" required></textarea>
      </div>

      <div class="form-group">
        <label for="severity" class="form-label">Severity of Post-Stroke Effects:</label>
        <select id="severity" v-model="patient.severity" class="form-input" required>
          <option disabled value="">Select severity</option>
          <option value="mild">Mild</option>
          <option value="moderate">Moderate</option>
          <option value="severe">Severe</option>
        </select>
      </div>

      <div class="form-group">
        <label for="progress-notes" class="form-label">Progress Notes:</label>
        <textarea id="progress-notes" v-model="patient.progressNotes" class="form-input"
          placeholder="Add any progress or special notes"></textarea>
      </div>

      <div class="form-group">
        <label for="training-schedule" class="form-label">Recommended Training Schedule:</label>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label for="session-duration" class="form-sub-label">Session Duration (mins):</label>
            <input type="number" id="session-duration" v-model="patient.schedule.sessionDuration" class="form-input"
              placeholder="e.g., 30" required />
          </div>
          <div>
            <label for="frequency" class="form-sub-label">Frequency (sessions/week):</label>
            <input type="number" id="frequency" v-model="patient.schedule.frequency" class="form-input"
              placeholder="e.g., 3" required />
          </div>
        </div>
      </div>

      <!-- submit -->
      <button type="submit" class="form-button">Submit Documentation</button>
    </form>
  </div>
</template>

<script setup>
const patient = ref({
  name: "",
  age: null,
  gender: "",
  diagnosis: "",
  severity: "",
  progressNotes: "",
  schedule: {
    sessionDuration: null,
    frequency: null,
  },
})

const submitForm = () => {
  console.log("Patient Data:", patient.value)
  alert("Patient documentation submitted successfully!")
}
</script>

<style scoped>
.documentation {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 8px;
  background-color: #f9f9f9;
}

h1 {
  color: #333;
  text-align: center;
}

.form-container {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.form-group {
  margin-bottom: 15px;
}

.form-label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

.form-input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.form-sub-label {
  font-size: 12px;
  color: #555;
}

.form-button {
  width: 100%;
  padding: 12px;
  background-color: #007BFF;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
  text-align: center;
}

.form-button:hover {
  background-color: #0056b3;
}
</style>