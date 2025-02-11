import * as Config from "./config.js";
import { useIceServers } from "./icesettings.js";
import { ref, onMounted } from "vue";

const startupConfig = ref("");

export function useStartupConfig() {
  onMounted(async () => {
    const res = await Config.getServerConfig();
    let configString = "";
    if (res.useWebSocket) {
      configString += "<li>Signaling Protocol : <b>WebSocket</b></li>";
    } else {
      configString += "<li>Signaling Protocol : <b>HTTP</b></li>";
    }

    const mode = res.startupMode.replace(
      /^./,
      res.startupMode[0].toUpperCase()
    );
    configString += `<li>Signaling Mode : <b>${mode}</b></li>`;
    startupConfig.value = configString;
  });

  return { startupConfig };
}
