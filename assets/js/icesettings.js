import { ref, onMounted } from "vue";

const allServersKey = "servers";

const iceServers = ref([]);
const url = ref("");
const username = ref("");
const password = ref("");

export function useIceServers() {
  onMounted(() => {
    readServersFromLocalStorage();
  });

  function addServer() {
    const scheme = url.value.split(":")[0];
    if (!["stun", "stuns", "turn", "turns"].includes(scheme)) {
      alert(`URI scheme ${scheme} is not valid`);
      return;
    }

    const iceServer = {
      urls: [url.value],
      username: username.value,
      credential: password.value,
    };
    iceServers.value.push(iceServer);
    url.value = username.value = password.value = "";
    writeServersToLocalStorage();
  }

  function removeServer(index) {
    iceServers.value.splice(index, 1);
    writeServersToLocalStorage();
  }

  function reset() {
    window.localStorage.removeItem(allServersKey);
    iceServers.value = [getDefaultServer()];
    writeServersToLocalStorage();
  }

  function getDefaultServer() {
    return { urls: ["stun:stun.l.google.com:19302"] };
  }

  function writeServersToLocalStorage() {
    localStorage.setItem(allServersKey, JSON.stringify(iceServers.value));
  }

  function readServersFromLocalStorage() {
    const storedServers = localStorage.getItem(allServersKey);
    if (storedServers) {
      iceServers.value = JSON.parse(storedServers);
    } else {
      iceServers.value = [getDefaultServer()];
      writeServersToLocalStorage();
    }
  }

  function getServers() {
    return iceServers.value;
  }

  return {
    iceServers,
    url,
    username,
    password,
    addServer,
    removeServer,
    reset,
    getServers,
  };
}
