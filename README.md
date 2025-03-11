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
npx supabase gen types typescript --project-id "whbtmepowglwmocqunyw" --schema public > shared/types/database.types.ts
```

# Widgets usage examples

````vue
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
  modelPath="/models/box.glb"
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
```/
````
