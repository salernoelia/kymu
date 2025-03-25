export interface VideoClip {
  id: string;
  source: string;
  name: string;
  startTime: number;
  endTime: number;
  effects: VideoEffect[];
  sourceFile?: File | Blob; // Add the sourceFile property to hold the actual file
}

export interface VideoEffect {
  id: string;
  type: string;
  params: Record<string, any>;
}

export interface ExportSettings {
  format: string;
  quality: string;
  width: number;
  height: number;
}
