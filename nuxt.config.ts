// https://nuxt.com/docs/api/configuration/nuxt-config

export default defineNuxtConfig({
  devtools: { enabled: true },
  compatibilityDate: "2025-02-11",
  ssr: false,
  // typescript: {
  //   typeCheck: true,
  // },

  //  auto imports of types
  imports: {
    dirs: [
      "~/types/*.d.ts",
      "~/types/ui/*.d.ts",
    ],
  },

  future: {
    compatibilityVersion: 4,
  },

  css: [
    "~/assets/css/main.css",
    "~/assets/css/reset.css",
    "~/assets/css/primitives.css",
  ],
  modules: [
    "@nuxtjs/tailwindcss",
    "@nuxt/fonts",
    "@nuxt/icon",
    "@pinia/nuxt",
    "@vueuse/nuxt",
    "@nuxtjs/i18n",
    "@nuxtjs/supabase",
    "@vite-pwa/nuxt",
    "@nuxt/image",
  ],

  i18n: {
    strategy: "prefix_except_default",
    langDir: "../locales/",
    locales: [
      { code: "de", file: "de.yaml", iso: "de-DE" },
      { code: "en", file: "en.yaml", iso: "en-US" },
      { code: "fr", file: "fr.yaml", iso: "fr-FR" },
      { code: "it", file: "it.yaml", iso: "it-IT" },
    ],
    defaultLocale: "de",
  },

  // app: {
  //   pageTransition: { name: "slide-fade", mode: "out-in" },
  //   layoutTransition: { name: "project-fade", mode: "out-in" },
  // },

  supabase: {
    redirect: true,
    url: process.env.SUPABASE_URL,
    key: process.env.SUPABASE_KEY,
    redirectOptions: {
      login: "/login",
      callback: "/confirm",
      exclude: ["/signup"],
    },
  },

  pinia: {
    storesDirs: ["./stores/**"],
  },
});
