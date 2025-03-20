<template>
  <div>
    <h3 class="chart-title">{{ title }}</h3>
    <div ref="chartContainer" class="chart-container"></div>
  </div>
</template>

<script setup lang="ts">
import * as d3 from "d3";
import { ref, onMounted, watch } from "vue";

// Props definition
const props = defineProps({
  data: {
    type: Array as () => { name: string; value: number }[],
    default: () => [
      { name: "Mo", value: 4 },
      { name: "Di", value: 5 },
      { name: "Mi", value: 4.5 },
      { name: "Do", value: 4 },
      { name: "Fr", value: 7 },
    ],
  },
  title: {
    type: String,
    default: "",
  },
  width: {
    type: Number,
    default: 400,
  },
  height: {
    type: Number,
    default: 200,
  },
  margin: {
    type: Object,
    default: () => ({ top: 30, right: 30, bottom: 40, left: 50 }),
  },
  barColor: {
    type: String,
    default: "#283C7E",
  },
  animationDuration: {
    type: Number,
    default: 750,
  },
});

const chartContainer = ref<HTMLElement | null>(null);

// for rerendering the chart on data update
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

  const x = d3
    .scaleBand()
    .domain(props.data.map((d: any) => d.name))
    .range([0, width])
    .padding(0.2);

  const y = d3.scaleLinear().domain([0, 10]).nice().range([height, 0]);

  svg
    .append("g")
    .attr("transform", `translate(0,${height})`)
    .call(d3.axisBottom(x))
    .selectAll("text")
    .attr("transform", "translate(-10,0)rotate(-45)")
    .style("text-anchor", "end");

  svg.append("g").call(d3.axisLeft(y));

  svg
    .selectAll("rect")
    .data(props.data)
    .join("rect")
    .attr("x", (d: any) => x(d.name) || 0)
    .attr("width", x.bandwidth())
    .attr("y", height)
    .attr("height", 0)
    .attr("fill", props.barColor)
    .transition()
    .duration(props.animationDuration)
    .attr("y", (d: any) => y(d.value))
    .attr("height", (d: any) => height - y(d.value));

  svg
    .selectAll(".value-label")
    .data(props.data)
    .join("text")
    .attr("class", "value-label")
    .attr("x", (d: any) => (x(d.name) || 0) + x.bandwidth() / 2)
    .attr("y", (d: any) => y(d.value) - 5)
    .attr("text-anchor", "middle")
    .text((d: any) => d.value)
    .style("opacity", 0)
    .transition()
    .duration(props.animationDuration)
    .style("opacity", 1);
};

watch(
  () => props.data,
  () => {
    renderChart();
  },
  { deep: true }
);

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

:deep(rect) {
  transition: opacity 0.2s;
}

:deep(rect:hover) {
  opacity: 0.8;
}

:deep(.value-label) {
  font-size: 12px;
  font-weight: bold;
}
</style>
