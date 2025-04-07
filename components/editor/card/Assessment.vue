<template>
  <!-- <EditorDropZone
    v-if="
      // dragDropStore.draggingassessment &&
      // !dragDropStore.isassessmentBeingDragged(assessment.id)
    "
    :unit="unit"
  /> -->
  <div
    class="c flex flex-row justify-between items-start p-4"
    draggable="true"
    @dragstart="emit('dragstart', $event)"
    @dragend="handleDragEnd"
  >
    <div class="left">
      <h2>
        {{ assessment.name }}
      </h2>
      <h3>
        {{ assessment.description }}
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
          <DropdownMenuLabel>{{ assessment.name }}</DropdownMenuLabel>
          <DropdownMenuSeparator />
          <DropdownMenuItem>{{ $t("ex-edit") }}</DropdownMenuItem>
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

const props = defineProps<{
  assessment: AssessmentWithTests;
  unitID: Tables<"units">["id"];
}>();

const emit = defineEmits<{
  dragstart: [event: DragEvent];
}>();

const dragDropStore = useDragDropStore();
const editorStore = useEditorStore();

const handleDragEnd = (event: DragEvent) => {
  // dragDropStore.endDragassessment(event);
};
</script>

<style scoped lang="scss">
.c {
  padding: 1rem;
  border-radius: 0.5rem;
  background-color: var(--color-PrimaryContainer);
  border: var(--color-Stroke) 1px solid;
}
</style>
