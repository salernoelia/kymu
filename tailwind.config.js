/** @type {import('tailwindcss').Config} */
export default {
  darkMode: ["class"],
  content: [
    "./components/**/*.{js,vue,ts}",
    "./layouts/**/*.vue",
    "./pages/**/*.vue",
    "./plugins/**/*.{js,ts}",
    "./app.vue",
    "./error.vue",
  ],
  theme: {
    extend: {
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      colors: {
        // Theme colors using CSS variables from tailwind.css
        primary: {
          DEFAULT: "var(--color-Primary)",
          container: "var(--color-PrimaryContainer)",
          dark: "var(--color-PrimaryFixed)",
          light: "var(--color-PrimaryFixedDim)",
        },
        secondary: {
          DEFAULT: "var(--color-Secondary)",
          container: "var(--color-SecondaryContainer)",
          dark: "var(--color-SecondaryFixed)",
          light: "var(--color-SecondaryFixedDim)",
        },
        tertiary: {
          DEFAULT: "var(--color-Tertiary)",
          container: "var(--color-TertiaryContainer)",
          dark: "var(--color-TertiaryFixed)",
          light: "var(--color-TertiaryFixedDim)",
        },
        error: {
          DEFAULT: "var(--color-Error)",
          container: "var(--color-ErrorContainer)",
        },
        background: "var(--color-Background)",
        surface: {
          DEFAULT: "var(--color-Surface)",
          variant: "var(--color-SurfaceVariant)",
          container: "var(--color-SurfaceContainer)",
          bright: "var(--color-SurfaceBright)",
          dim: "var(--color-SurfaceDim)",
          tint: "var(--color-SurfaceTint)",
          "container-high": "var(--color-SurfaceContainerHigh)",
          "container-highest": "var(--color-SurfaceContainerHighest)",
          "container-low": "var(--color-SurfaceContainerLow)",
          "container-lowest": "var(--color-SurfaceContainerLowest)",
        },
        on: {
          primary: "var(--color-OnPrimary)",
          "primary-container": "var(--color-OnPrimaryContainer)",
          secondary: "var(--color-OnSecondary)",
          "secondary-container": "var(--color-OnSecondaryContainer)",
          tertiary: "var(--color-OnTertiary)",
          "tertiary-container": "var(--color-OnTertiaryContainer)",
          error: "var(--color-OnError)",
          "error-container": "var(--color-OnErrorContainer)",
          background: "var(--color-OnBackground)",
          surface: "var(--color-OnSurface)",
          "surface-variant": "var(--color-OnSurfaceVariant)",
        },
        outline: {
          DEFAULT: "var(--color-Outline)",
          variant: "var(--color-OutlineVariant)",
        },
        stroke: "var(--color-Stroke)",
        scrim: "var(--color-Scrim)",
        shadow: "var(--color-Shadow)",
        header: {
          DEFAULT: "var(--color-Header)",
          dark: "var(--color-Header-dark)",
          light: "var(--color-Header-light)",
        },
        text: {
          DEFAULT: "var(--color-Text)",
          dark: "var(--color-Text-dark)",
          light: "var(--color-Text-light)",
        },
        gray: {
          100: "var(--color-Gray-100)",
          200: "var(--color-Gray-200)",
          300: "var(--color-Gray-300)",
          400: "var(--color-Gray-400)",
          500: "var(--color-Gray-500)",
          600: "var(--color-Gray-600)",
          700: "var(--color-Gray-700)",
          800: "var(--color-Gray-800)",
          900: "var(--color-Gray-900)",
        },
        exclamation: {
          DEFAULT: "var(--color-Exclamation)",
          light: "var(--color-ExclamationLight)",
        },
        // Preserve existing color definitions
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        chart: {
          1: "hsl(var(--chart-1))",
          2: "hsl(var(--chart-2))",
          3: "hsl(var(--chart-3))",
          4: "hsl(var(--chart-4))",
          5: "hsl(var(--chart-5))",
        },
        // Original shadcn/ui color definitions
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
};
