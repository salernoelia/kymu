export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      connection_families_and_therapists: {
        Row: {
          created_at: string
          family_id: string
          id: number
          therapist_id: string
        }
        Insert: {
          created_at?: string
          family_id: string
          id?: number
          therapist_id: string
        }
        Update: {
          created_at?: string
          family_id?: string
          id?: number
          therapist_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "public_connection_families_and_therapists_family_id_fkey"
            columns: ["family_id"]
            isOneToOne: false
            referencedRelation: "families"
            referencedColumns: ["uid"]
          },
          {
            foreignKeyName: "public_connection_families_and_therapists_therapist_id_fkey"
            columns: ["therapist_id"]
            isOneToOne: false
            referencedRelation: "therapists"
            referencedColumns: ["uid"]
          },
        ]
      }
      default_exercise_instructions: {
        Row: {
          "3d_animation_urls": string[] | null
          created_at: string
          id: number
          images_urls: string[] | null
          videos_urls: string[] | null
        }
        Insert: {
          "3d_animation_urls"?: string[] | null
          created_at?: string
          id?: number
          images_urls?: string[] | null
          videos_urls?: string[] | null
        }
        Update: {
          "3d_animation_urls"?: string[] | null
          created_at?: string
          id?: number
          images_urls?: string[] | null
          videos_urls?: string[] | null
        }
        Relationships: []
      }
      default_exercises: {
        Row: {
          created_at: string
          default_scene_id: number
          description: string
          duration_seconds_goal: number | null
          focus_type: string
          id: number
          name: string
          possible_exercise_instructions: number[] | null
          repetitions_goal: number | null
          thumbnail_url: string | null
        }
        Insert: {
          created_at?: string
          default_scene_id: number
          description: string
          duration_seconds_goal?: number | null
          focus_type?: string
          id?: number
          name: string
          possible_exercise_instructions?: number[] | null
          repetitions_goal?: number | null
          thumbnail_url?: string | null
        }
        Update: {
          created_at?: string
          default_scene_id?: number
          description?: string
          duration_seconds_goal?: number | null
          focus_type?: string
          id?: number
          name?: string
          possible_exercise_instructions?: number[] | null
          repetitions_goal?: number | null
          thumbnail_url?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "public_default_exercises_default_scene_id_fkey"
            columns: ["default_scene_id"]
            isOneToOne: false
            referencedRelation: "default_scenes"
            referencedColumns: ["id"]
          },
        ]
      }
      default_scenes: {
        Row: {
          created_at: string
          id: number
          images_urls: string[] | null
          name: string
          videos_urls: string[] | null
        }
        Insert: {
          created_at?: string
          id?: number
          images_urls?: string[] | null
          name: string
          videos_urls?: string[] | null
        }
        Update: {
          created_at?: string
          id?: number
          images_urls?: string[] | null
          name?: string
          videos_urls?: string[] | null
        }
        Relationships: []
      }
      exercises: {
        Row: {
          created_at: string
          default_exercise_id: number
          duration_seconds_goal: number | null
          family_scene_adjustment_access: boolean
          focus_type: string
          id: number
          name: string | null
          repetitions_goal: number | null
          therapist_uid: string
          training_unit_id: number
        }
        Insert: {
          created_at?: string
          default_exercise_id: number
          duration_seconds_goal?: number | null
          family_scene_adjustment_access?: boolean
          focus_type?: string
          id?: number
          name?: string | null
          repetitions_goal?: number | null
          therapist_uid: string
          training_unit_id: number
        }
        Update: {
          created_at?: string
          default_exercise_id?: number
          duration_seconds_goal?: number | null
          family_scene_adjustment_access?: boolean
          focus_type?: string
          id?: number
          name?: string | null
          repetitions_goal?: number | null
          therapist_uid?: string
          training_unit_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "public_training_block_exercises_default_exercise_id_fkey"
            columns: ["default_exercise_id"]
            isOneToOne: false
            referencedRelation: "default_exercises"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "public_training_block_exercises_therapist_uid_fkey"
            columns: ["therapist_uid"]
            isOneToOne: false
            referencedRelation: "therapists"
            referencedColumns: ["uid"]
          },
          {
            foreignKeyName: "public_training_block_exercises_training_unit_id_fkey"
            columns: ["training_unit_id"]
            isOneToOne: false
            referencedRelation: "units"
            referencedColumns: ["id"]
          },
        ]
      }
      exercises_default_templates: {
        Row: {
          created_at: string
          default_exercise_id: number
          duration_seconds_goal: number | null
          family_scene_adjustment_access: boolean
          focus_type: string
          id: number
          name: string | null
          repetitions_goal: number | null
        }
        Insert: {
          created_at?: string
          default_exercise_id: number
          duration_seconds_goal?: number | null
          family_scene_adjustment_access?: boolean
          focus_type?: string
          id?: number
          name?: string | null
          repetitions_goal?: number | null
        }
        Update: {
          created_at?: string
          default_exercise_id?: number
          duration_seconds_goal?: number | null
          family_scene_adjustment_access?: boolean
          focus_type?: string
          id?: number
          name?: string | null
          repetitions_goal?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "public_exercises_default_templates_default_exercise_id_fkey"
            columns: ["default_exercise_id"]
            isOneToOne: false
            referencedRelation: "default_exercises"
            referencedColumns: ["id"]
          },
        ]
      }
      families: {
        Row: {
          caregiver_first_name: string | null
          caregiver_last_name: string | null
          created_at: string
          patient_first_name: string
          patient_last_name: string
          therapist_uid: string
          uid: string
        }
        Insert: {
          caregiver_first_name?: string | null
          caregiver_last_name?: string | null
          created_at?: string
          patient_first_name: string
          patient_last_name: string
          therapist_uid: string
          uid: string
        }
        Update: {
          caregiver_first_name?: string | null
          caregiver_last_name?: string | null
          created_at?: string
          patient_first_name?: string
          patient_last_name?: string
          therapist_uid?: string
          uid?: string
        }
        Relationships: [
          {
            foreignKeyName: "public_families_therapist_uid_fkey"
            columns: ["therapist_uid"]
            isOneToOne: false
            referencedRelation: "therapists"
            referencedColumns: ["uid"]
          },
        ]
      }
      patient_achievements: {
        Row: {
          created_at: string
          exercise_id: number
          id: number
          minutes: number | null
          patient_uid: string | null
          repetitions: number | null
          vr_session_id: number
        }
        Insert: {
          created_at?: string
          exercise_id: number
          id?: number
          minutes?: number | null
          patient_uid?: string | null
          repetitions?: number | null
          vr_session_id: number
        }
        Update: {
          created_at?: string
          exercise_id?: number
          id?: number
          minutes?: number | null
          patient_uid?: string | null
          repetitions?: number | null
          vr_session_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "patient_achievements_exercise_id_fkey"
            columns: ["exercise_id"]
            isOneToOne: false
            referencedRelation: "default_exercises"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "patient_achievements_patient_uid_fkey"
            columns: ["patient_uid"]
            isOneToOne: false
            referencedRelation: "families"
            referencedColumns: ["uid"]
          },
          {
            foreignKeyName: "patient_achievements_vr_session_id_fkey"
            columns: ["vr_session_id"]
            isOneToOne: false
            referencedRelation: "vr_sessions"
            referencedColumns: ["id"]
          },
        ]
      }
      specialist_types: {
        Row: {
          created_at: string
          id: number
          name: string
        }
        Insert: {
          created_at?: string
          id?: number
          name: string
        }
        Update: {
          created_at?: string
          id?: number
          name?: string
        }
        Relationships: []
      }
      test: {
        Row: {
          created_at: string
          id: number
        }
        Insert: {
          created_at?: string
          id?: number
        }
        Update: {
          created_at?: string
          id?: number
        }
        Relationships: []
      }
      therapists: {
        Row: {
          avatar_url: string | null
          city: string | null
          country: string | null
          created_at: string
          first_name: string
          language: string | null
          last_name: string
          phone_number: string | null
          postal_code: string | null
          prefix_phone_number: string | null
          specialist_type: string | null
          street: string | null
          street_number: string | null
          uid: string
        }
        Insert: {
          avatar_url?: string | null
          city?: string | null
          country?: string | null
          created_at?: string
          first_name: string
          language?: string | null
          last_name: string
          phone_number?: string | null
          postal_code?: string | null
          prefix_phone_number?: string | null
          specialist_type?: string | null
          street?: string | null
          street_number?: string | null
          uid: string
        }
        Update: {
          avatar_url?: string | null
          city?: string | null
          country?: string | null
          created_at?: string
          first_name?: string
          language?: string | null
          last_name?: string
          phone_number?: string | null
          postal_code?: string | null
          prefix_phone_number?: string | null
          specialist_type?: string | null
          street?: string | null
          street_number?: string | null
          uid?: string
        }
        Relationships: []
      }
      unit_default_templates: {
        Row: {
          created_at: string
          description: string | null
          exercises_index: number[] | null
          id: number
          name: string
          therapist_uid: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          exercises_index?: number[] | null
          id?: number
          name: string
          therapist_uid: string
        }
        Update: {
          created_at?: string
          description?: string | null
          exercises_index?: number[] | null
          id?: number
          name?: string
          therapist_uid?: string
        }
        Relationships: [
          {
            foreignKeyName: "public_training_blocks_therapist_templates_therapist_uid_fkey"
            columns: ["therapist_uid"]
            isOneToOne: false
            referencedRelation: "therapists"
            referencedColumns: ["uid"]
          },
        ]
      }
      units: {
        Row: {
          created_at: string
          description: string | null
          exercises_index: number[] | null
          id: number
          is_template: boolean
          name: string
          patient_uid: string
          therapist_uid: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          exercises_index?: number[] | null
          id?: number
          is_template?: boolean
          name: string
          patient_uid: string
          therapist_uid: string
        }
        Update: {
          created_at?: string
          description?: string | null
          exercises_index?: number[] | null
          id?: number
          is_template?: boolean
          name?: string
          patient_uid?: string
          therapist_uid?: string
        }
        Relationships: [
          {
            foreignKeyName: "training_plans_patient_id_fkey"
            columns: ["patient_uid"]
            isOneToOne: false
            referencedRelation: "families"
            referencedColumns: ["uid"]
          },
          {
            foreignKeyName: "training_plans_therapist_id_fkey"
            columns: ["therapist_uid"]
            isOneToOne: false
            referencedRelation: "therapists"
            referencedColumns: ["uid"]
          },
        ]
      }
      user_profiles: {
        Row: {
          first_name: string | null
          id: string
          language: string | null
          last_name: string | null
          user_type: string | null
        }
        Insert: {
          first_name?: string | null
          id: string
          language?: string | null
          last_name?: string | null
          user_type?: string | null
        }
        Update: {
          first_name?: string | null
          id?: string
          language?: string | null
          last_name?: string | null
          user_type?: string | null
        }
        Relationships: []
      }
      vr_sessions: {
        Row: {
          created_at: string
          id: number
          patient_uid: string | null
        }
        Insert: {
          created_at?: string
          id?: number
          patient_uid?: string | null
        }
        Update: {
          created_at?: string
          id?: number
          patient_uid?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "vr_sessions_patient_id_fkey"
            columns: ["patient_uid"]
            isOneToOne: false
            referencedRelation: "families"
            referencedColumns: ["uid"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type PublicSchema = Database[Extract<keyof Database, "public">]

export type Tables<
  PublicTableNameOrOptions extends
    | keyof (PublicSchema["Tables"] & PublicSchema["Views"])
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
        Database[PublicTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
      Database[PublicTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : PublicTableNameOrOptions extends keyof (PublicSchema["Tables"] &
        PublicSchema["Views"])
    ? (PublicSchema["Tables"] &
        PublicSchema["Views"])[PublicTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  PublicEnumNameOrOptions extends
    | keyof PublicSchema["Enums"]
    | { schema: keyof Database },
  EnumName extends PublicEnumNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = PublicEnumNameOrOptions extends { schema: keyof Database }
  ? Database[PublicEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : PublicEnumNameOrOptions extends keyof PublicSchema["Enums"]
    ? PublicSchema["Enums"][PublicEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof PublicSchema["CompositeTypes"]
    | { schema: keyof Database },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof Database
  }
    ? keyof Database[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends { schema: keyof Database }
  ? Database[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof PublicSchema["CompositeTypes"]
    ? PublicSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never
