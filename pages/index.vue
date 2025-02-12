<template>
    <div>
        <WidgetsPlayer id="player" />
        <h1>
            Hello {{ profiles }}!
        </h1>
    </div>
</template>

<script setup lang="ts">
import type { Database } from '~/types/database';


const supabase = useSupabaseClient();


const profiles = ref([]);

onMounted(async () => {
    let { data, error } = await supabase
        .from("profiles")
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