import type { CapacitorConfig } from "@capacitor/cli";

const config: CapacitorConfig = {
  appId: "com.kymu.app",
  appName: "kymu",
  webDir: ".output/public",
  server: {
    androidScheme: "http",
    cleartext: true,
  },
};

export default config;
