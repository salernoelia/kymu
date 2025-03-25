// This file is added to ensure SharedArrayBuffer is available for FFmpeg.wasm
// It's important for the browser to have the right Cross-Origin headers
if (typeof SharedArrayBuffer === "undefined") {
  console.warn(
    "SharedArrayBuffer is not available. FFmpeg.wasm may not work properly. " +
      "Make sure your server includes the required COOP/COEP headers. " +
      "See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer"
  );
}
