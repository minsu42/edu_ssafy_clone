<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const heroTitle = computed(() => String(route.meta.title ?? 'SSAFY 학습 포털'))
const userInitial = computed(() => authStore.user?.name?.slice(0, 1) ?? 'S')

async function handleLogout() {
  await authStore.logout()
  await router.push('/login')
}
</script>

<template>
  <div class="app-shell">
    <header class="gnb">
      <div class="gnb__inner">
        <div class="gnb__brand">SAMSUNG<br />SW<br />ACADEMY</div>
        <nav class="gnb__nav" aria-label="주요 메뉴">
          <a href="#" class="gnb__link">마이캠퍼스</a>
          <a href="#" class="gnb__link">강의실</a>
          <a href="#" class="gnb__link">커뮤니티</a>
          <a href="#" class="gnb__link">HELP DESK</a>
          <a href="#" class="gnb__link">멘토링 게시판</a>
        </nav>

        <div class="gnb__actions">
          <RouterLink to="/profile" class="notification-link" aria-label="프로필 페이지">
            <span class="notification-link__icon">🔔</span>
            <span class="notification-link__badge">0</span>
          </RouterLink>

          <RouterLink to="/profile" class="profile-chip">
            <span class="avatar">{{ userInitial }}</span>
            <span class="profile-chip__meta">
              <strong>{{ authStore.user?.name ?? '사용자' }}</strong>
              <small>{{ authStore.user?.email ?? 'user@example.com' }}</small>
            </span>
          </RouterLink>

          <button type="button" class="button button--secondary" @click="handleLogout">
            로그아웃
          </button>
        </div>
      </div>
    </header>

    <main>
      <section class="hero">
        <div class="hero__overlay">
          <h1>{{ heroTitle }}</h1>
        </div>
      </section>

      <section class="content-shell">
        <slot />
      </section>
    </main>

    <footer class="footer">
      <div class="footer__inner">
        <div>
          <strong>SSAFY</strong>
          <p>본 사이트의 콘텐츠는 교육용 예시입니다.</p>
        </div>
        <div class="footer__links">
          <a href="#">이용약관</a>
          <a href="#">개인정보처리방침</a>
        </div>
      </div>
    </footer>
  </div>
</template>
