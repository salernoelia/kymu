<template>
    
    <div class="h-full flex flex-col">

        <NavigationBreadcrumbs
      :breadcrumbs="[
        { path: '/admin/patients', translationKey: 'patient-overview-title' },
        {
          path: `/admin/${route.params.patientid}`,
          translationKey: 'patient-info',
        },
        {
          path: `/admin/${route.params.patientid}/activity`,
          translationKey: 'activity-overview-title',
        },
      ]"
    />

        <h1 class="pb-4">Analyse</h1>

        <div class="flex flex-col gap-4 flex-grow w-full">
            <div class="flex flex-row gap-6 opacity-50">
                <h4>{{ formattedStart }} - {{ formattedEnd }}</h4>
                <h4>Schmerzpunkte</h4>
            </div>

            <div class="flex flex-row gap-4 flex-grow w-full">
                <!-- left -->
                <div class="flex flex-col gap-4 h-full w-1/3">
                    <AnalyticsContainer class="h-full">
                        <h3>Filter</h3>
                        <!-- <Tabs
                            :tabs="tabs"
                            v-model:active="activeTab"
                        /> -->

                        <Popover>
                            <PopoverTrigger as-child>
                                <Button
                                    variant="outline"
                                    :class="'w-full justify-start text-left font-normal',
                                        !value && 'text-muted-foreground'"
                                >
                                    <CalendarIcon class="mr-2 h-4 w-4" />
                                    <template v-if="value.start">
                                        <template v-if="value.end">
                                            {{ df.format(value.start.toDate(getLocalTimeZone())) }} - {{
                                                df.format(value.end.toDate(getLocalTimeZone())) }}
                                        </template>

                                        <template v-else>
                                            {{ df.format(value.start.toDate(getLocalTimeZone())) }}
                                        </template>
                                    </template>
                                    <template v-else>
                                        Pick a date
                                    </template>
                                </Button>
                            </PopoverTrigger>
                            <PopoverContent class="w-auto p-0">
                                <RangeCalendar
                                    v-model="value"
                                    initial-focus
                                    :number-of-months="2"
                                    @update:start-value="(startDate) => value.start = startDate"
                                />
                            </PopoverContent>
                        </Popover>

                        <div class="flex flex-row gap-2">
                            <Select
                                v-model="activeDataset"
                                class="w-full"
                            >
                                <SelectTrigger class="w-full">
                                    <SelectValue :placeholder="datasetTypes[activeDataset].name" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectGroup>
                                        <SelectLabel>Datensätze</SelectLabel>
                                        <SelectItem
                                            v-for="(dataset, key) in datasetTypes"
                                            :key="key"
                                            :value="key"
                                        >
                                            {{ dataset.name }}
                                        </SelectItem>
                                    </SelectGroup>
                                </SelectContent>
                            </Select>
                            <Select v-model="activeBodyPart">
                                <SelectTrigger class="w-full]">
                                    <SelectValue :placeholder="bodyParts[activeBodyPart].name" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectGroup>
                                        <SelectLabel>Körperteile</SelectLabel>
                                        <SelectItem
                                            v-for="(part, key) in bodyParts"
                                            :key="key"
                                            :value="key"
                                        >
                                            {{ part.name }}
                                        </SelectItem>
                                    </SelectGroup>
                                </SelectContent>
                            </Select>
                        </div>

                        <div class="divider" />
                        <h4>{{ datasetTypes[activeDataset].name }} Tests</h4>
                        <div
                            v-for="test in bodyParts[activeBodyPart].tests"
                            :key="test"
                        >
                            <TestContainer
                                :active="activeTest === test"
                                @click="activeTest = test"
                            >
                                {{ bodyParts[activeBodyPart].name }} {{ test }}
                            </TestContainer>
                        </div>

                        <div class="divider" />
                        <h4>Balance Test </h4>

                        <div class="divider" />
                        <h4>Battery Assessment 01</h4>



                    </AnalyticsContainer>
                    <AnalyticsContainer class="h-full">
                        <div class="flex flex-row gap-4 justify-between mb-2">
                            <h3>Zusammenfassung</h3>
                            <UiButton variant="outline">
                                Analyse
                            </UiButton>
                        </div>
                        <p class="text-sm text-gray-600 mb-2">{{ datasetTypes[activeDataset].name }} Durchschnitt</p>
                        <div class="flex flex-row gap-2">
                            <AnalyticsContainer class="flex-1">
                                <p class="text-sm font-medium mb-1">Links</p>
                                <div class="flex flex-row items-center justify-between">
                                    <h3>{{ leftSideSummary.average }}{{ datasetTypes[activeDataset].unit }}</h3>
                                    <div :class="[
                                        'flex flex-row items-center px-3 py-1 rounded-full text-sm font-medium',
                                        leftSideSummary.change > 0 ? 'bg-successLight text-successNormal' :
                                            leftSideSummary.change < 0 ? 'bg-dangerLight text-dangerNormal' :
                                                'bg-gray-100'
                                    ]">
                                        <p>{{ leftSideSummary.change > 0 ? '+' : '' }}{{ leftSideSummary.change }}%</p>
                                    </div>
                                </div>
                            </AnalyticsContainer>
                            <AnalyticsContainer class="flex-1">
                                <p class="text-sm font-medium mb-1">Rechts</p>
                                <div class="flex flex-row items-center justify-between">
                                    <h3>{{ rightSideSummary.average }}{{ datasetTypes[activeDataset].unit }}</h3>
                                    <div :class="[
                                        'flex flex-row items-center px-3 py-1 rounded-full text-sm font-medium',
                                        rightSideSummary.change > 0 ? 'bg-successLight text-successNormal' :
                                            rightSideSummary.change < 0 ? 'bg-dangerLight text-dangerNormal' :
                                                'bg-gray-100'
                                    ]">
                                        <p>{{ rightSideSummary.change > 0 ? '+' : '' }}{{ rightSideSummary.change }}%
                                        </p>
                                    </div>
                                </div>
                            </AnalyticsContainer>
                        </div>
                        <p class="text-sm text-gray-600 mt-4 mb-2">Schmerzpunkte</p>
                        <div class="flex flex-row gap-2">
                            <AnalyticsContainer class="flex-1">
                                <p class="text-sm font-medium mb-1">Links</p>
                                <div class="flex flex-row items-center justify-between">
                                    <h3>{{ painPointsSummary.left.count }}</h3>
                                    <div :class="[
                                        'flex flex-row items-center px-3 py-1 rounded-full text-sm font-medium',
                                        painPointsSummary.left.change < 0 ? 'bg-successLight text-successNormal' :
                                            painPointsSummary.left.change > 0 ? 'bg-dangerLight text-dangerNormal' :
                                                'bg-gray-100'
                                    ]">
                                        <p>{{ painPointsSummary.left.change > 0 ? '+' : '' }}{{
                                            Math.round(painPointsSummary.left.change) }}%
                                        </p>
                                    </div>
                                </div>
                            </AnalyticsContainer>
                            <AnalyticsContainer class="flex-1">
                                <p class="text-sm font-medium mb-1">Rechts</p>
                                <div class="flex flex-row items-center justify-between">
                                    <h3>{{ painPointsSummary.right.count }}</h3>
                                    <div :class="[
                                        'flex flex-row items-center px-3 py-1 rounded-full text-sm font-medium',
                                        painPointsSummary.right.change < 0 ? 'bg-successLight text-successNormal' :
                                            painPointsSummary.right.change > 0 ? 'bg-dangerLight text-dangerNormal' :
                                                'bg-gray-100'
                                    ]">
                                        <p>{{ painPointsSummary.right.change > 0 ? '+' : '' }}{{
                                            Math.round(painPointsSummary.right.change)
                                        }}%</p>
                                    </div>
                                </div>
                            </AnalyticsContainer>
                        </div>
                    </AnalyticsContainer>
                </div>

                <!-- right -->
                <AnalyticsContainer class="h-full">
                    <h3>Zeitstrahl</h3>
                    <p>Links</p>
                    <AnalyticsLineGraph
                        :data="filteredData"
                        :maxScale="maxScale"
                        :unit="datasetTypes[activeDataset].unit"
                    />
                    <p>Rechts</p>
                    <AnalyticsLineGraph
                        :data="filteredData"
                        :maxScale="maxScale"
                        :unit="datasetTypes[activeDataset].unit"
                    />
                </AnalyticsContainer>

            </div>
        </div>
    </div>
