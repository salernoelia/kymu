import type { CapacitorConfig } from "@capacitor/cli";

const config: CapacitorConfig = {
  appId: "com.kymu.app",
  appName: "kymu",
  webDir: ".output/public",
  zoomEnabled: false,

  server: {
    // url: "http://localhost:3000/", // dev only
    androidScheme: "http",
    cleartext: true,
  },
};

export default config;
