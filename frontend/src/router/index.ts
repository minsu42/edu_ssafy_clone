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
import type { RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/pages/auth/LoginPage.vue'),
    meta: { requiresAuth: false },
  },
  {
    path: '/',
    component: () => import('@/layouts/DefaultLayout.vue'),
    meta: { requiresAuth: true },
    children: [
      { path: '', redirect: '/dashboard' },
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/pages/DashboardPage.vue'),
      },
      {
        path: 'profile',
        name: 'Profile',
        component: () => import('@/pages/auth/ProfilePage.vue'),
      },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, _from, next) => {
  const isAuthenticated = !!localStorage.getItem('accessToken')
  if (to.meta.requiresAuth && !isAuthenticated) {
    next({ name: 'Login', query: { redirect: to.fullPath } })
  } else if (to.name === 'Login' && isAuthenticated) {
    next({ name: 'Dashboard' })
  } else {
    next()
  }
})

export default router
