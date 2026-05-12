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
    await store.login('test@ssafy.com', 'Test1234!')
    expect(store.isAuthenticated).toBe(true)
    expect(store.user).not.toBeNull()
    expect(store.user?.name).toBe('홍길동')
    expect(store.accessToken).toBe('mock-access-token')
    expect(localStorage.getItem('accessToken')).toBe('mock-access-token')
  })

  it('로그인_실패_ERR_AUTH_001_errorMessage_설정', async () => {
    const store = useAuthStore()
    await expect(store.login('wrong@email.com', 'wrongpass')).rejects.toThrow()
    expect(store.isAuthenticated).toBe(false)
    expect(store.errorMessage).toBeTruthy()
    expect(store.user).toBeNull()
  })

  it('로그아웃_user_token_초기화', async () => {
    const store = useAuthStore()
    await store.login('test@ssafy.com', 'Test1234!')
    expect(store.isAuthenticated).toBe(true)

    await store.logout()

    expect(store.isAuthenticated).toBe(false)
    expect(store.user).toBeNull()
    expect(store.accessToken).toBeNull()
    expect(localStorage.getItem('accessToken')).toBeNull()
    expect(localStorage.getItem('refreshToken')).toBeNull()
  })

  it('토큰_갱신_성공_accessToken_갱신', async () => {
    const store = useAuthStore()
    localStorage.setItem('refreshToken', 'mock-refresh-token')

    const newToken = await store.refreshTokens()

    expect(newToken).toBe('mock-access-token-refreshed')
    expect(store.accessToken).toBe('mock-access-token-refreshed')
    expect(localStorage.getItem('accessToken')).toBe('mock-access-token-refreshed')
  })
})
