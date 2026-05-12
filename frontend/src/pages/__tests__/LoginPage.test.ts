// @vitest-environment happy-dom

import { fireEvent, render, screen, waitFor } from '@testing-library/vue'
import { createPinia, setActivePinia } from 'pinia'
import { createMemoryHistory, createRouter } from 'vue-router'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import LoginPage from '@/pages/auth/LoginPage.vue'
import ProfilePage from '@/pages/auth/ProfilePage.vue'
import { useAuthStore } from '@/stores/auth'

describe('LoginPage', () => {
  let pinia: ReturnType<typeof createPinia>
  let router: ReturnType<typeof createRouter>

  beforeEach(async () => {
    localStorage.clear()
    pinia = createPinia()
    setActivePinia(pinia)
    router = createRouter({
      history: createMemoryHistory(),
      routes: [
        { path: '/login', component: LoginPage },
        { path: '/profile', component: ProfilePage, meta: { requiresAuth: true, title: '내 프로필' } },
        { path: '/', redirect: '/profile' },
      ],
    })
    await router.push('/login')
    await router.isReady()
  })

  it('이메일_비밀번호_입력_로그인_버튼_클릭_store.login_호출', async () => {
    const store = useAuthStore()
    const loginSpy = vi.spyOn(store, 'login').mockResolvedValue(undefined)

    render(LoginPage, {
      global: {
        plugins: [pinia, router],
      },
    })

    await fireEvent.update(screen.getByLabelText('이메일'), 'user@example.com')
    await fireEvent.update(screen.getByLabelText('비밀번호'), 'P@ssw0rd!')
    await fireEvent.click(screen.getByRole('button', { name: '로그인' }))

    expect(loginSpy).toHaveBeenCalledWith('user@example.com', 'P@ssw0rd!')
  })

  it('이메일_빈값_버튼_비활성화', async () => {
    render(LoginPage, {
      global: {
        plugins: [pinia, router],
      },
    })

    await fireEvent.update(screen.getByLabelText('비밀번호'), 'P@ssw0rd!')

    expect((screen.getByRole('button', { name: '로그인' }) as HTMLButtonElement).disabled).toBe(true)
  })

  it('ERR_AUTH_001_오류_메시지_표시', async () => {
    const store = useAuthStore()
    vi.spyOn(store, 'login').mockImplementation(async () => {
      store.errorMessage = '이메일 또는 비밀번호가 올바르지 않습니다.'
      throw new Error('ERR-AUTH-001')
    })

    render(LoginPage, {
      global: {
        plugins: [pinia, router],
      },
    })

    await fireEvent.update(screen.getByLabelText('이메일'), 'user@example.com')
    await fireEvent.update(screen.getByLabelText('비밀번호'), 'wrong-password')
    await fireEvent.click(screen.getByRole('button', { name: '로그인' }))

    await waitFor(() => {
      expect(screen.getByRole('alert').textContent).toBe('이메일 또는 비밀번호가 올바르지 않습니다.')
    })
  })
})
