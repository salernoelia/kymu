<template>
    <div
        ref="chartContainer"
        class="w-full h-full min-h-[300px] overflow-hidden"
    >
        <svg
            ref="chart"
            class="w-full h-full"
        ></svg>
    </div>
</template>

<script setup>
import * as d3 from 'd3';

const props = defineProps({
    data: {
        type: Array,
        default: () => [
            { date: '2024-03-13', value: 3, painDegrees: [5, 7] },
            { date: '2024-03-20', value: 5, painDegrees: [4, 8, 9] },
            { date: '2024-04-01', value: 2, painDegrees: [3, 6] },
            { date: '2024-04-02', value: 6, painDegrees: [30, 60] },
            { date: '2024-04-15', value: 6, painDegrees: [7, 8] },
            { date: '2025-04-18', value: 4, painDegrees: [5, 9] }
        ]
    },
    maxScale: {
        type: Number,
        default: 10
    },
    unit: {
        type: String,
        default: ''
    }
});

const chartContainer = ref(null);
const chart = ref(null);
let resizeObserver = null;

const drawChart = () => {
    if (!chartContainer.value || !chart.value) return;

    // Clear previous chart
    d3.select(chart.value).selectAll('*').remove();

    const margin = { top: 20, right: 20, bottom: 30, left: 40 };
    const width = chartContainer.value.clientWidth - margin.left - margin.right;
    const height = chartContainer.value.clientHeight - margin.top - margin.bottom;

    const svg = d3.select(chart.value)
        .attr('width', width + margin.left + margin.right)
        .attr('height', height + margin.top + margin.bottom)
        .append('g')
        .attr('transform', `translate(${margin.left},${margin.top})`);

    // Create gradient
    const gradient = svg.append('defs')
        .append('linearGradient')
        .attr('id', 'area-gradient')
        .attr('gradientUnits', 'userSpaceOnUse')
        .attr('x1', 0)
        .attr('y1', height)
        .attr('x2', 0)
        .attr('y2', 0);

    gradient.append('stop')
        .attr('offset', '0%')
        .attr('stop-color', 'var(--color-primaryLight)')
        .attr('stop-opacity', 0.1);

    gradient.append('stop')
        .attr('offset', '100%')
        .attr('stop-color', 'var(--color-primaryLight)')
        .attr('stop-opacity', 0.8);

    // Scales
    const x = d3.scaleTime()
        .domain(d3.extent(props.data, d => new Date(d.date)))
        .range([0, width]);

    const y = d3.scaleLinear()
        .domain([0, props.maxScale])
        .range([height, 0]);

    // Line generator
    const line = d3.line()
        .x(d => x(new Date(d.date)))
        .y(d => y(d.value))
        .curve(d3.curveMonotoneX);

    // Area generator for gradient
    const area = d3.area()
        .x(d => x(new Date(d.date)))
        .y0(height)
        .y1(d => y(d.value))
        .curve(d3.curveMonotoneX);

    // Add the X axis with formatted dates
    svg.append('g')
        .attr('transform', `translate(0,${height})`)
        .call(d3.axisBottom(x).tickFormat(d3.timeFormat('%d/%m/%y')));

    // Add the Y axis
    svg.append('g')
        .call(d3.axisLeft(y));

    // Add the gradient area
    svg.append('path')
        .datum(props.data)
        .attr('fill', 'url(#area-gradient)')
        .attr('d', area);

    // Add the line path
    svg.append('path')
        .datum(props.data)
        .attr('fill', 'none')
        .attr('stroke', 'var(--color-primaryNormal)')
        .attr('stroke-width', 2)
        .attr('d', line);

    // Add pain degree points
    props.data.forEach(d => {
        if (d.painDegrees && d.painDegrees.length > 0) {
            d.painDegrees.forEach(pain => {
                svg.append('circle')
                    .attr('cx', x(new Date(d.date)))
                    .attr('cy', y(pain))
                    .attr('r', 4)
                    .style('fill', 'var(--color-dangerNormal)')
                    .style('stroke', 'none')
                    .style('opacity', 0.8);
            });
        }
    });

    // Add hover effects
    const tooltip = d3.select(chartContainer.value)
        .append('div')
        .attr('class', 'tooltip')
        .style('opacity', 0)
        .style('position', 'absolute')
        .style('pointer-events', 'none');

    // Add vertical cursor line
    const cursorLine = svg.append('line')
        .attr('class', 'cursor-line')
        .attr('y1', 0)
        .attr('y2', height)
        .style('opacity', 0)
        .style('stroke', 'var(--color-outline_grayNormal)')
        .style('stroke-width', '1px')

    // Add invisible overlay for mouse tracking
    const overlay = svg.append('rect')
        .attr('class', 'overlay')
        .attr('width', width)
        .attr('height', height)
        .style('fill', 'none')
        .style('pointer-events', 'all');

    overlay.on('mousemove', function (event) {
        const mouseX = d3.pointer(event)[0];

        // Update cursor line
        cursorLine
            .attr('x1', mouseX)
            .attr('x2', mouseX)
            .style('opacity', 1);

        // Find closest data point
        const bisect = d3.bisector(d => new Date(d.date)).left;
        const x0 = x.invert(mouseX);
        const i = bisect(props.data, x0, 1);
        const d0 = props.data[i - 1];
        const d1 = props.data[i];
        const d = x0 - new Date(d0.date) > new Date(d1?.date) - x0 ? d1 : d0;

        if (d) {
            const painDegreesText = d.painDegrees && d.painDegrees.length > 0
                ? `<br/>Pain Degrees: ${d.painDegrees.join(', ')}`
                : '';

            tooltip
                .style('opacity', 1)
                .html(`Date: ${new Date(d.date).toLocaleDateString()}<br/>Value: ${d.value}${props.unit ? ` ${props.unit}` : ''}${painDegreesText}`)
                .style('left', (event.pageX - 160) + 'px')
                .style('top', (event.pageY - 28) + 'px');
        }
    })
        .on('mouseleave', () => {
            cursorLine.style('opacity', 0);
            tooltip.style('opacity', 0);
        });
};

// Handle resize with debouncing
let resizeTimeout;
const handleResize = () => {
    clearTimeout(resizeTimeout);
    resizeTimeout = setTimeout(() => {
        if (chartContainer.value && chart.value) {
            drawChart();
        }
    }, 100);
};

onMounted(() => {
    resizeObserver = new ResizeObserver(handleResize);

    if (chartContainer.value) {
        resizeObserver.observe(chartContainer.value);
    }

    drawChart();
});

onUnmounted(() => {
    if (resizeObserver) {
        resizeObserver.disconnect();
    }
    clearTimeout(resizeTimeout);
});

// Watch for data changes
watch(() => props.data, () => {
    drawChart();
}, { deep: true });

watch(() => props.maxScale, () => {
    drawChart();
});
</script>

<style scoped>
.tooltip {
    background-color: white;
    border: 1px var(--color-outline_grayNormal) solid;
    border-radius: 0.5rem;
    padding: 0.5rem 0.75rem;
    font-size: 12px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    z-index: 1000;
}
</style>