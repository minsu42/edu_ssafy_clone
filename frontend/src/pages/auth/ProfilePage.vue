<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import type { UpdateProfilePayload } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const isEditMode = ref(false)
const isLoading = ref(false)
const successMessage = ref<string | null>(null)

const editForm = ref<UpdateProfilePayload>({
  name: '',
  phoneNumber: '',
  zipCode: '',
  address: '',
  addressDetail: '',
})

const pwForm = ref({
  currentPassword: '',
  newPassword: '',
  confirmPassword: '',
})
const pwError = ref<string | null>(null)
const pwSuccess = ref<string | null>(null)
const isChangingPw = ref(false)

onMounted(async () => {
  await authStore.fetchProfile()
  syncEditForm()
})

function syncEditForm() {
  const u = authStore.user
  if (!u) return
  editForm.value = {
    name: u.name ?? '',
    phoneNumber: u.phoneNumber ?? '',
    zipCode: u.zipCode ?? '',
    address: u.address ?? '',
    addressDetail: u.addressDetail ?? '',
  }
}

function startEdit() {
  syncEditForm()
  isEditMode.value = true
  successMessage.value = null
}

function cancelEdit() {
  isEditMode.value = false
}

async function saveProfile() {
  isLoading.value = true
  successMessage.value = null
  try {
    await authStore.updateProfile(editForm.value)
    isEditMode.value = false
    successMessage.value = '프로필이 수정되었습니다.'
  } catch (err) {
    const msg = authStore.errorMessage
    successMessage.value = msg ?? '저장에 실패했습니다. 다시 시도해 주세요.'
  } finally {
    isLoading.value = false
  }
}

async function changePassword() {
  pwError.value = null
  pwSuccess.value = null
  if (pwForm.value.newPassword !== pwForm.value.confirmPassword) {
    pwError.value = '새 비밀번호가 일치하지 않습니다.'
    return
  }
  isChangingPw.value = true
  try {
    await authStore.changePassword(pwForm.value.currentPassword, pwForm.value.newPassword)
    pwSuccess.value = '비밀번호가 변경되었습니다.'
    pwForm.value = { currentPassword: '', newPassword: '', confirmPassword: '' }
  } catch {
    pwError.value = authStore.errorMessage ?? '비밀번호 변경에 실패했습니다.'
  } finally {
    isChangingPw.value = false
  }
}

