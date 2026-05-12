<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const email = ref('')
const password = ref('')

const isDisabled = computed(() => {
  return !email.value.trim() || !password.value.trim() || authStore.isLoading
})

async function handleSubmit() {
  if (isDisabled.value) {
    return
  }

  try {
    await authStore.login(email.value, password.value)

    const redirect = typeof route.query.redirect === 'string' ? route.query.redirect : '/profile'
    await router.replace(redirect)
  } catch {
    // store state already contains the user-facing error message
  }
}
</script>

<template>
  <main class="login-page">
    <section class="login-card">
      <div class="login-card__header">
        <p class="eyebrow">edu.ssafy.com clone</p>
        <h1>SSAFY 학습 포털 로그인</h1>
        <p class="login-card__description">
          로그인 후 프로필, 알림, 후속 학습 화면으로 이동할 수 있습니다.
        </p>
      </div>

      <form class="login-form" @submit.prevent="handleSubmit">
        <label class="field">
          <span>이메일</span>
          <input
            v-model="email"
            autocomplete="email"
            inputmode="email"
            name="email"
            placeholder="user@example.com"
            type="email"
          />
        </label>

        <label class="field">
          <span>비밀번호</span>
          <input
            v-model="password"
            autocomplete="current-password"
            name="password"
            placeholder="비밀번호를 입력하세요"
            type="password"
          />
        </label>

        <p v-if="authStore.errorMessage" class="form-error" role="alert">
          {{ authStore.errorMessage }}
        </p>

        <button class="button button--primary button--block" :disabled="isDisabled" type="submit">
          {{ authStore.isLoading ? '로그인 중...' : '로그인' }}
        </button>
      </form>
    </section>
  </main>
</template>
