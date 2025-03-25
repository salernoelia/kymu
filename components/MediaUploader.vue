<template>
  <div class="media-uploader">
    <input
      type="file"
      ref="fileInput"
      @change="onFileSelected"
      accept="video/*"
      class="file-input"
    />
    <button @click="triggerFileInput">Upload Video</button>
    <div
      v-if="errorMessage"
      class="error-message"
    >
      {{ errorMessage }}
    </div>
  </div>
</template>

<script setup lang="ts">
// Let Nuxt auto-import Vue utilities
const emit = defineEmits<{
  "file-uploaded": [file: File];
}>();

const fileInput = ref<HTMLInputElement | null>(null);
const errorMessage = ref<string>("");

const triggerFileInput = () => {
  fileInput.value?.click();
};

const onFileSelected = (event: Event) => {
  const target = event.target as HTMLInputElement;
  if (!target.files || target.files.length === 0) {
    return;
  }

  const file = target.files[0];
  if (!file) return;

  if (!file.type.startsWith("video/")) {
    errorMessage.value = "Please select a valid video file";
    return;
  }

  errorMessage.value = "";
  emit("file-uploaded", file);
};
</script>

<style scoped>
.media-uploader {
  margin-bottom: 20px;
}

.file-input {
  display: none;
}

button {
  padding: 10px 20px;
  cursor: pointer;
}

.error-message {
  color: red;
  margin-top: 10px;
}
</style>