async function handleWithdraw() {
  if (!confirm('정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) return
  await authStore.withdraw()
  router.push('/login')
}
</script>

<template>
  <div class="profile-page">
    <div class="page-hero">
      <div class="page-hero-inner">
        <h1 class="page-title">마이프로필</h1>
      </div>
    </div>

    <div class="profile-content">
      <!-- 기본 정보 -->
      <section class="card">
        <div class="card-header">
          <h2 class="card-title">기본 정보</h2>
          <div class="card-actions">
            <button v-if="!isEditMode" class="btn btn-secondary" @click="startEdit">수정</button>
            <template v-else>
              <button class="btn btn-primary" :disabled="isLoading" @click="saveProfile">
                {{ isLoading ? '저장 중...' : '저장' }}
              </button>
              <button class="btn btn-ghost" @click="cancelEdit">취소</button>
            </template>
          </div>
        </div>

        <p v-if="successMessage" class="success-message">{{ successMessage }}</p>

        <div class="info-grid">
          <div class="info-row">
            <span class="info-label">이름</span>
            <span v-if="!isEditMode" class="info-value">{{ authStore.user?.name }}</span>
            <input v-else v-model="editForm.name" class="form-input" type="text" />
          </div>
          <div class="info-row">
            <span class="info-label">이메일</span>
            <span class="info-value">{{ authStore.user?.email }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">역할</span>
            <span class="info-value">{{ authStore.user?.role }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">기수</span>
            <span class="info-value">{{ authStore.user?.generation ?? '-' }}기</span>
          </div>
          <div class="info-row">
            <span class="info-label">지역</span>
            <span class="info-value">{{ authStore.user?.region ?? '-' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">반</span>
            <span class="info-value">{{ authStore.user?.classNo ? authStore.user.classNo + '반' : '-' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">학번</span>
            <span class="info-value">{{ authStore.user?.studentNo ?? '-' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">연락처</span>
            <span v-if="!isEditMode" class="info-value">{{ authStore.user?.phoneNumber ?? '-' }}</span>
            <input v-else v-model="editForm.phoneNumber" class="form-input" type="tel" placeholder="010-0000-0000" />
          </div>
          <div class="info-row">
            <span class="info-label">우편번호</span>
            <span v-if="!isEditMode" class="info-value">{{ authStore.user?.zipCode ?? '-' }}</span>
            <input v-else v-model="editForm.zipCode" class="form-input" type="text" />
          </div>
          <div class="info-row">
            <span class="info-label">주소</span>
            <span v-if="!isEditMode" class="info-value">{{ authStore.user?.address ?? '-' }}</span>
            <input v-else v-model="editForm.address" class="form-input" type="text" />
          </div>
          <div class="info-row">
            <span class="info-label">상세주소</span>
            <span v-if="!isEditMode" class="info-value">{{ authStore.user?.addressDetail ?? '-' }}</span>
            <input v-else v-model="editForm.addressDetail" class="form-input" type="text" />
          </div>
        </div>
      </section>

      <!-- 비밀번호 변경 -->
      <section class="card">
        <div class="card-header">
          <h2 class="card-title">비밀번호 변경</h2>
        </div>

        <p v-if="pwSuccess" class="success-message">{{ pwSuccess }}</p>
        <p v-if="pwError" class="error-message">{{ pwError }}</p>

        <div class="pw-form">
          <div class="form-group">
            <label class="form-label">현재 비밀번호</label>
            <input v-model="pwForm.currentPassword" type="password" class="form-input" />
          </div>
          <div class="form-group">
            <label class="form-label">새 비밀번호</label>
            <input v-model="pwForm.newPassword" type="password" class="form-input" />
            <span class="form-hint">8자 이상, 영문 + 숫자 + 특수문자(!@#$%^&amp;*) 포함</span>
          </div>
          <div class="form-group">
            <label class="form-label">새 비밀번호 확인</label>
            <input v-model="pwForm.confirmPassword" type="password" class="form-input" />
          </div>
          <button
            class="btn btn-primary"
            :disabled="isChangingPw || !pwForm.currentPassword || !pwForm.newPassword || !pwForm.confirmPassword"
            @click="changePassword"
          >
            {{ isChangingPw ? '변경 중...' : '비밀번호 변경' }}
          </button>
        </div>
      </section>

      <!-- 회원 탈퇴 -->
      <section class="card card--danger">
        <div class="card-header">
          <h2 class="card-title card-title--danger">회원 탈퇴</h2>
        </div>
        <p class="danger-desc">탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.</p>
        <button class="btn btn-danger" @click="handleWithdraw">회원 탈퇴</button>
      </section>
    </div>
  </div>
</template>

<style scoped>
.profile-page {
  min-height: calc(100vh - 56px - 120px);
}

.page-hero {
  background: #1a2332;
  color: #fff;
  padding: 40px 16px;
}

.page-hero-inner {
  max-width: 1280px;
  margin: 0 auto;
}

.page-title {
  font-size: 24px;
  font-weight: 700;
  margin: 0;
}

.profile-content {
  max-width: 800px;
  margin: 32px auto;
  padding: 0 16px;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.card {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
  padding: 24px;
}

.card--danger {
  border: 1px solid #fecaca;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}

.card-title {
  font-size: 16px;
  font-weight: 700;
  color: #1a2332;
  margin: 0;
}

.card-title--danger {
  color: #dc2626;
}

.card-actions {
  display: flex;
  gap: 8px;
}

.info-grid {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.info-row {
  display: grid;
  grid-template-columns: 120px 1fr;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #f3f4f6;
}

.info-row:last-child {
  border-bottom: none;
}

.info-label {
  font-size: 13px;
  font-weight: 600;
  color: #6b7280;
}

.info-value {
  font-size: 14px;
  color: #111827;
}

.form-input {
  padding: 8px 12px;
  border: 1.5px solid #d1d5db;
  border-radius: 6px;
  font-size: 14px;
  outline: none;
  transition: border-color 0.15s;
  width: 100%;
  box-sizing: border-box;
}

.form-input:focus {
  border-color: #3a7bd5;
}

.pw-form {
  display: flex;
  flex-direction: column;
  gap: 14px;
  max-width: 400px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.form-label {
  font-size: 13px;
  font-weight: 600;
  color: #374151;
}

.form-hint {
  font-size: 12px;
  color: #9ca3af;
}

.success-message {
  font-size: 13px;
  color: #059669;
  background: #f0fdf4;
  border: 1px solid #bbf7d0;
  border-radius: 6px;
  padding: 8px 12px;
  margin: 0 0 16px;
}

.error-message {
  font-size: 13px;
  color: #dc2626;
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 6px;
  padding: 8px 12px;
  margin: 0 0 16px;
}

.danger-desc {
  font-size: 14px;
  color: #6b7280;
  margin: 0 0 16px;
}

.btn {
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  border: none;
  transition: opacity 0.15s, background 0.15s;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-primary {
  background: #3a7bd5;
  color: #fff;
}

.btn-primary:hover:not(:disabled) {
  background: #2d6abc;
}

.btn-secondary {
  background: #f3f4f6;
  color: #374151;
}

.btn-secondary:hover {
  background: #e5e7eb;
}

.btn-ghost {
  background: transparent;
  color: #6b7280;
}

.btn-ghost:hover {
  background: #f3f4f6;
}

.btn-danger {
  background: #dc2626;
  color: #fff;
}

.btn-danger:hover {
  background: #b91c1c;
}
</style>
