import { http, HttpResponse } from 'msw'

const loginSuccessPayload = {
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

const profilePayload = {
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

export const authHandlers = [
  http.post('*/api/v1/auth/login', async ({ request }) => {
    const body = (await request.json()) as { email: string; password: string }

    if (!body.email || !body.password) {
      return HttpResponse.json(
        {
          success: false,
          code: 'ERR-CMN-003',
          message: '필수 입력값을 확인해 주세요.',
          timestamp: '2026-05-12T00:00:00',
        },
        { status: 400 },
      )
    }

    if (body.password === 'wrong-password') {
      return HttpResponse.json(
        {
          success: false,
          code: 'ERR-AUTH-001',
          message: '이메일 또는 비밀번호가 올바르지 않습니다.',
          timestamp: '2026-05-12T00:00:00',
        },
        { status: 401 },
      )
    }

    return HttpResponse.json(loginSuccessPayload)
  }),

  http.post('*/api/v1/auth/logout', () => new HttpResponse(null, { status: 204 })),

  http.post('*/api/v1/auth/refresh', async ({ request }) => {
    const body = (await request.json()) as { refreshToken?: string }

    if (!body.refreshToken) {
      return HttpResponse.json(
        {
          success: false,
          code: 'ERR-CMN-003',
          message: '필수 입력값을 확인해 주세요.',
          timestamp: '2026-05-12T00:00:00',
        },
        { status: 400 },
      )
    }

    return HttpResponse.json({
      success: true,
      data: {
        accessToken: 'refreshed-access-token',
        refreshToken: 'refreshed-refresh-token',
      },
    })
  }),

  http.get('*/api/v1/users/me', () => HttpResponse.json(profilePayload)),
]
