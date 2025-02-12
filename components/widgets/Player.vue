<template>
    <div>
        <!-- <Startup />
        <IceSettings /> -->
        <div id="player" ref="playerDiv">
            <PlayCircleOutlined id="playButton" v-if="showPlayButtonFlag" src="/images/Play.png" alt="Start Streaming"
                @click="onClickPlayButton" />
            <video id="Video" ref="videoElement" style="touch-action: none" playsInline @loadedmetadata="onLoadedVideo"
                @click="onClickPlayButton" />
            <img id="fullscreenButton" ref="fullScreenButtonElement" src="/images/FullScreen.png" alt="Fullscreen"
                @click="onClickFullscreenButton" />
        </div>

    </div>
    <!-- <div id="message" :style="{ display: messageDisplay }">
        {{ message }}
    </div>
    <select id="codecPreferences" ref="codecPreferences" :disabled="codecPreferencesDisabled">
        <option v-for="codec in codecs" :key="codec.value" :value="codec.value">
            {{ codec.label }}
        </option>
    </select> -->
</template>

<script setup lang="ts">
import {
    PlayCircleOutlined
} from "@ant-design/icons-vue";
import * as Config from "~/assets/js/config.js";
import { createDisplayStringArray } from "~/assets/js/stats.js";
import { VideoPlayer } from "~/assets/js/videoplayer.js";
import { RenderStreaming } from "~/assets/module/renderstreaming.js";
import { Signaling, WebSocketSignaling } from "~/assets/module/signaling.js";

const playerDiv = ref<HTMLElement | null>(null);
const videoElement = ref<HTMLVideoElement | null>(null);
const fullScreenButtonElement = ref<HTMLImageElement | null>(null);
const codecPreferences = ref<HTMLSelectElement | null>(null);

const showPlayButtonFlag = ref(true);
const message = ref("");
const messageDisplay = ref("none");
const codecPreferencesDisabled = ref(true);
const supportsSetCodecPreferences =
    window.RTCRtpTransceiver &&
    "setCodecPreferences" in window.RTCRtpTransceiver.prototype;


let videoPlayer: VideoPlayer | null = null;
let renderstreaming: RenderStreaming | null = null;
let intervalId: number | NodeJS.Timeout | null = null;
let lastStats: RTCStats | RTCStatsReport | null = null;
let useWebSocket = false;

const codecs = ref<
    {
        value: string;
        label: string;
    }[]
>([]);

onMounted(async () => {
    videoPlayer = new VideoPlayer();
    window.document.oncontextmenu = function () {
        return false; // cancel default menu
    };

    window.addEventListener("resize", resizeVideo);
    await setup();

});

onBeforeUnmount(async () => {
    window.removeEventListener("resize", resizeVideo);
    await stopRenderStreaming();
});

async function setup() {
    const res = await Config.getServerConfig();
    useWebSocket = res.useWebSocket;
    showWarningIfNeeded(res.startupMode);
    showCodecSelect();
}

function showWarningIfNeeded(startupMode: string) {
    if (startupMode == "private") {
        message.value = "Warning: This sample is not working on Private Mode.";
        messageDisplay.value = "block";
    }
}

function onClickPlayButton() {
    showPlayButtonFlag.value = false;
    messageDisplay.value = "none";

    if (playerDiv.value && videoElement.value && fullScreenButtonElement.value) {
        // add video player
        videoPlayer?.createPlayer(
            playerDiv.value,
            false,
            videoElement.value,
            fullScreenButtonElement.value
        );
    }
    setupRenderStreaming();
}

async function setupRenderStreaming() {
    codecPreferencesDisabled.value = true;

    const signaling = useWebSocket ? new WebSocketSignaling() : new Signaling();
    const config = Config.getRTCConfiguration();
    renderstreaming = new RenderStreaming(signaling, config);
    renderstreaming.onConnect = onConnect;
    renderstreaming.onDisconnect = onDisconnect;
    renderstreaming.onTrackEvent = (data) => {
        if (videoPlayer !== null && videoElement.value instanceof HTMLVideoElement) {
            videoPlayer.addTrack(data.track, videoElement.value);
        }
    }
    renderstreaming.onGotOffer = setCodecPreferences;

    await renderstreaming.start();
    await renderstreaming.createConnection(null);
}

function onConnect() {
    if (renderstreaming == null) {
        console.error("renderstreaming is null");
        return;
    }
    const channel = renderstreaming.createDataChannel("input");

    if (!videoPlayer || !videoElement.value || !channel) {
        return;
    }
    videoPlayer.setupInput(channel, videoElement.value);

    showStatsMessage();
}

async function onDisconnect(connectionId: string) {
    clearStatsMessage();
    messageDisplay.value = "block";
    message.value = `Disconnect peer on ${connectionId}.`;

    await stopRenderStreaming();
    showPlayButtonFlag.value = true;
}

