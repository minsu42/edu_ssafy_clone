import { defineStore } from 'pinia'
import { ref } from 'vue'
import {
  AUTH_STORAGE_KEYS,
  ApiError,
  type AuthUser,
  type Profile,
  mapAuthError,
} from '@/lib/auth'
import { apiRequest } from '@/lib/api'

interface LoginResponse {
  accessToken: string
  refreshToken: string
  user: AuthUser
}

interface TokenResponse {
  accessToken: string
  refreshToken: string
}

function readStoredUser() {
  const raw = localStorage.getItem(AUTH_STORAGE_KEYS.user)

  if (!raw) {
    return null
  }

  try {
    return JSON.parse(raw) as AuthUser
  } catch {
    return null
  }
import axios from 'axios'
import api from '@/api/axios'

export interface User {
  id: number
  email: string
  name: string
  studentNo?: string | null
  generation?: number | null
  region?: string | null
  classNo?: number | null
  phoneNumber?: string | null
  emergencyPhoneNumber?: string | null
  zipCode?: string | null
  address?: string | null
  addressDetail?: string | null
  role: 'STUDENT' | 'ADMIN' | 'OPERATOR' | 'MENTOR'
  status?: 'ACTIVE' | 'INACTIVE' | 'WITHDRAWN'
  profileImageUrl: string | null
  createdAt?: string
}

export interface UpdateProfilePayload {
  name?: string
  phoneNumber?: string
  zipCode?: string
  address?: string
  addressDetail?: string
  profileFileId?: number
}

export const useAuthStore = defineStore('auth', () => {
  const isAuthenticated = ref(false)
  const user = ref<AuthUser | null>(null)
  const profile = ref<Profile | null>(null)
  const accessToken = ref<string | null>(null)
  const refreshToken = ref<string | null>(null)
  const errorMessage = ref('')
  const isLoading = ref(false)
  const isLoadingProfile = ref(false)

  function persistSession() {
    if (accessToken.value) {
      localStorage.setItem(AUTH_STORAGE_KEYS.accessToken, accessToken.value)
    } else {
      localStorage.removeItem(AUTH_STORAGE_KEYS.accessToken)
    }

    if (refreshToken.value) {
      localStorage.setItem(AUTH_STORAGE_KEYS.refreshToken, refreshToken.value)
    } else {
      localStorage.removeItem(AUTH_STORAGE_KEYS.refreshToken)
    }

    if (user.value) {
      localStorage.setItem(AUTH_STORAGE_KEYS.user, JSON.stringify(user.value))
    } else {
      localStorage.removeItem(AUTH_STORAGE_KEYS.user)
    }
  }

  function applySession(tokens: TokenResponse, nextUser?: AuthUser | null) {
    accessToken.value = tokens.accessToken
    refreshToken.value = tokens.refreshToken

    if (typeof nextUser !== 'undefined') {
      user.value = nextUser
    }

    isAuthenticated.value = true
    persistSession()
  }

  function clearError() {
    errorMessage.value = ''
  }
  const errorMessage = ref<string | null>(null)

  function reset() {
    isAuthenticated.value = false
    user.value = null
    profile.value = null
    accessToken.value = null
    refreshToken.value = null
    isLoading.value = false
    isLoadingProfile.value = false
    clearError()
    persistSession()
  }

  function hydrate() {
    accessToken.value = localStorage.getItem(AUTH_STORAGE_KEYS.accessToken)
    refreshToken.value = localStorage.getItem(AUTH_STORAGE_KEYS.refreshToken)
    user.value = readStoredUser()
    isAuthenticated.value = Boolean(accessToken.value && user.value)
  }

  async function login(email: string, password: string) {
    isLoading.value = true
    clearError()

    try {
      const response = await apiRequest<LoginResponse>('/auth/login', {
        method: 'POST',
        body: { email, password },
      })

      applySession(
        {
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        },
        response.user,
      )
      profile.value = null
    } catch (error) {
      reset()
      errorMessage.value = mapAuthError(error)
      throw error
    } finally {
      isLoading.value = false
    }
  }

  async function refreshSession() {
    if (!refreshToken.value) {
      reset()
      return false
    }

    try {
      const response = await apiRequest<TokenResponse>('/auth/refresh', {
        method: 'POST',
        body: { refreshToken: refreshToken.value },
      })

      applySession(response)
      return true
    } catch (error) {
      reset()
      errorMessage.value = mapAuthError(error)
      return false
    }
  }

  async function authenticatedRequest<T>(path: string, init: RequestInit = {}, retry = true) {
    if (!accessToken.value) {
      const restored = await refreshSession()

      if (!restored || !accessToken.value) {
        throw new ApiError('로그인이 필요합니다.', 'ERR-CMN-004')
      }
    }

    try {
      return await apiRequest<T>(path, {
        ...init,
        headers: {
          ...(init.headers ?? {}),
          Authorization: `Bearer ${accessToken.value}`,
        },
      })
    } catch (error) {
      if (retry && error instanceof ApiError && ['ERR-AUTH-003', 'ERR-AUTH-004'].includes(error.code ?? '')) {
        const restored = await refreshSession()
        if (restored) {
          return authenticatedRequest<T>(path, init, false)
        }
      }

      throw error
    }
  }

  async function fetchProfile() {
    isLoadingProfile.value = true
    clearError()

    try {
      const nextProfile = await authenticatedRequest<Profile>('/users/me', {
        method: 'GET',
      })

      profile.value = nextProfile
      user.value = {
        id: nextProfile.id,
        email: nextProfile.email,
        name: nextProfile.name,
        role: nextProfile.role,
        profileImageUrl: nextProfile.profileImageUrl,
      }
      isAuthenticated.value = true
      persistSession()
      return nextProfile
    } catch (error) {
      errorMessage.value = mapAuthError(error)
      throw error
    } finally {
      isLoadingProfile.value = false
    }
  }

  async function bootstrapSession() {
    hydrate()

    if (!refreshToken.value && !accessToken.value) {
      return false
    }

    if (accessToken.value && user.value) {
      isAuthenticated.value = true
      return true
    }

    const refreshed = await refreshSession()
    if (!refreshed) {
      return false
    }

    try {
      await fetchProfile()
      return true
    } catch {
      reset()
      return false
    }
  }

  async function logout() {
    try {
      if (accessToken.value) {
        await authenticatedRequest('/auth/logout', { method: 'POST' }, false)
      }
    } catch {
      // ignore logout API errors and clear local session regardless
    } finally {
      reset()
    }
    errorMessage.value = null
  }

  function initializeFromStorage() {
    const storedToken = localStorage.getItem('accessToken')
    const storedUser = localStorage.getItem('user')
    if (storedToken && storedUser) {
      accessToken.value = storedToken
      user.value = JSON.parse(storedUser)
      isAuthenticated.value = true
    }
  }

  async function login(email: string, password: string) {
    errorMessage.value = null
    try {
      const res = await api.post('/auth/login', { email, password })
      const { accessToken: token, refreshToken, user: userData } = res.data.data
      accessToken.value = token
      user.value = userData
      isAuthenticated.value = true
      localStorage.setItem('accessToken', token)
      localStorage.setItem('refreshToken', refreshToken)
      localStorage.setItem('user', JSON.stringify(userData))
    } catch (err) {
      if (axios.isAxiosError(err) && err.response) {
        errorMessage.value = err.response.data.message ?? '로그인에 실패했습니다.'
      } else {
        errorMessage.value = '로그인에 실패했습니다.'
      }
      throw err
    }
  }

  async function logout() {
    try {
      await api.post('/auth/logout')
    } catch {
      // 실패해도 로컬 상태 초기화
    } finally {
      reset()
      localStorage.removeItem('accessToken')
      localStorage.removeItem('refreshToken')
      localStorage.removeItem('user')
    }
  }

  async function fetchProfile() {
    const res = await api.get('/users/me')
    user.value = res.data.data
    localStorage.setItem('user', JSON.stringify(user.value))
    return user.value
  }

  async function updateProfile(payload: UpdateProfilePayload) {
    const res = await api.patch('/users/me', payload)
    user.value = res.data.data
    localStorage.setItem('user', JSON.stringify(user.value))
    return user.value
  }

  async function changePassword(currentPassword: string, newPassword: string) {
    errorMessage.value = null
    try {
      await api.put('/users/me/password', { currentPassword, newPassword })
    } catch (err) {
      if (axios.isAxiosError(err) && err.response) {
        errorMessage.value = err.response.data.message ?? '비밀번호 변경에 실패했습니다.'
      } else {
        errorMessage.value = '비밀번호 변경에 실패했습니다.'
      }
      throw err
    }
  }

  async function refreshTokens() {
    const refreshToken = localStorage.getItem('refreshToken')
    if (!refreshToken) throw new Error('저장된 리프레시 토큰 없음')
    const res = await api.post('/auth/refresh', { refreshToken })
    const { accessToken: newToken, refreshToken: newRefresh } = res.data.data
    accessToken.value = newToken
    localStorage.setItem('accessToken', newToken)
    localStorage.setItem('refreshToken', newRefresh)
    return newToken
  }

  async function withdraw() {
    await api.delete('/users/me')
    reset()
    localStorage.removeItem('accessToken')
    localStorage.removeItem('refreshToken')
    localStorage.removeItem('user')
  }

  return {
    isAuthenticated,
    user,
    profile,
    accessToken,
    refreshToken,
    errorMessage,
    isLoading,
    isLoadingProfile,
    hydrate,
    login,
    logout,
    reset,
    fetchProfile,
    refreshSession,
    bootstrapSession,
    clearError,
    accessToken,
    errorMessage,
    reset,
    initializeFromStorage,
    login,
    logout,
    fetchProfile,
    updateProfile,
    changePassword,
    refreshTokens,
    withdraw,
  }
})
