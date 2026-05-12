import { test, expect } from '@playwright/test'

const loginResponse = {
  success: true,
  data: {
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    user: {
      id: 1,
      email: 'user@example.com',
      name: '백광민',
      role: 'STUDENT',
      profileImageUrl: null,
    },
  },
}

const profileResponse = {
  success: true,
  data: {
    id: 1,
    email: 'user@example.com',
    name: '백광민',
    studentNo: '1545067',
    generation: 13,
    region: '서울',
    classNo: 5,
    phoneNumber: '010-1234-5678',
    emergencyPhoneNumber: null,
    zipCode: '06152',
    address: '서울 강남구 테헤란로 212',
    addressDetail: '멀티캠퍼스',
    role: 'STUDENT',
    status: 'ACTIVE',
    profileImageUrl: null,
    createdAt: '2026-05-11T09:00:00',
  },
}

test.beforeEach(async ({ page }) => {
  await page.route('**/api/v1/auth/login', async (route) => {
    const body = route.request().postDataJSON()

    if (body.password === 'wrong-password') {
      await route.fulfill({
        status: 401,
        contentType: 'application/json',
        body: JSON.stringify({
          success: false,
          code: 'ERR-AUTH-001',
          message: '이메일 또는 비밀번호가 올바르지 않습니다.',
          timestamp: '2026-05-12T00:00:00',
        }),
      })
      return
    }

    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(loginResponse),
    })
  })

  await page.route('**/api/v1/auth/logout', async (route) => {
    await route.fulfill({ status: 204 })
  })

  await page.route('**/api/v1/auth/refresh', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({
        success: true,
        data: {
          accessToken: 'refreshed-access-token',
          refreshToken: 'refreshed-refresh-token',
        },
      }),
    })
  })

  await page.route('**/api/v1/users/me', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(profileResponse),
    })
  })
})

test('로그인_성공_프로필_페이지_이동', async ({ page }) => {
  await page.goto('/login')

  await page.getByLabel('이메일').fill('user@example.com')
  await page.getByLabel('비밀번호').fill('P@ssw0rd!')
  await page.getByRole('button', { name: '로그인' }).click()

  await expect(page).toHaveURL(/\/profile$/)
  await expect(page.getByRole('heading', { name: '내 프로필', level: 2 })).toBeVisible()
  await expect(page.locator('.profile-card').getByText('백광민')).toBeVisible()
})

test('잘못된_비밀번호_오류_메시지_표시', async ({ page }) => {
  await page.goto('/login')

  await page.getByLabel('이메일').fill('user@example.com')
  await page.getByLabel('비밀번호').fill('wrong-password')
  await page.getByRole('button', { name: '로그인' }).click()

  await expect(page.getByText('이메일 또는 비밀번호가 올바르지 않습니다.')).toBeVisible()
  await expect(page).toHaveURL(/\/login$/)
})

test('로그아웃_로그인_페이지_리다이렉트', async ({ page }) => {
  await page.goto('/login')

  await page.getByLabel('이메일').fill('user@example.com')
  await page.getByLabel('비밀번호').fill('P@ssw0rd!')
  await page.getByRole('button', { name: '로그인' }).click()

  await page.getByRole('button', { name: '로그아웃' }).click()

  await expect(page).toHaveURL(/\/login$/)
  await expect(page.getByRole('heading', { name: 'SSAFY 학습 포털 로그인' })).toBeVisible()
})
