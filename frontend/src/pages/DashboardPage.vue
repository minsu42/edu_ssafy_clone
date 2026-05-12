<script setup lang="ts">
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
</script>

<template>
  <div class="dashboard-page">
    <div class="hero">
      <div class="hero-inner">
        <h1 class="hero-title">안녕하세요, {{ authStore.user?.name ?? '' }}님</h1>
        <p class="hero-sub">에듀싸피에 오신 것을 환영합니다.</p>
      </div>
    </div>
    <div class="content-area">
      <p class="placeholder">대시보드 화면은 P2-FE(FR-DASHBOARD)에서 구현됩니다.</p>
    </div>
  </div>
</template>

<style scoped>
.dashboard-page {
  min-height: calc(100vh - 56px - 120px);
}

.hero {
  background: #1a2332;
  color: #fff;
  padding: 48px 16px;
}

.hero-inner {
  max-width: 1280px;
  margin: 0 auto;
}

.hero-title {
  font-size: 28px;
  font-weight: 700;
  margin: 0 0 8px;
}

.hero-sub {
  font-size: 15px;
  color: rgba(255, 255, 255, 0.7);
  margin: 0;
}

.content-area {
  max-width: 1280px;
  margin: 48px auto;
  padding: 0 16px;
}

.placeholder {
  color: #888;
  font-size: 14px;
  text-align: center;
  padding: 48px;
  border: 1px dashed #ccc;
  border-radius: 8px;
}
</style>
