<template>
  <div>
    <h3 class="chart-title">{{ title }}</h3>
    <div
      ref="chartContainer"
      class="chart-container"
    ></div>
  </div>
</template>

<script setup lang="ts">
import * as d3 from "d3";
import { ref, onMounted, watch } from "vue";

// Props definition
const props = defineProps({
  data: {
    type: Array as () => { name: string; value: number; category?: string }[],
    default: () => [
      { name: "A", value: 10, category: "Group 1" },
      { name: "B", value: 20, category: "Group 1" },
      { name: "C", value: 15, category: "Group 2" },
      { name: "D", value: 25, category: "Group 2" },
      { name: "E", value: 18, category: "Group 3" },
    ],
  },
  title: {
    type: String,
    default: "Bubble Chart",
  },
  width: {
    type: Number,
    default: 600,
  },
  height: {
    type: Number,
    default: 400,
  },
  margin: {
    type: Object,
    default: () => ({ top: 30, right: 30, bottom: 40, left: 50 }),
  },
  colorScheme: {
    type: Array as () => string[],
    default: () => d3.schemeCategory10,
  },
  animationDuration: {
    type: Number,
    default: 750,
  },
  minRadius: {
    type: Number,
    default: 10,
  },
  maxRadius: {
    type: Number,
    default: 50,
  },
  showLegend: {
    type: Boolean,
    default: true,
  },
});

const chartContainer = ref<HTMLElement | null>(null);
const chartData = computed(() => {
  return props.data.map((item) => ({ ...item }));
});

const renderChart = () => {
  if (!chartContainer.value) return;
  d3.select(chartContainer.value).selectAll("*").remove();

  const width = props.width - props.margin.left - props.margin.right;
  const height = props.height - props.margin.top - props.margin.bottom;

  const svg = d3
    .select(chartContainer.value)
    .append("svg")
    .attr("width", props.width)
    .attr("height", props.height)
    .append("g")
    .attr("transform", `translate(${props.margin.left},${props.margin.top})`);

  const x = d3.scaleLinear().domain([0, width]).range([0, width]);
  const y = d3.scaleLinear().domain([0, height]).range([height, 0]);

  const size = d3
    .scaleLinear()
    .domain([0, d3.max(chartData.value, (d: any) => d.value) || 0])
    .range([props.minRadius, props.maxRadius]);

  const categories = Array.from(
    new Set(chartData.value.map((d: any) => d.category || d.name))
  );

  const color = d3
    .scaleOrdinal<string>()
    .domain(categories)
    .range(props.colorScheme);

  const simulationData = chartData.value.map((d: any) => ({ ...d }));

  const simulation = d3
    .forceSimulation(simulationData)
    .force("x", d3.forceX(width / 2).strength(0.05))
    .force("y", d3.forceY(height / 2).strength(0.05))
    .force(
      "collide",
      d3.forceCollide((d: any) => size(d.value) + 2)
    )
    .stop();

  for (let i = 0; i < 120; ++i) simulation.tick();

  const circles = svg
    .selectAll(".bubble")
    .data(simulationData)
    .join("circle")
    .attr("class", "bubble")
    .attr("cx", width / 2)
    .attr("cy", height / 2)
    .attr("r", 0)
    .attr("fill", (d: any) => color(d.category || d.name))
    .attr("opacity", 0.7)
    .attr("stroke", "#fff")
    .attr("stroke-width", 1.5);

  const labels = svg
    .selectAll(".label")
    .data(simulationData)
    .join("text")
    .attr("class", "label")
    .attr("text-anchor", "middle")
    .attr("x", width / 2)
    .attr("y", height / 2)
    .style("font-size", "0px")
    .style("pointer-events", "none")
    .text((d: any) => d.name);

  circles
    .transition()
    .duration(props.animationDuration)
    .attr("cx", (d: any) => d.x)
    .attr("cy", (d: any) => d.y)
    .attr("r", (d: any) => size(d.value));

  labels
    .transition()
    .duration(props.animationDuration)
    .attr("x", (d: any) => d.x)
    .attr("y", (d: any) => d.y)
    .style(
      "font-size",
      (d: any) => Math.min((2 * size(d.value)) / d.name.length, 12) + "px"
    );

  circles.append("title").text((d: any) => `${d.name}: ${d.value}`);

  if (props.showLegend) {
    const legend = svg
      .selectAll(".legend")
      .data(categories)
      .enter()
      .append("g")
      .attr("class", "legend")
      .attr("transform", (_, i) => `translate(0,${i * 20})`);

    legend
      .append("circle")
      .attr("cx", width - 10)
      .attr("cy", 10)
      .attr("r", 7)
      .attr("fill", (d: any) => color(d));

    legend
      .append("text")
      .attr("x", width - 24)
      .attr("y", 10)
      .attr("dy", ".35em")
      .style("text-anchor", "end")
      .text((d: any) => d);
  }
};

watch(chartData, () => {
  renderChart();
});

onMounted(() => {
  renderChart();
});
</script>

<style scoped>
.chart-container {
  width: 100%;
  height: auto;
}

.chart-title {
  text-align: center;
  margin-bottom: 20px;
}

:deep(.bubble) {
  transition: opacity 0.2s;
}

:deep(.bubble:hover) {
  opacity: 1;
  stroke-width: 2;
}

:deep(.label) {
  fill: #fff;
  font-weight: bold;
  pointer-events: none;
}

:deep(.legend text) {
  font-size: 12px;
}
</style>
