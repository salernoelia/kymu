export default defineNuxtConfig({
  devtools: { enabled: true },
  compatibilityDate: "2025-02-11",
  ssr: false,
  // typescript: {
  //   typeCheck: true,
  // },

  imports: {
    dirs: [
      "~/types/*.d.ts",
      "~/types/ui/*.d.ts",
    ],
  },

  future: {
    compatibilityVersion: 4,
  },

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

  i18n: {
    strategy: "prefix_except_default",
    langDir: "../locales/",
    locales: [
      { code: "de", file: "de.yaml", iso: "de-DE" },
      { code: "en", file: "en.yaml", iso: "en-US" },
      { code: "fr", file: "fr.yaml", iso: "fr-FR" },
    ],
    defaultLocale: "de",
  },

  app: {
    pageTransition: { name: "slide-fade", mode: "out-in" },
    layoutTransition: { name: "project-fade", mode: "out-in" },
  },

  supabase: {
    redirect: false,
  },

  googleFonts: {
    families: {
      Inter: [300, 500, 700],
    },
  },

  pinia: {
    storesDirs: ["./stores/**"],
  },

  colorMode: {
    preference: "light",
    fallback: "light",
    classPrefix: "",
    classSuffix: "",
  },
});
