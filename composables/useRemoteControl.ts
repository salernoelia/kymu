import { onMounted, onUnmounted, ref } from "vue";

export function useRemoteControl() {
  const remoteKey = ref<string | null>(null);
  const pressedKeys = ref<Set<string>>(new Set());

  const keyMapping: Record<string, string> = {
    "w": "up",
    "a": "left",
    "s": "down",
    "d": "right",
    "Enter": "ok",
    "Escape": "cancel",
    "m": "menu",
    "r": "voice",
    "q": "shutdown",
  };

  const validRemoteKeys = Object.values(keyMapping);

  let lastEmittedKey: string | null = null;

  const handleKeyDown = (event: KeyboardEvent) => {
    const key = event.key;
    const mappedKey = keyMapping[key];

    if (mappedKey) {
      if (!pressedKeys.value.has(key)) {
        pressedKeys.value.add(key);
        remoteKey.value = mappedKey;
        lastEmittedKey = mappedKey;

        setTimeout(() => {
          if (lastEmittedKey === mappedKey) {
            remoteKey.value = null;
          }
        }, 10);
      }
    }
  };

  const handleKeyUp = (event: KeyboardEvent) => {
    const key = event.key;
    pressedKeys.value.delete(key);
  };

  onMounted(() => {
    window.addEventListener("keydown", handleKeyDown);
    window.addEventListener("keyup", handleKeyUp);
  });

  onUnmounted(() => {
    window.removeEventListener("keydown", handleKeyDown);
    window.removeEventListener("keyup", handleKeyUp);
  });

  return {
    remoteKey,
    pressedKeys,
    validRemoteKeys,
  };
}
