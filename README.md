# thesis-telerehab-app

**Link Database**

```sh
supabase link --project-ref whbtmepowglwmocqunyw
```

**Pull migrations of Supabase DB for backup**

```sh
supabase db pull
```

**Generate Types of Supabase DB**

```sh
npx supabase gen types typescript --project-id "whbtmepowglwmocqunyw" --schema cccpublic > shared/types/database.types.ts
```

# Widgets usage examples

```vue
<WidgetsVerticalCarousell
  @current-slide="(i) => console.log('clicke', i)"
  :initialSlide="0"
  :slides="[
    { title: 'Slide 1', content: 'Content 1' },
    { title: 'Slide 2', content: 'Content 2' },
    { title: 'Slide 3', content: 'Content 3' },
    { title: 'Slide 4', content: 'Content 4' },
    { title: 'Slide 5', content: 'Content 5' },
  ]"
/>
<ThreeModelViewer
  modelPath="/models/exercise.glb"
  :scale="2"
  @exercise-variant="(v) => console.log('exercise variant', v)"
/>

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
<ChartsBubble
  :data="bubbleData"
  title="Project Budget Distribution"
  :width="700"
  :height="500"
  :minRadius="15"
  :maxRadius="60"
  :showLegend="true"
/>
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

const pieChartData = ref([
  { name: "Marketing", value: 300 },
  { name: "Development", value: 500 },
  { name: "Research", value: 200 },
  { name: "Operations", value: 250 },
  { name: "Administration", value: 150 },
]);

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

Breadcrumbs

```vue
<WidgetsBreadcumbs
  :breadcrumbs="[
    { path: '/patients', translationKey: 'patient-overview-title' },
    {
      path: `/patient/${route.params.id}`,
      translationKey: 'activity-overview-title',
    },
    {
      path: `/editor/${route.params.id}`,
      translationKey: 'unit-editor-title',
    },
  ]"
/>
```
