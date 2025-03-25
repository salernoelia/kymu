<template>
  <div class="flex flex-row p-4 items-center gap-2">
    <Icon
      v-if="showBackButton"
      name="ic:baseline-arrow-back"
      @click="() => $router.back()"
      size="1.5rem"
      class="cursor-pointer"
    />
    <template
      v-for="(crumb, index) in breadcrumbs"
      :key="crumb.path"
    >
      <nuxt-link
        :to="localePath(crumb.path)"
        :class="[index === breadcrumbs.length - 1 ? '' : 'opacity-50']"
      >
        {{ $t(crumb.translationKey) }}
      </nuxt-link>
      <p
        v-if="index < breadcrumbs.length - 1"
        class="opacity-50"
      >
        /
      </p>
    </template>
  </div>
</template>

<script setup lang="ts">
interface Breadcrumb {
  path: string;
  translationKey: string;
}

interface Props {
  breadcrumbs: Breadcrumb[];
  showBackButton?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  showBackButton: true,
});

const localePath = useLocalePath();
</script>
