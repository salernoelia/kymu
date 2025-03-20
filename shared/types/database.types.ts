export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          operationName?: string
          query?: string
          variables?: Json
          extensions?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      connection_families_and_therapists: {
        Row: {
          created_at: string
          family_id: string
          id: string
          therapist_id: string
        }
        Insert: {
          created_at?: string
          family_id: string
          id?: string
          therapist_id: string
        }
        Update: {
          created_at?: string
          family_id?: string
          id?: string
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
          "3d_animation": string | null
          created_at: string
          id: number
          images_urls: string[] | null
          name: string | null
          videos_urls: string[] | null
        }
        Insert: {
          "3d_animation"?: string | null
          created_at?: string
          id?: number
          images_urls?: string[] | null
          name?: string | null
          videos_urls?: string[] | null
        }
        Update: {
          "3d_animation"?: string | null
          created_at?: string
          id?: number
          images_urls?: string[] | null
          name?: string | null
          videos_urls?: string[] | null
        }
        Relationships: []
      }
      default_exercises: {
        Row: {
          created_at: string
          default_exercise_instructions: number[]
          default_scene_id: number
          description: string
          duration_seconds_goal: number | null
          focus_type: Database["public"]["Enums"]["focus_types"] | null
          id: string
          name: string
          repetitions_goal: number | null
          thumbnail_url: string | null
        }
        Insert: {
          created_at?: string
          default_exercise_instructions: number[]
          default_scene_id: number
          description: string
          duration_seconds_goal?: number | null
          focus_type?: Database["public"]["Enums"]["focus_types"] | null
          id?: string
          name: string
          repetitions_goal?: number | null
          thumbnail_url?: string | null
        }
        Update: {
          created_at?: string
          default_exercise_instructions?: number[]
          default_scene_id?: number
          description?: string
          duration_seconds_goal?: number | null
          focus_type?: Database["public"]["Enums"]["focus_types"] | null
          id?: string
          name?: string
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
      default_units: {
        Row: {
          created_at: string
          description: string | null
          exercises_index: string[]
          id: string
          name: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          exercises_index: string[]
          id?: string
          name: string
        }
        Update: {
          created_at?: string
          description?: string | null
          exercises_index?: string[]
          id?: string
          name?: string
        }
        Relationships: []
      }
      exercises: {
        Row: {
          created_at: string
          description: string | null
          duration_seconds_goal: number | null
          family_scene_adjustment_access: boolean
          focus_type: Database["public"]["Enums"]["focus_types"]
          id: string
          inherited_default_exercise: string | null
          is_template: boolean | null
          name: string | null
          repetitions_goal: number | null
          therapist_uid: string
          unit_id: string | null
        }
        Insert: {
          created_at?: string
          description?: string | null
          duration_seconds_goal?: number | null
          family_scene_adjustment_access?: boolean
          focus_type?: Database["public"]["Enums"]["focus_types"]
          id?: string
          inherited_default_exercise?: string | null
          is_template?: boolean | null
          name?: string | null
          repetitions_goal?: number | null
          therapist_uid: string
          unit_id?: string | null
        }
        Update: {
          created_at?: string
          description?: string | null
          duration_seconds_goal?: number | null
          family_scene_adjustment_access?: boolean
          focus_type?: Database["public"]["Enums"]["focus_types"]
          id?: string
          inherited_default_exercise?: string | null
          is_template?: boolean | null
          name?: string | null
          repetitions_goal?: number | null
          therapist_uid?: string
          unit_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "public_exercises_inherited_default_exercise_fkey"
            columns: ["inherited_default_exercise"]
            isOneToOne: false
            referencedRelation: "default_exercises"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "public_exercises_training_unit_id_fkey"
            columns: ["unit_id"]
            isOneToOne: false
            referencedRelation: "units"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "public_training_block_exercises_therapist_uid_fkey"
            columns: ["therapist_uid"]
            isOneToOne: false
            referencedRelation: "therapists"
            referencedColumns: ["uid"]
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
            foreignKeyName: "patients_uid_fkey"
            columns: ["uid"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
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
          patient_uid: string
          repetitions: number | null
          vr_session_id: number
        }
        Insert: {
          created_at?: string
          exercise_id: number
          id?: number
          minutes?: number | null
          patient_uid: string
          repetitions?: number | null
          vr_session_id: number
        }
        Update: {
          created_at?: string
          exercise_id?: number
          id?: number
          minutes?: number | null
          patient_uid?: string
          repetitions?: number | null
          vr_session_id?: number
        }
        Relationships: [
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
      profiles: {
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
        Relationships: [
          {
            foreignKeyName: "profiles_id_fkey"
            columns: ["id"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
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
          street: string | null
          street_number: string | null
          therapist_type: Database["public"]["Enums"]["therapist_types"]
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
          street?: string | null
          street_number?: string | null
          therapist_type: Database["public"]["Enums"]["therapist_types"]
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
          street?: string | null
          street_number?: string | null
          therapist_type?: Database["public"]["Enums"]["therapist_types"]
          uid?: string
        }
        Relationships: [
          {
            foreignKeyName: "therapists_uid_fkey"
            columns: ["uid"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      units: {
        Row: {
          created_at: string
          description: string | null
          exercises_index: string[] | null
          id: string
          inherited_default_unit: string | null
          is_template: boolean
          name: string
          patient_uid: string
          therapist_uid: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          exercises_index?: string[] | null
          id?: string
          inherited_default_unit?: string | null
          is_template?: boolean
          name: string
          patient_uid: string
          therapist_uid: string
        }
        Update: {
          created_at?: string
          description?: string | null
          exercises_index?: string[] | null
          id?: string
          inherited_default_unit?: string | null
          is_template?: boolean
          name?: string
          patient_uid?: string
          therapist_uid?: string
        }
        Relationships: [
          {
            foreignKeyName: "public_units_inherited_default_unit_fkey"
            columns: ["inherited_default_unit"]
            isOneToOne: false
            referencedRelation: "default_units"
            referencedColumns: ["id"]
          },
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
      focus_types:
        | "strength"
        | "balance"
        | "endurance"
        | "coordination"
        | "motor function"
      therapist_types: "physio" | "occupational" | "speech" | "other"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  storage: {
    Tables: {
      buckets: {
        Row: {
          allowed_mime_types: string[] | null
          avif_autodetection: boolean | null
          created_at: string | null
          file_size_limit: number | null
          id: string
          name: string
          owner: string | null
          owner_id: string | null
          public: boolean | null
          updated_at: string | null
        }
        Insert: {
          allowed_mime_types?: string[] | null
          avif_autodetection?: boolean | null
          created_at?: string | null
          file_size_limit?: number | null
          id: string
          name: string
          owner?: string | null
          owner_id?: string | null
          public?: boolean | null
          updated_at?: string | null
        }
        Update: {
          allowed_mime_types?: string[] | null
          avif_autodetection?: boolean | null
          created_at?: string | null
          file_size_limit?: number | null
          id?: string
          name?: string
          owner?: string | null
          owner_id?: string | null
          public?: boolean | null
          updated_at?: string | null
        }
        Relationships: []
      }
      migrations: {
        Row: {
          executed_at: string | null
          hash: string
          id: number
          name: string
        }
        Insert: {
          executed_at?: string | null
          hash: string
          id: number
          name: string
        }
        Update: {
          executed_at?: string | null
          hash?: string
          id?: number
          name?: string
        }
        Relationships: []
      }
      objects: {
        Row: {
          bucket_id: string | null
          created_at: string | null
          id: string
          last_accessed_at: string | null
          metadata: Json | null
          name: string | null
          owner: string | null
          owner_id: string | null
          path_tokens: string[] | null
          updated_at: string | null
          user_metadata: Json | null
          version: string | null
        }
        Insert: {
          bucket_id?: string | null
          created_at?: string | null
          id?: string
          last_accessed_at?: string | null
          metadata?: Json | null
          name?: string | null
          owner?: string | null
          owner_id?: string | null
          path_tokens?: string[] | null
          updated_at?: string | null
          user_metadata?: Json | null
          version?: string | null
        }
        Update: {
          bucket_id?: string | null
          created_at?: string | null
          id?: string
          last_accessed_at?: string | null
          metadata?: Json | null
          name?: string | null
          owner?: string | null
          owner_id?: string | null
          path_tokens?: string[] | null
          updated_at?: string | null
          user_metadata?: Json | null
          version?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "objects_bucketId_fkey"
            columns: ["bucket_id"]
            isOneToOne: false
            referencedRelation: "buckets"
            referencedColumns: ["id"]
          },
        ]
      }
      s3_multipart_uploads: {
        Row: {
          bucket_id: string
          created_at: string
          id: string
          in_progress_size: number
          key: string
          owner_id: string | null
          upload_signature: string
          user_metadata: Json | null
          version: string
        }
        Insert: {
          bucket_id: string
          created_at?: string
          id: string
          in_progress_size?: number
          key: string
          owner_id?: string | null
          upload_signature: string
          user_metadata?: Json | null
          version: string
        }
        Update: {
          bucket_id?: string
          created_at?: string
          id?: string
          in_progress_size?: number
          key?: string
          owner_id?: string | null
          upload_signature?: string
          user_metadata?: Json | null
          version?: string
        }
        Relationships: [
          {
            foreignKeyName: "s3_multipart_uploads_bucket_id_fkey"
            columns: ["bucket_id"]
            isOneToOne: false
            referencedRelation: "buckets"
            referencedColumns: ["id"]
          },
        ]
      }
      s3_multipart_uploads_parts: {
        Row: {
          bucket_id: string
          created_at: string
          etag: string
          id: string
          key: string
          owner_id: string | null
          part_number: number
          size: number
          upload_id: string
          version: string
        }
        Insert: {
          bucket_id: string
          created_at?: string
          etag: string
          id?: string
          key: string
          owner_id?: string | null
          part_number: number
          size?: number
          upload_id: string
          version: string
        }
        Update: {
          bucket_id?: string
          created_at?: string
          etag?: string
          id?: string
          key?: string
          owner_id?: string | null
          part_number?: number
          size?: number
          upload_id?: string
          version?: string
        }
        Relationships: [
          {
            foreignKeyName: "s3_multipart_uploads_parts_bucket_id_fkey"
            columns: ["bucket_id"]
            isOneToOne: false
            referencedRelation: "buckets"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "s3_multipart_uploads_parts_upload_id_fkey"
            columns: ["upload_id"]
            isOneToOne: false
            referencedRelation: "s3_multipart_uploads"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      can_insert_object: {
        Args: {
          bucketid: string
          name: string
          owner: string
          metadata: Json
        }
        Returns: undefined
      }
      extension: {
        Args: {
          name: string
        }
        Returns: string
      }
      filename: {
        Args: {
          name: string
        }
        Returns: string
      }
      foldername: {
        Args: {
          name: string
        }
        Returns: string[]
      }
      get_size_by_bucket: {
        Args: Record<PropertyKey, never>
        Returns: {
          size: number
          bucket_id: string
        }[]
      }
      list_multipart_uploads_with_delimiter: {
        Args: {
          bucket_id: string
          prefix_param: string
          delimiter_param: string
          max_keys?: number
          next_key_token?: string
          next_upload_token?: string
        }
        Returns: {
          key: string
          id: string
          created_at: string
        }[]
      }
      list_objects_with_delimiter: {
        Args: {
          bucket_id: string
          prefix_param: string
          delimiter_param: string
          max_keys?: number
          start_after?: string
          next_token?: string
        }
        Returns: {
          name: string
          id: string
          metadata: Json
          updated_at: string
        }[]
      }
      operation: {
        Args: Record<PropertyKey, never>
        Returns: string
      }
      search: {
        Args: {
          prefix: string
          bucketname: string
          limits?: number
          levels?: number
          offsets?: number
          search?: string
          sortcolumn?: string
          sortorder?: string
        }
        Returns: {
          name: string
          id: string
          updated_at: string
          created_at: string
          last_accessed_at: string
          metadata: Json
        }[]
      }
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

