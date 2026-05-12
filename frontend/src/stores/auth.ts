import { defineStore } from 'pinia'
import { ref } from 'vue'
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
  const user = ref<User | null>(null)
  const accessToken = ref<string | null>(null)
  const errorMessage = ref<string | null>(null)

  function reset() {
    isAuthenticated.value = false
    user.value = null
    accessToken.value = null
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
