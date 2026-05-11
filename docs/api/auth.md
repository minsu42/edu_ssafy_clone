# FR-AUTH API 명세

- **버전**: v1
- **기준 날짜**: 2026-05-11
- **기준 요구사항**: `docs/requirements/03_기능_요구사항.md` FR-AUTH-* 항목
- **기준 경로 prefix**: `/api/v1`

> **설계 결정 — Refresh Token 저장**: schema.sql에 refresh_tokens 테이블 없음.
> P1 구현 시 `refresh_tokens` 테이블을 schema.sql에 추가하고 사용자 승인 후 적용한다.
> 추상화 인터페이스(`RefreshTokenRepository`)로 구현하여 추후 Redis 전환 가능하도록 한다.

---

## 공통

### 요청 헤더

| 헤더 | 필수 여부 | 설명 |
|------|-----------|------|
| `Authorization: Bearer {token}` | 인증 필요 엔드포인트 | Access Token |
| `Content-Type: application/json` | 요청 바디 있는 경우 | - |

### 응답 공통 구조

```json
// 성공 (바디 있음)
{ "success": true, "data": { ... } }

// 성공 (바디 없음)
HTTP 204 No Content

// 오류
{ "success": false, "code": "ERR-AUTH-001", "message": "...", "timestamp": "2026-05-11T09:00:00" }
```

---

## POST /api/v1/auth/login

**요구사항**: FR-AUTH-LOGIN-001
**인증**: 불필요 (공개 엔드포인트)

### 요청

```json
{
  "email": "user@example.com",
  "password": "P@ssw0rd!"
}
```

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| email | string | Y | 로그인 이메일 |
| password | string | Y | 비밀번호 (평문) |

### 응답 (200 OK)

```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiJ9...",
    "user": {
      "id": 1,
      "email": "user@example.com",
      "name": "홍길동",
      "role": "STUDENT",
      "profileImageUrl": "https://cdn.example.com/profiles/1.jpg"
    }
  }
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| data.accessToken | string | JWT Access Token (유효 15분) |
| data.refreshToken | string | JWT Refresh Token (유효 7일) |
| data.user.id | long | 사용자 ID |
| data.user.email | string | 이메일 |
| data.user.name | string | 이름 |
| data.user.role | string | `STUDENT` / `ADMIN` / `OPERATOR` / `MENTOR` |
| data.user.profileImageUrl | string? | 프로필 이미지 URL (없으면 null) |

### 오류 응답

| HTTP | code | 조건 |
|------|------|------|
| 400 | ERR-CMN-003 | email 또는 password 필드 누락 |
| 401 | ERR-AUTH-001 | 이메일 없음 또는 비밀번호 불일치 |
| 403 | ERR-AUTH-002 | status = `INACTIVE` 또는 `WITHDRAWN` |

---

## POST /api/v1/auth/logout

**요구사항**: FR-AUTH-LOGOUT-001
**인증**: 필요

### 요청

바디 없음. `Authorization: Bearer {accessToken}` 헤더 필수.

### 응답

`HTTP 204 No Content`

### 오류 응답

| HTTP | code | 조건 |
|------|------|------|
| 401 | ERR-CMN-002 | Authorization 헤더 없음 |
| 401 | ERR-AUTH-003 | 만료된 Access Token |
| 401 | ERR-AUTH-004 | 유효하지 않은 Access Token |

---

## POST /api/v1/auth/refresh

**요구사항**: FR-AUTH-SESSION-001
**인증**: 불필요 (Refresh Token으로 인증)

### 요청

```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiJ9..."
}
```

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| refreshToken | string | Y | 로그인/갱신 시 발급된 Refresh Token |

### 응답 (200 OK)

```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| data.accessToken | string | 새 Access Token (유효 15분) |
| data.refreshToken | string | 새 Refresh Token (유효 7일, Rotation으로 교체 발급) |

### 오류 응답

| HTTP | code | 조건 |
|------|------|------|
| 400 | ERR-CMN-003 | refreshToken 필드 누락 |
| 401 | ERR-AUTH-003 | 만료된 Refresh Token |
| 401 | ERR-AUTH-004 | 서명 검증 실패 또는 DB에 없는 토큰 |

---

## GET /api/v1/users/me

**요구사항**: FR-AUTH-PROFILE-001
**인증**: 필요

### 요청

바디 없음.

### 응답 (200 OK)

