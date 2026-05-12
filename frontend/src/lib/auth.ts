export const AUTH_ERROR_MESSAGES: Record<string, string> = {
  'ERR-AUTH-001': '이메일 또는 비밀번호가 올바르지 않습니다.',
  'ERR-AUTH-002': '비활성화되었거나 탈퇴한 계정입니다.',
  'ERR-AUTH-003': '로그인 세션이 만료되었습니다. 다시 로그인해 주세요.',
  'ERR-AUTH-004': '유효하지 않은 로그인 정보입니다. 다시 로그인해 주세요.',
  'ERR-CMN-003': '필수 입력값을 확인해 주세요.',
  'ERR-CMN-004': '로그인이 필요합니다.',
}

export type UserRole = 'STUDENT' | 'ADMIN' | 'OPERATOR' | 'MENTOR'

export interface AuthUser {
  id: number
  email: string
  name: string
  role: UserRole
  profileImageUrl: string | null
}

export interface Profile extends AuthUser {
  studentNo: string | null
  generation: number | null
  region: string | null
  classNo: number | null
  phoneNumber: string | null
  emergencyPhoneNumber: string | null
  zipCode: string | null
  address: string | null
  addressDetail: string | null
  status: 'ACTIVE' | 'INACTIVE' | 'WITHDRAWN'
  createdAt: string
}

export interface ApiErrorPayload {
  success: false
  code?: string
  message?: string
  timestamp?: string
}

export class ApiError extends Error {
  code?: string

  constructor(message: string, code?: string) {
    super(message)
    this.name = 'ApiError'
    this.code = code
  }
}

export const AUTH_STORAGE_KEYS = {
  accessToken: 'edu-ssafy.auth.accessToken',
  refreshToken: 'edu-ssafy.auth.refreshToken',
  user: 'edu-ssafy.auth.user',
} as const

export function mapAuthError(error: unknown) {
  if (error instanceof ApiError && error.code) {
    return AUTH_ERROR_MESSAGES[error.code] ?? error.message
  }

  if (error instanceof Error && error.message) {
    return error.message
  }

  return '요청을 처리하지 못했습니다. 잠시 후 다시 시도해 주세요.'
}
