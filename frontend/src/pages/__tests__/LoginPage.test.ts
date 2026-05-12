import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { setActivePinia, createPinia } from 'pinia'
import { createRouter, createMemoryHistory } from 'vue-router'
import LoginPage from '../auth/LoginPage.vue'
import { useAuthStore } from '@/stores/auth'

function buildRouter() {
  return createRouter({
    history: createMemoryHistory(),
    routes: [
      { path: '/login', component: LoginPage },
      { path: '/dashboard', component: { template: '<div>Dashboard</div>' } },
    ],
  })
}

describe('LoginPage', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    localStorage.clear()
  })

  it('이메일_비밀번호_입력_로그인_버튼_클릭_store.login_호출', async () => {
    const pinia = createPinia()
    setActivePinia(pinia)
    const router = buildRouter()
    await router.push('/login')

    const wrapper = mount(LoginPage, {
      global: { plugins: [pinia, router] },
    })
    const store = useAuthStore()
    const loginSpy = vi.spyOn(store, 'login').mockResolvedValue(undefined)

    await wrapper.find('input[type="email"]').setValue('test@ssafy.com')
    await wrapper.find('input[type="password"]').setValue('Test1234!')
    await wrapper.find('form').trigger('submit')
    await wrapper.vm.$nextTick()

    expect(loginSpy).toHaveBeenCalledWith('test@ssafy.com', 'Test1234!')
  })

  it('이메일_빈값_버튼_비활성화', async () => {
    const pinia = createPinia()
    setActivePinia(pinia)
    const router = buildRouter()

    const wrapper = mount(LoginPage, {
      global: { plugins: [pinia, router] },
    })

    await wrapper.find('input[type="password"]').setValue('Test1234!')
    const submitBtn = wrapper.find('button[type="submit"]')
    expect(submitBtn.attributes('disabled')).toBeDefined()
  })

  it('ERR_AUTH_001_오류_메시지_표시', async () => {
    const pinia = createPinia()
    setActivePinia(pinia)
    const router = buildRouter()

    const wrapper = mount(LoginPage, {
      global: { plugins: [pinia, router] },
    })
    const store = useAuthStore()
    store.errorMessage = '이메일 또는 비밀번호가 일치하지 않습니다.'

    await wrapper.vm.$nextTick()
    expect(wrapper.text()).toContain('이메일 또는 비밀번호가 일치하지 않습니다.')
  })
})
