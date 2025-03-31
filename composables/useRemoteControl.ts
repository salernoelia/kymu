export function useRemoteControl() {
  const remoteKey = ref<RemoteAction | null>(null);
  const isKeyPressed = ref(false);

  // Track when a key was last emitted to avoid duplicate events
  const lastKeyPressTime = ref<Record<RemoteAction, number>>(
    {} as Record<RemoteAction, number>,
  );

  const keyMapping: Record<string, RemoteAction> = {
    "w": "up",
    "a": "left",
    "s": "down",
    "d": "right",
    "Enter": "ok",
    // "Escape": "cancel",
    "Backspace": "back",
    "m": "menu",
    "v": "voice",
    "p": "shutdown",
    "f": "fullscreen",
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
