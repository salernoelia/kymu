<template>
    <div>
        <h1>
            {{ $t('hello') }}
        </h1>
        <WidgetsPlayer id="player" />
        <h1>
            Hello {{ profiles }}!
        </h1>
    </div>
</template>

<script setup lang="ts">
import type { Database } from '~/shared/types/database';


const supabase = useSupabaseClient();

//oijfdsodjdgslkjgodsij

const profiles = ref([]);

onMounted(async () => {
    let { data, error } = await supabase
        .from("test")
        .select("*");

    console.log(data, error);

    if (data) {
        profiles.value = data;
    }
});

</script>

<style scoped>
#player {
    display: flex;
    justify-content: center;
    align-items: center;
}
</style>