\*\*\*\*# Kymu

## Supabase Commands

```
create policy "Enable update for users based on therapist_uid"
on "public"."assessments"
as permissive
for update
to public
with check ((auth.uid() = therapist_uid));
```

### Link Database

```sh
supabase link --project-ref whbtmepowglwmocqunyw
```

### Pull Migrations of Supabase DB for Backup

```sh
supabase db pull
```

### Generate Types of Supabase DB

#### Local

```sh
supabase gen types typescript --local > ./shared/types/database.d.ts
```

#### External

```sh
npx supabase gen types typescript --project-id "whbtmepowglwmocqunyw" --schema cccpublic > ./shared/types/database.d.ts
```

---

## Widgets Usage Examples

### Vertical Carousel

```vue
<WidgetsVerticalCarousell
  @current-slide="(i) => console.log('click', i)"
  :initialSlide="0"
  :slides="[
    { title: 'Slide 1', content: 'Content 1' },
    { title: 'Slide 2', content: 'Content 2' },
    { title: 'Slide 3', content: 'Content 3' },
    { title: 'Slide 4', content: 'Content 4' },
    { title: 'Slide 5', content: 'Content 5' },
  ]"
/>
```

### 3D Model Viewer

```vue
<ThreeModelViewer
  modelPath="/models/exercise.glb"
  :scale="2"
  @exercise-variant="(v) => console.log('exercise variant', v)"
/>
```

---

## Charts

### Pie Chart

```vue
<ChartsPie
  :data="pieChartData"
  title="Budget Allocation"
  :innerRadius="80"
  :width="1000"
  :height="500"
  :showLegend="false"
  :cornerRadius="8"
  :padAngle="0.02"
/>
```

```ts
const pieChartData = ref([
  { name: "Marketing", value: 300 },
  { name: "Development", value: 500 },
  { name: "Research", value: 200 },
  { name: "Operations", value: 250 },
  { name: "Administration", value: 150 },
]);
```

### Bubble Chart

```vue
<ChartsBubble
  :data="bubbleData"
  title="Project Budget Distribution"
  :width="700"
  :height="500"
  :minRadius="15"
  :maxRadius="60"
  :showLegend="true"
/>
```

```ts
const bubbleData = ref([
  { name: "Research", value: 85, category: "Development" },
  { name: "Design", value: 65, category: "Development" },
  { name: "Testing", value: 45, category: "QA" },
  { name: "Deployment", value: 30, category: "Operations" },
  { name: "Marketing", value: 55, category: "Business" },
  { name: "Analysis", value: 40, category: "Business" },
  { name: "Support", value: 25, category: "Operations" },
]);
```

### Bar Chart

```vue
<ChartsBar
  :data="barChartData"
  title="Monthly Sales"
  :width="800"
  :height="400"
  barColor="#3498db"
/>
```

```ts
const barChartData = ref([
  { name: "Jan", value: 45 },
  { name: "Feb", value: 23 },
  { name: "Mar", value: 56 },
  { name: "Apr", value: 78 },
  { name: "May", value: 42 },
]);
```

---

## Breadcrumbs

```vue
<NavigationBreadcrumbs
  :breadcrumbs="[
    { path: '/patients', translationKey: 'patient-overview-title' },
    {
      path: `/patient/${route.params.id}`,
      translationKey: 'activity-overview-title',
    },
    { path: `/editor/${route.params.id}`, translationKey: 'unit-editor-title' },
  ]"
/>
```

---

## Divider

```vue
<PrimitivesDivider
  orientation="horizontal"
  color="gray-200"
  :marginTop="4"
  :marginBottom="4"
/>
```

## Select

```vue
<PrimitivesSelect
  v-model="selectedLanguage"
  :options="[
    { value: 'de', label: 'DE' },
    { value: 'en', label: 'EN' },
    { value: 'fr', label: 'FR' },
    { value: 'it', label: 'IT' },
  ]"
  leftIcon="material-symbols-light:language"
/>
```

## Mediapipe

![Mediapipe Pose Landmarks](https://camo.githubusercontent.com/d3afebfc801ee1a094c28604c7a0eb25f8b9c9925f75b0fff4c8c8b4871c0d28/68747470733a2f2f6d65646961706970652e6465762f696d616765732f6d6f62696c652f706f73655f747261636b696e675f66756c6c5f626f64795f6c616e646d61726b732e706e67)

## Remote

![remote](/assets/xiaomi_remote_mappings_karabiner.png)

**`useRemoteControl()` and `useFullScreen()` composables**

```ts
const { remoteKey } = useRemoteControl();
const { toggleFullscreen } = useFullscreen();

watch(
  () => remoteKey.value,
  (newKey) => {
    if (newKey === "menu") {
      console.log("Menu button pressed - toggling menu");
    } else if (newKey === "back") {
      console.log("cancel pressed");
    } else if (newKey === "fullscreen") {
      console.log("Fullscreen button pressed - toggling fullscreen");
      toggleFullscreen();
    }
  }
);
```
