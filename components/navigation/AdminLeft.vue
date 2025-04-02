<template>
  <div
    class="flex flex-col"
    id="sidebar"
  >
    <div class="text-xl font-semibold">
      <nuxt-link :to="localePath('/')">
        <NuxtImg
          style="width: 3rem; margin-top: 0.5rem"
          src="logo/logo_kymu_blue 1.png"
        />
      </nuxt-link>
    </div>

    <!-- ============= UPPER PART =============== -->

    <div class="p-1 flex flex-col justify-between h-full">
      <div class="flex flex-col gap-2">
        <span
          class="padded-line"
          style="margin: 0.25rem 0 1rem"
        />
        <nuxt-link
          :to="localePath('/admin')"
          class="link"
        >
          <Icon
            name="material-symbols-light:dashboard-2-outline"
            class="icon"
          />
        </nuxt-link>

        <!-- <nuxt-link
          :to="localePath('/rom')"
          class="link"
        >
          <Icon
            name="material-symbols-light:ar-on-you-outline-sharp"
            class="icon"
          />
        </nuxt-link> -->

        <nuxt-link
          :to="localePath('/admin/patients')"
          class="link"
        >
          <Icon
            name="material-symbols-light:patient-list"
            class="icon"
          />
        </nuxt-link>

        <nuxt-link
          :to="localePath('/admin/rentals')"
          class="link"
        >
          <Icon
            name="material-symbols-light:home-repair-service"
            class="icon"
          />
        </nuxt-link>

        <!-- <nuxt-link
          :to="localePath('/admin/training-programs')"
          class="link"
        >
          <Icon
            name="material-symbols-light:explore-outline"
            class="icon"
          />
        </nuxt-link> -->

        <nuxt-link
          :to="localePath('/admin/plugins')"
          class="link"
        >
          <Icon
            name="material-symbols-light:power-plug-outline"
            class="icon"
          />
        </nuxt-link>
      </div>

      <!-- ============= LOWER PART =============== -->
      <div class="flex flex-col align-center gap-2">
        <span class="padded-line" />

        <nuxt-link
          to="/settings"
          class="link"
        >
          <Icon
            name="material-symbols-light:settings"
            class="icon"
          />
        </nuxt-link>

        <nuxt-link
          to="/profile"
          class="link"
        >
          <Icon
            name="material-symbols-light:account-circle"
            class="icon"
          />
        </nuxt-link>
        <NuxtLink
          @click="handleLogout"
          class="link"
        >
          <Icon
            name="material-symbols-light:logout"
            class="icon"
          />
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const localePath = useLocalePath();
const supabase = useSupabaseClient();

defineProps({
  isActive: {
    type: Function,
    required: true,
  },
});

const handleLogout = async () => {
  try {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
    navigateTo(localePath("/login"));
  } catch (error: any) {
    console.log(error.message);
  }
};
</script>

<style scoped lang="scss">
#sidebar {
  background-color: #fff;
  color: black;
  border-right: var(--color-Gray-400) 1px solid;
  border-radius: 0 0.4rem 0.4rem 0;
  align-items: center;

  .padded-line {
    height: 1px;
    width: 100%;
    background-color: var(--color-Gray-400);
    margin: 0.5rem 0;
  }
}

.link {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0.5rem 1rem;
  border-radius: 0.4rem;
  transition: all 0.2s ease;
}

.link {
  &:hover {
    background-color: var(--color-Gray-400);
  }
  .icon {
    width: 1.5rem;
    height: 1.5rem;
  }
}

.router-link-active {
  background-color: var(--color-Primary);
  color: var(--color-OnPrimary);

  &:hover {
    color: rgb(0, 0, 0);
  }
}
</style>
