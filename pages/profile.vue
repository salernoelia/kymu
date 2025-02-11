<template>
    <div class="profile">
        <h1>User Profile</h1>
        <div class="profile-info">
            <p><strong>Name:</strong> {{ user.name }}</p>
            <p><strong>Email:</strong> {{ user.email }}</p>
            <p><strong>Bio:</strong> {{ user.bio }}</p>
        </div>
    </div>
</template>

<script setup lang="ts">
interface User {
    name: string;
    email: string;
    bio: string;
}

const user = ref<User>({
    name: 'Dr. Elanowski',
    email: 'elanowski@example.com',
    bio: 'blabla bla bio.'
});
</script>

<style scoped>
.profile {
    padding: 20px;
}

.profile-info {
    margin-top: 20px;
}

.profile-info p {
    margin: 5px 0;
}
</style>