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

declare global {
  interface SVGPathElement {
    _current: any;
  }
}

const props = defineProps({
  data: {
    type: Array as () => { name: string; value: number; category?: string }[],
    default: () => [
      { name: "Segment A", value: 30 },
      { name: "Segment B", value: 45 },
      { name: "Segment C", value: 25 },
      { name: "Segment D", value: 15 },
      { name: "Segment E", value: 20 },
    ],
  },
  title: {
    type: String,
    default: "Pie Chart",
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
    default: () => ({ top: 20, right: 20, bottom: 20, left: 20 }),
  },
  colorScheme: {
    type: Array,
    default: () => d3.schemeCategory10,
  },
  animationDuration: {
    type: Number,
    default: 1000,
  },
  innerRadius: {
    type: Number,
    default: 0,
  },
  cornerRadius: {
    type: Number,
    default: 3,
  },
  padAngle: {
    type: Number,
    default: 0.01,
  },
  showLabels: {
    type: Boolean,
    default: true,
  },
  showLegend: {
    type: Boolean,
    default: true,
  },
  legendPosition: {
    type: String,
    default: "right", // right, bottom
  },
});

const chartContainer = ref<HTMLElement | null>(null);

const renderChart = () => {
  if (!chartContainer.value) return;
  d3.select(chartContainer.value).selectAll("*").remove();

  const width = props.width - props.margin.left - props.margin.right;
  const height = props.height - props.margin.top - props.margin.bottom;

  let radius = Math.min(width, height) / 2;

  if (props.showLegend && props.legendPosition === "right") {
    radius = Math.min(width - 120, height) / 2;
  }

  if (props.showLegend && props.legendPosition === "bottom") {
    radius = Math.min(width, height - 80) / 2;
  }

  const svg = d3
    .select(chartContainer.value)
    .append("svg")
    .attr("width", props.width)
    .attr("height", props.height)
    .append("g")
    .attr(
      "transform",
      `translate(${width / 2 + props.margin.left},${
        height / 2 + props.margin.top
      })`
    );

  const color = d3
    .scaleOrdinal()
    .domain(props.data.map((d) => d.name))
    .range(props.colorScheme);

  const pie = d3
    .pie<any>()
    .sort(null)
    .value((d) => d.value);

  const arc = d3
    .arc<any>()
    .innerRadius(props.innerRadius)
    .outerRadius(radius)
    .cornerRadius(props.cornerRadius)
    .padAngle(props.padAngle);

  const labelArc = d3
    .arc<any>()
    .innerRadius(radius * 0.7)
    .outerRadius(radius * 0.7);

  const outerArc = d3
    .arc<any>()
    .innerRadius(radius * 0.9)
    .outerRadius(radius * 0.9);

  const arcs = svg
    .selectAll(".arc")
    .data(pie(props.data))
    .enter()
    .append("g")
    .attr("class", "arc");

  const path = arcs
    .append("path")
    .attr("fill", (d) => color(d.data.name) as string)
    .attr("stroke", "white")
    .attr("stroke-width", 2)
    .attr("d", arc)
    .each(function (d) {
      this._current = d;
    })
    .style("opacity", 0.9);

  path
    .transition()
    .duration(props.animationDuration)
    .attrTween("d", function (d) {
      const interpolate = d3.interpolate({ startAngle: 0, endAngle: 0 }, d);
      return function (t) {
        return arc(interpolate(t)) || "";
      };
    });

  path
    .on("mouseover", function () {
      d3.select(this).style("opacity", 1).attr("stroke-width", 3);
    })
    .on("mouseout", function () {
      d3.select(this).style("opacity", 0.9).attr("stroke-width", 2);
    });

  arcs
    .append("title")
    .text(
      (d) =>
        `${d.data.name}: ${d.data.value} (${(
          (d.data.value * 100) /
          d3.sum(props.data, (d) => d.value)
        ).toFixed(1)}%)`
    );

  if (props.showLabels) {
    const text = arcs
      .append("text")
      .attr("transform", (d) => {
        const pos = outerArc.centroid(d);
        const midangle = d.startAngle + (d.endAngle - d.startAngle) / 2;
        pos[0] = radius * 0.99 * (midangle < Math.PI ? 1 : -1);
        return `translate(${pos})`;
      })
      .attr("dy", ".35em")
      .attr("text-anchor", (d) => {
        const midangle = d.startAngle + (d.endAngle - d.startAngle) / 2;
        return midangle < Math.PI ? "start" : "end";
      })
      .style("opacity", 0)
      .text((d) => {
        const percentage = (
          (d.data.value * 100) /
          d3.sum(props.data, (d) => d.value)
        ).toFixed(1);
        return `${d.data.name} (${percentage}%)`;
      });

    text
      .transition()
      .delay(props.animationDuration)
      .duration(400)
      .style("opacity", 1);

    arcs
      .append("polyline")
      .attr("stroke", "black")
      .attr("fill", "none")
      .attr("stroke-width", 1)
      .attr("opacity", 0)
      .attr("points", (d) => {
        const pos = outerArc.centroid(d);
        const midangle = d.startAngle + (d.endAngle - d.startAngle) / 2;
        pos[0] = radius * 0.95 * (midangle < Math.PI ? 1 : -1);
        const end = labelArc.centroid(d);
        return [end, outerArc.centroid(d), pos]
          .map((p) => p.join(","))
          .join(" ");
      })
      .transition()
      .delay(props.animationDuration)
      .duration(400)
      .attr("opacity", 0.5);
  }

  if (props.showLegend) {
    const legendG = svg
      .selectAll(".legend")
      .data(pie(props.data))
      .enter()
      .append("g")
      .attr("transform", (d, i) => {
        if (props.legendPosition === "right") {
          return `translate(${radius + 30}, ${i * 20 - height / 3})`;
        } else {
          return `translate(${(i - props.data.length / 2) * 120}, ${
            height / 2 - 20
          })`;
        }
      })
      .attr("class", "legend");

    legendG
      .append("rect")
      .attr("width", 12)
      .attr("height", 12)
      .attr("fill", (d) => color(d.data.name) as string);

    legendG
      .append("text")
      .text((d) => d.data.name)
      .attr("x", 18)
      .attr("y", 10)
      .attr("text-anchor", "start")
      .style("font-size", "12px");
  }

  const totalValue = d3.sum(props.data, (d) => d.value);

  svg
    .append("text")
    .attr("class", "total-value")
    .attr("text-anchor", "middle")
    .attr("dy", ".35em")
    .style("font-size", "0px")
    .text(totalValue)
    .transition()
    .duration(props.animationDuration)
    .style("font-size", () => {
      if (props.innerRadius > 0) return "24px";
      return "0px";
    });
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

:deep(.arc) {
  cursor: pointer;
}

:deep(.arc path) {
  transition: opacity 0.3s, stroke-width 0.3s;
}

:deep(.total-value) {
  font-weight: bold;
}

:deep(polyline) {
  pointer-events: none;
}

:deep(text) {
  pointer-events: none;
}
</style>
