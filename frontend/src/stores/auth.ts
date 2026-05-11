import { defineStore } from 'pinia'
import { ref } from 'vue'

interface User {
  id: number
  name: string
  role: 'STUDENT' | 'ADMIN' | 'OPERATOR' | 'MENTOR'
}

export const useAuthStore = defineStore('auth', () => {
  const isAuthenticated = ref(false)
  const user = ref<User | null>(null)
  const accessToken = ref<string | null>(null)

  function reset() {
    isAuthenticated.value = false
    user.value = null
    accessToken.value = null
  }

  return { isAuthenticated, user, accessToken, reset }
})
