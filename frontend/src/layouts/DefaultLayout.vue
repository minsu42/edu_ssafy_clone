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
import { useAuthStore } from '@/stores/auth'
import { useRouter } from 'vue-router'

const authStore = useAuthStore()
const router = useRouter()
</script>

<template>
  <div class="app-wrapper">
    <header class="gnb">
      <div class="gnb-inner">
        <div class="gnb-left">
          <RouterLink to="/dashboard" class="logo">
            <div class="logo-box">
              <span class="logo-top">SAMSUNG</span>
              <span class="logo-mid">SDS ACADEMY</span>
              <span class="logo-bot">FOR YOUTH</span>
            </div>
          </RouterLink>
          <nav class="gnb-nav">
            <RouterLink to="/mycampus" class="nav-link" active-class="nav-link--active">마이캠퍼스</RouterLink>
            <RouterLink to="/classroom" class="nav-link" active-class="nav-link--active">강의실</RouterLink>
            <RouterLink to="/community" class="nav-link" active-class="nav-link--active">커뮤니티</RouterLink>
            <RouterLink to="/helpdesk" class="nav-link" active-class="nav-link--active">HELP DESK</RouterLink>
            <RouterLink to="/mentoring" class="nav-link" active-class="nav-link--active">멘토링 게시판</RouterLink>
          </nav>
        </div>
        <div class="gnb-right">
          <RouterLink to="/notifications" class="icon-btn" aria-label="알림">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6V11c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/>
            </svg>
          </RouterLink>
          <button class="user-profile" @click="router.push('/profile')" type="button">
            <img
              v-if="authStore.user?.profileImageUrl"
              :src="authStore.user.profileImageUrl"
              alt="프로필"
              class="avatar"
            />
            <div v-else class="avatar avatar-placeholder">
              {{ authStore.user?.name?.charAt(0) ?? '?' }}
            </div>
            <span class="username">{{ authStore.user?.name ?? '' }}</span>
            <svg class="arrow" width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
              <path d="M7 10l5 5 5-5z"/>
            </svg>
          </button>
          <div class="external-links">
            <a href="#" class="ext-btn btn-job">JOB SSAFY</a>
            <a href="#" class="ext-btn btn-git">SSAFY GIT</a>
            <a href="#" class="ext-btn btn-meeting">Meeting! SSAFY</a>
          </div>
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
    <main class="main-content">
      <RouterView />
    </main>

    <footer class="gnb-footer">
      <div class="footer-inner">
        <div class="footer-links">
          <a href="#">이용약관</a>
          <span class="divider">|</span>
          <a href="#">개인정보처리방침</a>
        </div>
        <p class="footer-copy">
          본 사이트의 콘텐츠는 저작권법의 보호를 받는 바 무단 전재, 복사, 배포 등을 금합니다.
        </p>
        <p class="footer-copy">Copyright © SAMSUNG All Rights Reserved.</p>
      </div>
    </footer>
  </div>
</template>

<style scoped>
.app-wrapper {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f4f5f7;
}

.gnb {
  background: #1a2332;
  color: #fff;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

.gnb-inner {
  max-width: 1280px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 56px;
  padding: 0 16px;
}

.gnb-left {
  display: flex;
  align-items: center;
  gap: 24px;
}

.logo {
  display: flex;
  align-items: center;
  text-decoration: none;
  color: #fff;
}

.logo-box {
  display: flex;
  flex-direction: column;
  line-height: 1.1;
  font-size: 8px;
  font-weight: 700;
  letter-spacing: 0.05em;
  border: 1px solid #3a7bd5;
  padding: 4px 6px;
}

.logo-top { color: #3a7bd5; }
.logo-mid { color: #fff; }
.logo-bot { color: #3a7bd5; }

.gnb-nav {
  display: flex;
  align-items: center;
  gap: 4px;
}

.nav-link {
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  font-size: 14px;
  padding: 8px 12px;
  border-radius: 4px;
  transition: color 0.15s, background 0.15s;
  white-space: nowrap;
}

.nav-link:hover,
.nav-link--active {
  color: #fff;
  background: rgba(255, 255, 255, 0.1);
}

.gnb-right {
  display: flex;
  align-items: center;
  gap: 8px;
}

.icon-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  padding: 6px;
  border-radius: 4px;
  transition: color 0.15s;
  position: relative;
}

.icon-btn:hover {
  color: #fff;
}

.user-profile {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  background: none;
  border: none;
  color: #fff;
  padding: 4px 8px;
  border-radius: 4px;
  transition: background 0.15s;
}

.user-profile:hover {
  background: rgba(255, 255, 255, 0.1);
}

.avatar {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  object-fit: cover;
}

.avatar-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #3a7bd5;
  color: #fff;
  font-size: 12px;
  font-weight: 700;
}

.username {
  font-size: 13px;
  font-weight: 500;
}

.arrow {
  opacity: 0.7;
}

.external-links {
  display: flex;
  gap: 4px;
}

.ext-btn {
  font-size: 11px;
  font-weight: 600;
  padding: 4px 8px;
  border-radius: 4px;
  text-decoration: none;
  white-space: nowrap;
  transition: opacity 0.15s;
}

.ext-btn:hover { opacity: 0.85; }

.btn-job {
  background: #444;
  color: #fff;
}

.btn-git {
  background: #3a7bd5;
  color: #fff;
}

.btn-meeting {
  background: #00b894;
  color: #fff;
}

.main-content {
  flex: 1;
}

.gnb-footer {
  background: #2d3748;
  color: rgba(255, 255, 255, 0.6);
  padding: 24px 16px;
}

.footer-inner {
  max-width: 1280px;
  margin: 0 auto;
  font-size: 12px;
}

.footer-links {
  display: flex;
  gap: 8px;
  margin-bottom: 8px;
}

.footer-links a {
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
}

.footer-links a:hover { text-decoration: underline; }

.divider { opacity: 0.4; }

.footer-copy {
  margin: 2px 0;
  line-height: 1.5;
}
</style>