```json
{
  "success": true,
  "data": {
    "id": 1,
    "email": "user@example.com",
    "name": "홍길동",
    "studentNo": "0900001",
    "generation": 13,
    "region": "서울",
    "classNo": 5,
    "phoneNumber": "010-1234-5678",
    "emergencyPhoneNumber": null,
    "zipCode": "12345",
    "address": "서울시 강남구 테헤란로 212",
    "addressDetail": "101호",
    "role": "STUDENT",
    "status": "ACTIVE",
    "profileImageUrl": "https://cdn.example.com/profiles/1.jpg",
    "createdAt": "2026-01-01T09:00:00"
  }
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| id | long | 사용자 ID |
| email | string | 이메일 |
| name | string | 이름 |
| studentNo | string? | 학번 |
| generation | int? | SSAFY 기수 |
| region | string? | 소속 지역 |
| classNo | int? | 소속 반 번호 |
| phoneNumber | string? | 휴대폰 번호 |
| emergencyPhoneNumber | string? | 긴급연락처 |
| zipCode | string? | 우편번호 |
| address | string? | 기본 주소 |
| addressDetail | string? | 상세 주소 |
| role | string | `STUDENT` / `ADMIN` / `OPERATOR` / `MENTOR` |
| status | string | `ACTIVE` / `INACTIVE` / `WITHDRAWN` |
| profileImageUrl | string? | 프로필 이미지 URL (없으면 null) |
| createdAt | string | 계정 생성일 (ISO 8601) |

> `password` 필드는 응답에 포함하지 않는다.

### 오류 응답

| HTTP | code | 조건 |
|------|------|------|
| 401 | ERR-CMN-002 | Authorization 헤더 없음 |
| 401 | ERR-AUTH-003 | 만료된 Access Token |
| 401 | ERR-AUTH-004 | 유효하지 않은 Access Token |

---

## PATCH /api/v1/users/me

**요구사항**: FR-AUTH-PROFILE-002
**인증**: 필요

### 요청

```json
{
  "name": "홍길동",
  "phoneNumber": "010-9876-5432",
  "zipCode": "54321",
  "address": "서울시 마포구 월드컵북로 396",
  "addressDetail": "202호",
  "profileFileId": 5
}
```

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| name | string | N | 변경할 이름 |
| phoneNumber | string | N | 변경할 휴대폰 번호 |
| zipCode | string | N | 변경할 우편번호 |
| address | string | N | 변경할 기본 주소 |
| addressDetail | string | N | 변경할 상세 주소 |
| profileFileId | long | N | 변경할 프로필 이미지 파일 ID (files.id) |

> 제공된 필드만 업데이트. null 전송 시 무시.
> 수정 불가 필드: email, role, status, studentNo, generation, region, classNo.

### 응답 (200 OK)

`GET /api/v1/users/me` 응답 구조와 동일.

### 오류 응답

| HTTP | code | 조건 |
|------|------|------|
| 401 | ERR-CMN-002 | Authorization 헤더 없음 |
| 401 | ERR-AUTH-003 | 만료된 Access Token |
| 404 | ERR-CMN-001 | profileFileId에 해당하는 파일 없음 |

---

## PUT /api/v1/users/me/password

**요구사항**: FR-AUTH-CREDENTIAL-001
**인증**: 필요

### 요청

```json
{
  "currentPassword": "OldP@ss1!",
  "newPassword": "NewP@ss2@"
}
```

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| currentPassword | string | Y | 현재 비밀번호 |
| newPassword | string | Y | 새 비밀번호 |

> 새 비밀번호 규칙: 8자 이상, 영문 + 숫자 + 특수문자(`!@#$%^&*`) 각 1자 이상 포함.

### 응답

`HTTP 204 No Content`

### 오류 응답

| HTTP | code | 조건 |
|------|------|------|
| 400 | ERR-CMN-003 | 필드 누락 또는 새 비밀번호 유효성 실패 |
| 400 | ERR-AUTH-005 | 현재 비밀번호 불일치 |
| 401 | ERR-CMN-002 | Authorization 헤더 없음 |
| 401 | ERR-AUTH-003 | 만료된 Access Token |

---

## DELETE /api/v1/users/me

**요구사항**: FR-AUTH-WITHDRAW-001
**인증**: 필요

### 요청

바디 없음.

### 응답

`HTTP 204 No Content`

### 오류 응답

| HTTP | code | 조건 |
|------|------|------|
| 401 | ERR-CMN-002 | Authorization 헤더 없음 |
| 401 | ERR-AUTH-003 | 만료된 Access Token |

---

## (내부) 계정 상태 검증

**요구사항**: FR-AUTH-STATUS-001
**처리**: `JwtAuthFilter` 내부 — 별도 API 없음

모든 인증 필요 엔드포인트에서 JWT 파싱 후 users.status를 확인한다.

| status | 처리 |
|--------|------|
| `ACTIVE` | 정상 통과 |
| `INACTIVE` | ERR-AUTH-002 (HTTP 403) |
| `WITHDRAWN` | ERR-AUTH-002 (HTTP 403) |
