import { ApiError, type ApiErrorPayload } from './auth'

const API_PREFIX = '/api/v1'

interface RequestOptions extends RequestInit {
  body?: BodyInit | object | null
}

interface ApiSuccess<T> {
  success: true
  data: T
}

function createHeaders(init?: HeadersInit) {
  return new Headers(init)
}

async function parseError(response: Response): Promise<never> {
  let payload: ApiErrorPayload | null = null

  try {
    const text = await response.text()
    payload = text ? (JSON.parse(text) as ApiErrorPayload) : null
  } catch {
    // no-op
  }

  throw new ApiError(
    payload?.message ?? `요청 실패 (${response.status})`,
    payload?.code,
  )
}

export async function apiRequest<T>(path: string, options: RequestOptions = {}) {
  const baseUrl =
    typeof window === 'undefined' ? 'http://localhost' : window.location.origin
  const headers = createHeaders(options.headers)

  if (!headers.has('Content-Type') && options.body && !(options.body instanceof FormData)) {
    headers.set('Content-Type', 'application/json')
  }

  const body =
    options.body && !(options.body instanceof FormData) && typeof options.body !== 'string'
      ? JSON.stringify(options.body)
      : options.body

  const response = await fetch(new URL(`${API_PREFIX}${path}`, baseUrl).toString(), {
    ...options,
    headers,
    body,
  })

  if (!response.ok) {
    return parseError(response)
  }

  if (response.status === 204) {
    return undefined as T
  }

  const text = await response.text()
  const payload = (text ? JSON.parse(text) : null) as ApiSuccess<T> | null

  if (!payload) {
    throw new ApiError('응답 본문이 비어 있습니다.')
  }

  return payload.data
}
