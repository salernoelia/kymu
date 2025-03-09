interface TrainingBlock {
  id: number;
  name: string;
  description: string;
  created_at: string;
  patient_uid: string;
  therapist_uid: string;
  training_unit_id: number;
}

interface TrainingBlockExercise {
  id: number;
  created_at: string;
  training_block_id: number;
  default_exercise_id: number;
  duration_seconds_goal: number;
  repetition_goal: number;
  focus_type: string;
  family_scene_adjustment_access: boolean;
}

interface TrainingUnit {
  id: number;
  name: string;
  description: string;
  created_at: string;
  patient_uid: string;
  therapist_uid: string;
  training_blocks: TrainingBlock[];
  training_block_exercises: TrainingBlockExercise[];
}
