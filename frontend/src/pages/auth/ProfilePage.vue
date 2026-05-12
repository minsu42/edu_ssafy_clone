<script setup lang="ts">
import { computed, onMounted } from 'vue'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

const profileRows = computed(() => {
  const profile = authStore.profile

  if (!profile) {
    return []
  }

  return [
    { label: '이름', value: profile.name },
    { label: '이메일', value: profile.email },
    { label: '학번', value: profile.studentNo ?? '-' },
    { label: '기수 / 반', value: [profile.generation, profile.classNo].filter(Boolean).join('기 / ') || '-' },
    { label: '지역', value: profile.region ?? '-' },
    { label: '연락처', value: profile.phoneNumber ?? '-' },
    { label: '주소', value: [profile.address, profile.addressDetail].filter(Boolean).join(' ') || '-' },
    { label: '권한', value: profile.role },
    { label: '상태', value: profile.status },
  ]
})

onMounted(async () => {
  if (!authStore.profile) {
    try {
      await authStore.fetchProfile()
    } catch {
      // store handles redirect state via error/reset
    }
  }
})
</script>

<template>
  <DefaultLayout>
    <div class="profile-page">
      <div class="content-tabs">
        <button class="content-tabs__item content-tabs__item--active" type="button">기본 정보</button>
        <button class="content-tabs__item" type="button">학습 현황</button>
      </div>

      <section class="profile-card">
        <header class="profile-card__header">
          <div>
            <p class="eyebrow">FR-AUTH-PROFILE-001</p>
            <h2>내 프로필</h2>
          </div>
          <span class="status-badge">{{ authStore.profile?.status ?? 'ACTIVE' }}</span>
        </header>

        <p v-if="authStore.isLoadingProfile" class="muted">프로필을 불러오는 중입니다...</p>
        <p v-else-if="authStore.errorMessage" class="form-error">{{ authStore.errorMessage }}</p>

        <dl v-else class="profile-grid">
          <div v-for="row in profileRows" :key="row.label" class="profile-grid__row">
            <dt>{{ row.label }}</dt>
            <dd>{{ row.value }}</dd>
          </div>
        </dl>
      </section>
    </div>
  </DefaultLayout>
</template>