</template>

<script setup>

import { Button } from '@/components/ui/button'
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover'
import { RangeCalendar } from '@/components/ui/range-calendar'
import {
    CalendarDate,
    DateFormatter,
    getLocalTimeZone,
    today
} from '@internationalized/date'
import { Calendar as CalendarIcon } from 'lucide-vue-next'
import {
    Select,
    SelectContent,
    SelectGroup,
    SelectItem,
    SelectLabel,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select'

const localepath = useLocalePath();
const route = useRoute();

definePageMeta({
  title: "Kymu",
  layout: "admin",
});


const df = new DateFormatter('en-US', {
    dateStyle: 'medium',
})

const value = ref({
    start: new CalendarDate(2025, 5, 6),
    end: new CalendarDate(2025, 5, 20).add({ days: 20 }),
});

const start = today(getLocalTimeZone())
const end = start.add({ days: 7 })

const formatDate = (date) => {
    return `${date.day.toString().padStart(2, '0')}.${date.month.toString().padStart(2, '0')}.${date.year}`
}

const formattedStart = computed(() => formatDate(value.value.start))
const formattedEnd = computed(() => formatDate(value.value.end))


const tabs = ref([
    { name: 'Messwert' },
    { name: 'Zeitraum' },
    { name: 'Ansicht' },
])

const activeTab = ref('Messwert')



const timeFrame = ref([
    { name: 'Custom' },
    { name: 'W' },
    { name: 'M' },
    { name: '3M' },
    { name: '6M' },
])

const activeTimeFrame = ref('W')


const datasetTypes = {
    ROM: { name: 'ROM', unit: '°', range: [0, 180] },
    BALANCE: { name: 'Balance', unit: ' score', range: [0, 100] },
    STRENGTH: { name: 'Stärke', unit: 'kg', range: [0, 100] },
    MOTOR: { name: 'Motorik', unit: ' score', range: [0, 10] }
}

const bodyParts = {
    shoulders: { name: 'Schultern', tests: ['Flexion/Extension', 'Abduktion/Adduktion', 'Rotation'] },
    elbows: { name: 'Ellenbogen', tests: ['Flexion/Extension', 'Pronation/Supination'] },
    wrists: { name: 'Handgelenke', tests: ['Flexion/Extension', 'Radial/Ulnar'] },
    hips: { name: 'Hüften', tests: ['Flexion/Extension', 'Abduktion/Adduktion', 'Rotation'] },
    knees: { name: 'Knie', tests: ['Flexion/Extension'] },
    ankles: { name: 'Fussgelenke', tests: ['Dorsal/Plantar', 'Inversion/Eversion'] },
    spine: { name: 'Wirbelsäule', tests: ['Flexion/Extension', 'Lateral Flexion', 'Rotation'] }
}

const activeDataset = ref('ROM')
const activeBodyPart = ref('shoulders')
const activeTest = ref('Flexion/Extension')

const datasets = ref({})

const generateDataForRange = (startDate, endDate, datasetType) => {
    const dates = []
    const currentDate = new Date(startDate)
    const end = new Date(endDate)

    while (currentDate <= end) {
        const { range } = datasetTypes[datasetType]
        const value = Math.floor(Math.random() * (range[1] - range[0])) + range[0]
        // Ensure pain degrees don't exceed the value
        const painDegrees = Math.random() > 0.7 ?
            Array.from({ length: Math.floor(Math.random() * 3) + 1 },
                () => Math.floor(Math.random() * (value * 0.8))) : []

        dates.push({
            date: currentDate.toISOString().split('T')[0],
            value,
            painDegrees
        })

        currentDate.setDate(currentDate.getDate() + 1)
    }
    return dates
}

const calculateSummary = (data) => {
    if (!data || data.length === 0) return { average: 0, change: 0 }

    const values = data.map(d => d.value)
    const average = values.reduce((a, b) => a + b, 0) / values.length

    // Calculate change over the period
    const firstValue = values[0]
    const lastValue = values[values.length - 1]
    const change = ((lastValue - firstValue) / firstValue) * 100

    return {
        average: Math.round(average * 10) / 10,
        change: Math.round(change * 10) / 10
    }
}

const leftSideSummary = computed(() => {
    return calculateSummary(filteredData.value)
})

const rightSideSummary = computed(() => {
    // For demo purposes, creating slightly different values for right side
    const rightData = filteredData.value.map(d => ({
        ...d,
        value: d.value * (Math.random() * 0.4 + 0.8) // 80-120% of left side
    }))
    return calculateSummary(rightData)
})

const painPointsSummary = computed(() => {
    const leftPainCount = filteredData.value.reduce((count, d) => count + (d.painDegrees?.length || 0), 0)
    const rightPainCount = Math.floor(leftPainCount * (Math.random() * 0.4 + 0.8)) // Similar variation

    // Calculate change in pain points compared to previous period
    const daysInPeriod = filteredData.value.length
    const previousPeriodPainCount = Math.floor(leftPainCount * (Math.random() * 0.4 + 0.8))
    const rightPreviousPeriodPainCount = Math.floor(rightPainCount * (Math.random() * 0.4 + 0.8))

    return {
        left: {
            count: leftPainCount,
            change: ((leftPainCount - previousPeriodPainCount) / previousPeriodPainCount) * 100
        },
        right: {
            count: rightPainCount,
            change: ((rightPainCount - rightPreviousPeriodPainCount) / rightPreviousPeriodPainCount) * 100
        }
    }
})

const initializeDatasets = () => {
    const startDate = new Date(value.value.start.year, value.value.start.month - 1, value.value.start.day)
    const endDate = new Date(value.value.end.year, value.value.end.month - 1, value.value.end.day)

    Object.keys(datasetTypes).forEach(type => {
        if (!datasets.value[type]) {
            datasets.value[type] = {}
        }
        Object.keys(bodyParts).forEach(part => {
            if (!datasets.value[type][part]) {
                datasets.value[type][part] = {}
            }
            bodyParts[part].tests.forEach(test => {
                datasets.value[type][part][test] = generateDataForRange(startDate, endDate, type)
            })
        })
    })
}

const activeData = computed(() => {
    return datasets.value[activeDataset.value]?.[activeBodyPart.value]?.[activeTest.value] || []
})

watch([() => value.value.start, () => value.value.end], () => {
    initializeDatasets()
})

onMounted(() => {
    initializeDatasets()
})

const filteredData = computed(() => {
    return activeData.value.filter(item => {
        const itemDate = new Date(item.date)
        const startDate = new Date(value.value.start.year, value.value.start.month - 1, value.value.start.day)
        const endDate = new Date(value.value.end.year, value.value.end.month - 1, value.value.end.day)
        return itemDate >= startDate && itemDate <= endDate
    })
})

const maxScale = computed(() => {
    const dataset = datasetTypes[activeDataset.value]
    return dataset.range[1]
})

</script>

<style lang="scss" scoped></style>