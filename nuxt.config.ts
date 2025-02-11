// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  compatibilityDate: "2025-02-11",
  ssr: false,
  css: ["~/assets/css/main.css", "~/assets/css/reset.css"],
  modules: [
    "@nuxt/ui",
    "@nuxtjs/tailwindcss",
    "@nuxtjs/google-fonts",
    "@pinia/nuxt",
    "@vueuse/nuxt",
    "@nuxtjs/i18n",
    "@nuxtjs/supabase",
    "@vite-pwa/nuxt",
  ],
  app: {
    pageTransition: { name: "slide-fade", mode: "out-in" },
    layoutTransition: { name: "project-fade", mode: "out-in" },
  },

  googleFonts: {
    families: {
      Caladea: [300, 500, 700],
      Barlow: [300, 500, 700],
      "Playfair Display": {
        wght: "200..900",
        ital: "200..700",
      },
      Castoro: [300, 500, 700],
      Inter: [300, 500, 700],
      Arvo: [300, 500, 700],
    },
  },

  pinia: {
    storesDirs: ["./stores/**"],
  },

  colorMode: {
    preference: "light", // default value of $colorMode.preference
    fallback: "light", // fallback value if not system preference found
    // hid: "nuxt-color-mode-script",
    // globalName: "__NUXT_COLOR_MODE__",
    // componentName: "ColorScheme",
    // classPrefix: "",
    // classSuffix: "-mode",
    // storage: "localStorage", // or 'sessionStorage' or 'cookie'
    // storageKey: "nuxt-color-mode",
  },
});
