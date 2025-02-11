<template>
    <div>
        <label for="url">URL:</label>
        <input type="text" id="url" v-model="url" />
        <label for="username">Username:</label>
        <input type="text" id="username" v-model="username" />
        <label for="password">Password:</label>
        <input type="password" id="password" v-model="password" />
        <button @click="addServer">Add Server</button>

        <select id="servers" multiple size="4">
            <option v-for="(server, index) in iceServers" :key="index" :value="server">
                {{ server.urls[0] }}
                <span v-if="server.username || server.password">
                    [{{ server.username }}:{{ server.password }}]
                </span>
            </option>
        </select>
        <button @click="removeSelectedServers">Remove Selected</button>
        <button @click="reset">Reset</button>
    </div>
</template>

<script setup>
import { useIceServers } from "../../assets/js/icesettings.js";

const { iceServers, url, username, password, addServer, removeServer, reset } =
    useIceServers();

function removeSelectedServers() {
    const selectedOptions = document.querySelectorAll("#servers option:checked");
    selectedOptions.forEach((option) => {
        const index = Array.from(option.parentNode.children).indexOf(option);
        removeServer(index);
    });
}
</script>