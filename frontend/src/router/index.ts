import { createRouter, createWebHistory } from 'vue-router'
import { pinia } from '@/app/pinia'
import LoginPage from '@/pages/auth/LoginPage.vue'
import ProfilePage from '@/pages/auth/ProfilePage.vue'
import { useAuthStore } from '@/stores/auth'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      redirect: '/profile',
    },
    {
      path: '/login',
      name: 'login',
      component: LoginPage,
      meta: {
        title: '로그인',
        guestOnly: true,
      },
    },
    {
      path: '/profile',
      name: 'profile',
      component: ProfilePage,
      meta: {
        title: '내 프로필',
        requiresAuth: true,
      },
    },
  ],
})

router.beforeEach(async (to) => {
  const authStore = useAuthStore(pinia)

  if (to.meta.requiresAuth) {
    if (authStore.isAuthenticated) {
      return true
    }

    const restored = await authStore.bootstrapSession()
    if (!restored) {
      return {
        name: 'login',
        query: {
          redirect: to.fullPath,
        },
      }
    }
  }

  if (to.meta.guestOnly && authStore.isAuthenticated) {
    return { name: 'profile' }
  }

  return true
})

export default router