async function stopRenderStreaming() {
    if (renderstreaming) {
        await renderstreaming.stop();
        renderstreaming = null;
        if (!videoPlayer) {
            return;
        }

        videoPlayer.deletePlayer();
        codecPreferencesDisabled.value = !supportsSetCodecPreferences;
    }
}

function setCodecPreferences() {
    let selectedCodecs = null;
    if (supportsSetCodecPreferences) {
        if (codecPreferences.value && codecPreferences.value.selectedIndex >= 0) {
            const preferredCodec =
                codecPreferences.value.options[codecPreferences.value.selectedIndex];
            if (preferredCodec?.value !== "" && preferredCodec) {
                const [mimeType, sdpFmtpLine] = preferredCodec.value.split(" ");

                const capabilities = RTCRtpSender.getCapabilities("video");

                if (!capabilities) return;

                const { codecs } = capabilities;
                const selectedCodecIndex = codecs.findIndex(
                    (c) => c.mimeType === mimeType && c.sdpFmtpLine === sdpFmtpLine
                );
                const selectCodec = codecs[selectedCodecIndex];
                selectedCodecs = [selectCodec];
            }
        }
    }

    if (selectedCodecs == null || renderstreaming == null) {
        return;
    }
    const transceivers = renderstreaming?.getTransceivers()
        ?.filter((t) => t.receiver.track.kind == "video") ?? [];
    if (transceivers && transceivers.length > 0) {
        const validCodecs = selectedCodecs.filter((codec): codec is RTCRtpCodec => codec !== undefined);
        transceivers.forEach((t) => t.setCodecPreferences(validCodecs));
    }
}

function showCodecSelect() {
    if (!supportsSetCodecPreferences) {
        messageDisplay.value = "block";
        message.value = `Current Browser does not support <a href="https://developer.mozilla.org/en-US/docs/Web/API/RTCRtpTransceiver/setCodecPreferences">RTCRtpTransceiver.setCodecPreferences</a>.`;
        return;
    }

    const capabilities = RTCRtpSender.getCapabilities("video");
    if (!capabilities) return;
    const availableCodecs = capabilities.codecs;
    codecs.value = [];
    availableCodecs.forEach((codec) => {
        if (["video/red", "video/ulpfec", "video/rtx"].includes(codec.mimeType)) {
            return;
        }
        codecs.value.push({
            value: (codec.mimeType + " " + (codec.sdpFmtpLine || "")).trim(),
            label: (codec.mimeType + " " + (codec.sdpFmtpLine || "")).trim(),
        });
    });
    codecPreferencesDisabled.value = false;
}

function showStatsMessage() {
    intervalId = setInterval(async () => {
        if (renderstreaming == null) {
            return;
        }

        const stats = await renderstreaming.getStats();
        if (stats == null) {
            return;
        }

        if (lastStats == null) return;

        if (!(stats instanceof RTCStatsReport)) {
            console.error("stats is not instance of RTCStatsReport");
            return;
        }

        const array = createDisplayStringArray(stats as RTCStatsReport, lastStats as RTCStatsReport);
        if (array.length) {
            messageDisplay.value = "block";
            message.value = array.join("<br>");
        }
        lastStats = stats;
    }, 1000);
}

function clearStatsMessage() {
    if (intervalId) {
        clearInterval(intervalId);
    }
    lastStats = null;
    intervalId = null;
    messageDisplay.value = "none";
    message.value = "";
}

function resizeVideo() {
    if (videoPlayer) {
        videoPlayer.resizeVideo(videoElement.value);
    }
}

function onLoadedVideo() {
    if (videoElement.value) {
        videoElement.value.play();
        resizeVideo();
    }
}

function onClickFullscreenButton() {
    if (!document.fullscreenElement && !document.fullscreenElement) {
        if (playerDiv.value?.requestFullscreen) {
            playerDiv.value?.requestFullscreen();
        } else if (playerDiv.value?.requestFullscreen) {
            playerDiv.value?.requestFullscreen();
        } else {
            if (playerDiv.value?.style.position == "absolute") {
                playerDiv.value.style.position = "relative";
            } else if (playerDiv.value !== null) {
                playerDiv.value.style.position = "absolute";
            } else {
                console.error("playerDiv is null");
            }
        }
    }
}


</script>

<style scoped>
#player {
    width: 100%;
    height: 500px;
    /* Use viewport height */
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: black;
    overflow: hidden;
    object-fit: contain;
    /* Prevent content from spilling out */
}

#Video {
    width: 100%;
    height: 100%;
    object-fit: contain;
    max-width: 100%;
    max-height: 100%;
}

#playButton {
    position: absolute;
    z-index: 99;
    width: 50px;
}

#fullscreenButton {
    position: absolute;
    right: 10px;
    bottom: 10px;
    width: 50px;
    height: 50px;
    cursor: pointer;
}
</style>