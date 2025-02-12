// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  compatibilityDate: "2025-02-11",
  ssr: false,
  // typescript: {
  //   typeCheck: true,
  // },

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
    vueI18n: "./i18n.config.ts",
    locales: ["de", "en", "fr"], // used in URL path prefix
    defaultLocale: "de", // default locale of your project for Nuxt pages and routings
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
