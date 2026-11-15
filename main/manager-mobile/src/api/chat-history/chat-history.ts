import type {
  ChatMessage,
  ChatSessionsResponse,
  GetSessionsParams,
} from './types'
import { http } from '@/http/request/alova'

/**
 * Get the chat session list
 * @param agentId Agent ID
 * @param params Pagination parameters
 */
export function getChatSessions(agentId: string, params: GetSessionsParams) {
  return http.Get<ChatSessionsResponse>(`/agent/${agentId}/sessions`, {
    params,
    meta: {
      ignoreAuth: false,
      toast: false,
    },
    cacheFor: {
      expire: 0,
    },
  })
}

/**
 * Get chat record details
 * @param agentId Agent ID
 * @param sessionId Session ID
 */
export function getChatHistory(agentId: string, sessionId: string) {
  return http.Get<ChatMessage[]>(`/agent/${agentId}/chat-history/${sessionId}`, {
    meta: {
      ignoreAuth: false,
      toast: false,
    },
    cacheFor: {
      expire: -1,
    },
  })
}

/**
 * Get the audio download ID
 * @param audioId Audio ID
 */
export function getAudioId(audioId: string) {
  return http.Post<string>(`/agent/audio/${audioId}`, {}, {
    meta: {
      ignoreAuth: false,
      toast: false,
    },
  })
}

/**
 * Get the audio playback URL
 * @param downloadId Download ID
 */
export function getAudioPlayUrl(downloadId: string) {
  // Per the requirements document this returns binary directly, so we build the URL directly
  return `/agent/play/${downloadId}`
}
