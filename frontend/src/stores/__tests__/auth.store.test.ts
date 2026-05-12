import { beforeEach, describe, expect, it } from 'vitest'
import { createPinia, setActivePinia } from 'pinia'
import { AUTH_STORAGE_KEYS } from '@/lib/auth'
import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAuthStore } from '../auth'

describe('AuthStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    localStorage.clear()
  })

  it('로그인_성공_isAuthenticated_true_user_채워짐', async () => {
    const store = useAuthStore()

    await store.login('user@example.com', 'P@ssw0rd!')

    expect(store.isAuthenticated).toBe(true)
    expect(store.user?.email).toBe('user@example.com')
    expect(store.accessToken).toBe('access-token')
    expect(localStorage.getItem(AUTH_STORAGE_KEYS.refreshToken)).toBe('refresh-token')
    await store.login('test@ssafy.com', 'Test1234!')
    expect(store.isAuthenticated).toBe(true)
    expect(store.user).not.toBeNull()
    expect(store.user?.name).toBe('홍길동')
    expect(store.accessToken).toBe('mock-access-token')
    expect(localStorage.getItem('accessToken')).toBe('mock-access-token')
  })

  it('로그인_실패_ERR_AUTH_001_errorMessage_설정', async () => {
    const store = useAuthStore()

    await expect(store.login('user@example.com', 'wrong-password')).rejects.toThrow()
    expect(store.isAuthenticated).toBe(false)
    expect(store.errorMessage).toBe('이메일 또는 비밀번호가 올바르지 않습니다.')
    await expect(store.login('wrong@email.com', 'wrongpass')).rejects.toThrow()
    expect(store.isAuthenticated).toBe(false)
    expect(store.errorMessage).toBeTruthy()
    expect(store.user).toBeNull()
  })

  it('로그아웃_user_token_초기화', async () => {
    const store = useAuthStore()
    await store.login('user@example.com', 'P@ssw0rd!')
    await store.login('test@ssafy.com', 'Test1234!')
    expect(store.isAuthenticated).toBe(true)

    await store.logout()

    expect(store.isAuthenticated).toBe(false)
    expect(store.user).toBeNull()
    expect(store.accessToken).toBeNull()
    expect(store.refreshToken).toBeNull()
    expect(localStorage.getItem('accessToken')).toBeNull()
    expect(localStorage.getItem('refreshToken')).toBeNull()
  })

  it('토큰_갱신_성공_accessToken_갱신', async () => {
    const store = useAuthStore()
    localStorage.setItem(AUTH_STORAGE_KEYS.refreshToken, 'refresh-token')

    store.hydrate()
    const refreshed = await store.refreshSession()

    expect(refreshed).toBe(true)
    expect(store.accessToken).toBe('refreshed-access-token')
    expect(store.refreshToken).toBe('refreshed-refresh-token')
    localStorage.setItem('refreshToken', 'mock-refresh-token')

    const newToken = await store.refreshTokens()

    expect(newToken).toBe('mock-access-token-refreshed')
    expect(store.accessToken).toBe('mock-access-token-refreshed')
    expect(localStorage.getItem('accessToken')).toBe('mock-access-token-refreshed')
  })
})
