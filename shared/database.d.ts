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
      exercises: {
        Row: {
          created_at: string
          description: string
          id: number
          images_urls: string[] | null
          name: string
          therapist_id: number
          videos_urls: string[] | null
        }
        Insert: {
          created_at?: string
          description: string
          id?: number
          images_urls?: string[] | null
          name: string
          therapist_id: number
          videos_urls?: string[] | null
        }
        Update: {
          created_at?: string
          description?: string
          id?: number
          images_urls?: string[] | null
          name?: string
          therapist_id?: number
          videos_urls?: string[] | null
        }
        Relationships: [
          {
            foreignKeyName: "exercises_therapist_id_fkey"
            columns: ["therapist_id"]
            isOneToOne: false
            referencedRelation: "therapists"
            referencedColumns: ["id"]
          },
        ]
      }
      patient_achievements: {
        Row: {
          created_at: string
          exercise_id: number
          id: number
          minutes: number | null
          repetitions: number | null
          vr_session_id: number
        }
        Insert: {
          created_at?: string
          exercise_id: number
          id?: number
          minutes?: number | null
          repetitions?: number | null
          vr_session_id: number
        }
        Update: {
          created_at?: string
          exercise_id?: number
          id?: number
          minutes?: number | null
          repetitions?: number | null
          vr_session_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "patient_achievements_exercise_id_fkey"
            columns: ["exercise_id"]
            isOneToOne: false
            referencedRelation: "exercises"
            referencedColumns: ["id"]
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
      patients: {
        Row: {
          condition_gmfcs: number | null
          created_at: string
          first_name: string
          id: number
          last_name: string
          therapist_id: number
          uid: string
        }
        Insert: {
          condition_gmfcs?: number | null
          created_at?: string
          first_name: string
          id?: number
          last_name: string
          therapist_id: number
          uid: string
        }
        Update: {
          condition_gmfcs?: number | null
          created_at?: string
          first_name?: string
          id?: number
          last_name?: string
          therapist_id?: number
          uid?: string
        }
        Relationships: [
          {
            foreignKeyName: "patients_therapist_id_fkey"
            columns: ["therapist_id"]
            isOneToOne: false
            referencedRelation: "therapists"
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
          created_at: string | null
          id: number
        }
        Insert: {
          created_at?: string | null
          id?: never
        }
        Update: {
          created_at?: string | null
          id?: never
        }
        Relationships: []
      }
      therapists: {
        Row: {
          city: string | null
          country: string | null
          created_at: string
          first_name: string
          id: number
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
          city?: string | null
          country?: string | null
          created_at?: string
          first_name: string
          id?: number
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
          city?: string | null
          country?: string | null
          created_at?: string
          first_name?: string
          id?: number
          last_name?: string
          phone_number?: string | null
          postal_code?: string | null
          prefix_phone_number?: string | null
          specialist_type?: string | null
          street?: string | null
          street_number?: string | null
          uid?: string
        }
        Relationships: [
          {
            foreignKeyName: "therapists_specialist_type_fkey"
            columns: ["specialist_type"]
            isOneToOne: false
            referencedRelation: "specialist_types"
            referencedColumns: ["name"]
          },
        ]
      }
      training_plan_selected_exercises: {
        Row: {
          created_at: string
          duration_minutes: number | null
          exercise_id: number
          id: number
          physical_location: string | null
          repetitions: number | null
          training_plan_id: number
          vr_location: string | null
        }
        Insert: {
          created_at?: string
          duration_minutes?: number | null
          exercise_id: number
          id?: number
          physical_location?: string | null
          repetitions?: number | null
          training_plan_id: number
          vr_location?: string | null
        }
        Update: {
          created_at?: string
          duration_minutes?: number | null
          exercise_id?: number
          id?: number
          physical_location?: string | null
          repetitions?: number | null
          training_plan_id?: number
          vr_location?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "training_plan_selected_exercises_exercise_id_fkey"
            columns: ["exercise_id"]
            isOneToOne: false
            referencedRelation: "exercises"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "training_plan_selected_exercises_training_plan_id_fkey"
            columns: ["training_plan_id"]
            isOneToOne: false
            referencedRelation: "training_plans"
            referencedColumns: ["id"]
          },
        ]
      }
      training_plans: {
        Row: {
          created_at: string
          id: number
          patient_id: number
          therapist_id: number
        }
        Insert: {
          created_at?: string
          id?: number
          patient_id: number
          therapist_id: number
        }
        Update: {
          created_at?: string
          id?: number
          patient_id?: number
          therapist_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "training_plans_patient_id_fkey"
            columns: ["patient_id"]
            isOneToOne: false
            referencedRelation: "patients"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "training_plans_therapist_id_fkey"
            columns: ["therapist_id"]
            isOneToOne: false
            referencedRelation: "therapists"
            referencedColumns: ["id"]
          },
        ]
      }
      vr_sessions: {
        Row: {
          created_at: string
          id: number
          patient_id: number
        }
        Insert: {
          created_at?: string
          id?: number
          patient_id: number
        }
        Update: {
          created_at?: string
          id?: number
          patient_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "vr_sessions_patient_id_fkey"
            columns: ["patient_id"]
            isOneToOne: false
            referencedRelation: "patients"
            referencedColumns: ["id"]
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
