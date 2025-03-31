import { onMounted, onUnmounted, ref } from "vue";
import remoteData from "~/assets/xiaomi_remote.json";

export function useRemoteControl() {
  const remoteKey = ref<string | null>(null);
  const isKeyPressed = ref(false);

  // Track when a key was last emitted to avoid duplicate events
  const lastKeyPressTime = ref<Record<string, number>>({});

  // Handle remote control events
  const handleRemoteEvent = (event: any) => {
    if (
      !event.detail || !event.detail.name ||
      !event.detail.name.consumer_key_code
    ) {
      return;
    }
  };

  // For development/testing, also support keyboard keys
  const keyMapping: Record<string, string> = {
    "w": "up",
    "a": "left",
    "s": "down",
    "d": "right",
    "Enter": "ok",
    "Escape": "cancel",
    "Backspace": "back",
    "m": "menu",
    "v": "voice",
    "p": "shutdown",
  };

  const handleKeyDown = (event: KeyboardEvent) => {
    const key = event.key;
    const action = keyMapping[key];

    if (action) {
      const now = Date.now();
      const lastPress = lastKeyPressTime.value[action] || 0;

      if (now - lastPress > 300) { // Same debounce as remote
        remoteKey.value = action;
        isKeyPressed.value = true;
        lastKeyPressTime.value[action] = now;
        console.log(`Key pressed: ${action}`);

        setTimeout(() => {
          if (remoteKey.value === action) {
            remoteKey.value = null;
            isKeyPressed.value = false;
          }
        }, 100);
      }
    }
  };

  onMounted(() => {
    window.addEventListener("keydown", handleKeyDown);
  });

  onUnmounted(() => {
    window.removeEventListener("keydown", handleKeyDown);
  });

  return {
    remoteKey,
    isKeyPressed,
  };
}
