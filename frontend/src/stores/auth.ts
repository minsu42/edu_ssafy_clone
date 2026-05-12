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
  }
})
