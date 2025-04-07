<template>
  <div class="card flex flex-row justify-between items-start">
    <div class="left">
      <h2>
        {{ unit.name }}
      </h2>
      <h3>
        {{ unit.description }}
      </h3>
    </div>
    <div class="right">
      <DropdownMenu>
        <DropdownMenuTrigger
          ><Icon
            name="ic:baseline-more-vert"
            class="icon"
        /></DropdownMenuTrigger>
        <DropdownMenuContent>
          <DropdownMenuLabel>{{ unit.name }}</DropdownMenuLabel>
          <DropdownMenuSeparator />
          <DropdownMenuItem @click="editorStore.openEditUnitSidebar(unit)">{{
            $t("ex-edit")
          }}</DropdownMenuItem>
          <DropdownMenuItem>{{ $t("ex-analysis") }}</DropdownMenuItem>
          <DropdownMenuItem>{{ $t("ex-rating-graph") }}</DropdownMenuItem>
          <DropdownMenuItem>{{ $t("ex-execution-graph") }}</DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </div>
  </div>
</template>

<script setup lang="ts">
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

const editorStore = useEditorStore();

const props = defineProps<{
  unit: UnitWithDetails;
}>();
</script>

<style scoped></style>
