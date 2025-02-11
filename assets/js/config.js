import { useIceServers } from "./icesettings.js";
import { serverURL } from "../module/constants.js";

export async function getServerConfig() {
  const protocolEndPoint = serverURL + "/config";
  const createResponse = await fetch(protocolEndPoint);
  return await createResponse.json();
}

export function getRTCConfiguration() {
  const { getServers } = useIceServers();
  let config = {};
  config.sdpSemantics = "unified-plan";
  config.iceServers = getServers();
  return config;
}
