<template>
    <div class="settings">
        <h1>Settings</h1>
        <form @submit.prevent="saveSettings">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" v-model="settings.username" />
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" v-model="settings.email" />
            </div>
            <div class="form-group">
                <label for="notifications">Notifications:</label>
                <input type="checkbox" id="notifications" v-model="settings.notifications" />
            </div>
            <button type="submit">Save</button>
        </form>
    </div>
</template>

<script setup lang="ts">
interface Settings {
    username: string;
    email: string;
    notifications: boolean;
};

const settings = ref<Settings>({
    username: '',
    email: '',
    notifications: false
});


function saveSettings() {
    console.log('Settings saved:', this.settings);
}

</script>

<style scoped>
.settings {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.form-group {
    margin-bottom: 15px;
}

label {
    display: block;
    margin-bottom: 5px;
}

input[type="text"],
input[type="email"] {
    width: 100%;
    padding: 8px;
    box-sizing: border-box;
}

button {
    padding: 10px 20px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

button:hover {
    background-color: #0056b3;
}
</style>