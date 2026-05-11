import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAuthStore } from '../auth'

describe('AuthStore — smoke', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('초기_상태_isAuthenticated_false_user_null', () => {
    const store = useAuthStore()
    expect(store.isAuthenticated).toBe(false)
    expect(store.user).toBeNull()
    expect(store.accessToken).toBeNull()
  })
})
