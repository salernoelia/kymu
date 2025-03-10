<template>
  <div class="vertical-carousel">
    <div
      class="carousel"
      ref="carouselEl"
    >
      <!-- 
        <button
      @click="prevSlide"
      :disabled="currentSlide === 0"
    >
      Prev
    </button>
          <button
        @click="nextSlide"
        :disabled="currentSlide === totalSlides - 1"
      >
        Next
      </button>
    -->
      <div
        class="slide"
        v-for="(slide, index) in slides"
        :key="index"
        :class="{ active: index === currentSlide }"
        ref="slideElements"
        @click="() => emits('currentSlide', index)"
      >
        <h2>{{ slide.title }}</h2>

        <p>{{ slide.description }}</p>
      </div>
    </div>
    <div class="controls"></div>
  </div>
</template>

<script setup lang="ts">
interface Slide {
  title: string;
  description: string;
}

const props = defineProps({
  initialSlide: {
    type: Number,
    required: true,
  },
  slides: {
    type: Array as PropType<Slide[]>,
    default: () => ["Slide", "Slide", "Slide", "Slide", "Slide"],
  },
});

const currentSlide = ref<number>(0);
const totalSlides = computed(() => props.slides.length);
const carouselEl = ref<HTMLElement | null>(null);
const slideElements = ref<HTMLElement[]>([]);

const emits = defineEmits(["currentSlide"]);

const nextSlide = () => {
  if (currentSlide.value < totalSlides.value - 1) {
    currentSlide.value++;
    scrollToCurrentSlide();
  }
};

const prevSlide = () => {
  if (currentSlide.value > 0) {
    currentSlide.value--;
    scrollToCurrentSlide();
  }
};
const scrollToCurrentSlide = () => {
  const currentElement = slideElements.value[currentSlide.value];
  if (carouselEl.value && currentElement) {
    const containerRect = carouselEl.value.getBoundingClientRect();
    const elementRect = currentElement.getBoundingClientRect();
    const relativeTop = elementRect.top - containerRect.top;

    carouselEl.value.scrollTop =
      carouselEl.value.scrollTop +
      relativeTop -
      (containerRect.height - elementRect.height) / 2;
  }
};
const handleScroll = () => {
  if (!carouselEl.value || slideElements.value.length === 0) return;

  const containerRect = carouselEl.value.getBoundingClientRect();
  const containerCenter = containerRect.top + containerRect.height / 2;

  let closestSlide = 0;
  let closestDistance = Infinity;

  slideElements.value.forEach((slide, index) => {
    const slideRect = slide.getBoundingClientRect();
    const slideCenter = slideRect.top + slideRect.height / 2;
    const distance = Math.abs(containerCenter - slideCenter);

    if (distance < closestDistance) {
      closestDistance = distance;
      closestSlide = index;
    }
  });

  if (currentSlide.value !== closestSlide) {
    currentSlide.value = closestSlide;
  }
};

onMounted(async () => {
  await nextTick();
  if (carouselEl.value) {
    carouselEl.value.addEventListener("scroll", handleScroll);
  }
  currentSlide.value = props.initialSlide;
  scrollToCurrentSlide();
});
</script>

<style lang="scss">
.vertical-carousel {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 300px;
  width: 100%;
  min-width: 500px;
  // border: 1px solid #ccc;

  .carousel {
    display: flex;
    flex-direction: column;
    height: 100%;
    width: 80%;
    align-items: center;
    overflow-y: auto;
    scroll-snap-type: y mandatory;
    scroll-behavior: smooth;

    &::-webkit-scrollbar {
      display: none;
    }
    -ms-overflow-style: none;
    scrollbar-width: none;

    .slide {
      display: flex;
      height: 50%;
      width: 90%;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      border: 1px solid #ccc;
      scroll-snap-align: center;
      flex-shrink: 0;
      margin-bottom: 10px;
      border-radius: 0.5rem;
      opacity: 0.95;
      transition: all 0.3s;

      &.active {
        border: 2px solid blue;
        height: 55%;
        width: 100%;
        opacity: 1;
      }

      &:first-child {
        margin-top: 100%;
      }

      &:last-child {
        margin-bottom: 50%;
      }
    }
  }
}
</style>
