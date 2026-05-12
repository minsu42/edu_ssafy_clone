<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const router = useRouter()
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const route = useRoute()
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
const isLoading = ref(false)

async function handleSubmit() {
  if (!email.value || !password.value) return
  isLoading.value = true
  try {
    await authStore.login(email.value, password.value)
    const redirect = route.query.redirect as string | undefined
    router.push(redirect ?? '/dashboard')
  } catch {
    // errorMessage는 store에서 관리
  } finally {
    isLoading.value = false
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
  <div class="login-wrapper">
    <div class="login-card">
      <div class="login-brand">
        <div class="brand-logo">
          <span class="brand-top">SAMSUNG</span>
          <span class="brand-mid">SDS ACADEMY</span>
          <span class="brand-bot">FOR YOUTH</span>
        </div>
        <h1 class="brand-name">에듀싸피</h1>
      </div>

      <form class="login-form" @submit.prevent="handleSubmit" novalidate>
        <div class="form-group">
          <label for="email" class="form-label">이메일</label>
          <input
            id="email"
            v-model="email"
            type="email"
            class="form-input"
            placeholder="이메일을 입력하세요"
            autocomplete="email"
          />
        </div>
        <div class="form-group">
          <label for="password" class="form-label">비밀번호</label>
          <input
            id="password"
            v-model="password"
            type="password"
            class="form-input"
            placeholder="비밀번호를 입력하세요"
            autocomplete="current-password"
          />
        </div>

        <p v-if="authStore.errorMessage" class="error-message" role="alert">
          {{ authStore.errorMessage }}
        </p>

        <button
          type="submit"
          class="submit-btn"
          :disabled="!email || !password || isLoading"
        >
          {{ isLoading ? '로그인 중...' : '로그인' }}
        </button>
      </form>
    </div>
  </div>
</template>

<style scoped>
.login-wrapper {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #1a2332 0%, #2d4a6b 100%);
  padding: 24px;
}

.login-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  padding: 48px 40px;
  width: 100%;
  max-width: 400px;
}

.login-brand {
  text-align: center;
  margin-bottom: 32px;
}

.brand-logo {
  display: inline-flex;
  flex-direction: column;
  line-height: 1.2;
  font-size: 9px;
  font-weight: 700;
  letter-spacing: 0.06em;
  border: 1.5px solid #3a7bd5;
  padding: 6px 10px;
  margin-bottom: 12px;
}

.brand-top,
.brand-bot { color: #3a7bd5; }
.brand-mid { color: #1a2332; }

.brand-name {
  font-size: 22px;
  font-weight: 700;
  color: #1a2332;
  margin: 0;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-label {
  font-size: 13px;
  font-weight: 600;
  color: #374151;
}

.form-input {
  padding: 10px 14px;
  border: 1.5px solid #d1d5db;
  border-radius: 6px;
  font-size: 14px;
  transition: border-color 0.15s, box-shadow 0.15s;
  outline: none;
  color: #111827;
}

.form-input:focus {
  border-color: #3a7bd5;
  box-shadow: 0 0 0 3px rgba(58, 123, 213, 0.15);
}

.form-input::placeholder {
  color: #9ca3af;
}

.error-message {
  font-size: 13px;
  color: #dc2626;
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 6px;
  padding: 8px 12px;
  margin: 0;
}

.submit-btn {
  padding: 12px;
  background: #3a7bd5;
  color: #fff;
  border: none;
  border-radius: 6px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.15s, opacity 0.15s;
  margin-top: 4px;
}

.submit-btn:hover:not(:disabled) {
  background: #2d6abc;
}

.submit-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
