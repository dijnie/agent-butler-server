// Voiceprint info response type
export interface VoicePrint {
  id: string
  audioId: string
  sourceName: string
  introduce: string
  createDate: string
}

// Voice chat record type
export interface ChatHistory {
  content: string
  audioId: string
}

// Speaker creation data type
export interface CreateSpeakerData {
  agentId: string
  audioId: string
  sourceName: string
  introduce: string
}

// Common response type
export interface ApiResponse<T = any> {
  code: number
  msg: string
  data: T
}
