# FR-DASHBOARD API 명세

- **버전**: v1
- **기준 날짜**: 2026-05-12
- **기준 요구사항**: `docs/requirements/03_기능_요구사항.md` FR-DASHBOARD-* 항목
- **기준 경로 prefix**: `/api/v1`

> **설계 결정 — 대시보드 데이터 분리**: 홈 첫 진입에 필요한 최소 위젯은 `GET /dashboard`에서 한 번에 제공하고,
> 상세 조회와 이력 데이터는 별도 API로 분리한다. 초기 렌더링 지연을 줄이고, 탭별 페이징/재조회가 가능하도록 한다.

---

## 공통

### 요청 헤더

| 헤더 | 필수 여부 | 설명 |
|------|-----------|------|
| `Authorization: Bearer {token}` | 전체 엔드포인트 필수 | Access Token |

### 응답 공통 구조

```json
// 성공
{ "success": true, "data": { ... } }

// 오류
{ "success": false, "code": "ERR-CMN-003", "message": "...", "timestamp": "2026-05-12T09:00:00" }
```

### 공통 오류 응답

| HTTP | code | 조건 |
|------|------|------|
| 401 | ERR-CMN-004 | Authorization 헤더 없음 |
| 401 | ERR-AUTH-003 | 만료된 Access Token |
| 401 | ERR-AUTH-004 | 유효하지 않은 Access Token |

---

## GET /api/v1/dashboard

**요구사항**: FR-DASHBOARD-001
**인증**: 필요

### 요청

바디 없음.

### 응답 (200 OK)

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "name": "홍길동"
    },
    "summary": {
      "levelName": "Silver",
      "levelNo": 2,
      "scholarshipPoint": 1200,
      "totalExp": 540,
      "attendanceRate": 96.5,
      "completedLearningCount": 14,
      "incompleteTaskCount": 3
    },
    "monthlyAttendance": {
      "year": 2026,
      "month": 5,
      "educationDays": 20,
      "presentDays": 18,
      "lateDays": 1,
      "absentDays": 1
    }
  }
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| data.user.id | long | 사용자 ID |
| data.user.name | string | 사용자 이름 |
| data.summary.levelName | string? | 현재 레벨명 |
| data.summary.levelNo | int | 현재 레벨 번호 |
| data.summary.scholarshipPoint | int | 현재 장학 포인트 |
| data.summary.totalExp | int | 누적 경험치 |
| data.summary.attendanceRate | number? | 전체 출석률 (%) |
| data.summary.completedLearningCount | int | 완료한 학습 수 |
| data.summary.incompleteTaskCount | int | 미완료 Quest/평가/필수학습 수 |
| data.monthlyAttendance.year | int | 기준 연도 |
| data.monthlyAttendance.month | int | 기준 월 |
| data.monthlyAttendance.educationDays | int | 이번 달 교육일 수 |
| data.monthlyAttendance.presentDays | int | 이번 달 정상 출석 일수 |
| data.monthlyAttendance.lateDays | int | 이번 달 지각 일수 |
| data.monthlyAttendance.absentDays | int | 이번 달 결석 일수 |

### 오류 응답

| HTTP | code | 조건 |
|------|------|------|
| 404 | ERR-CMN-001 | user_stats 미존재 |

---

## GET /api/v1/users/me/stats

**요구사항**: FR-DASHBOARD-004
**인증**: 필요

### 요청

바디 없음.

### 응답 (200 OK)

```json
{
  "success": true,
  "data": {
    "levelName": "Silver",
    "levelNo": 2,
    "scholarshipPoint": 1200,
    "totalExp": 540,
    "attendanceRate": 96.5,
    "completedLearningCount": 14,
    "totalEarnedPoints": 1800,
    "totalUsedPoints": 600,
    "totalEarnedExp": 540,
    "updatedAt": "2026-05-12T08:30:00"
  }
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| levelName | string? | 현재 레벨명 |
| levelNo | int | 현재 레벨 번호 |
| scholarshipPoint | int | 현재 장학 포인트 |
| totalExp | int | 누적 경험치 |
| attendanceRate | number? | 전체 출석률 (%) |
| completedLearningCount | int | 완료한 학습 수 |
| totalEarnedPoints | int | 누적 적립 포인트 (`EARN`) |
| totalUsedPoints | int | 누적 차감 포인트 (`USE`, `EXPIRE`) |
| totalEarnedExp | int | 누적 적립 경험치 (`EARN`) |
| updatedAt | string | 통계 갱신 시각 (ISO 8601) |

### 오류 응답

| HTTP | code | 조건 |
|------|------|------|
| 404 | ERR-CMN-001 | user_stats 미존재 |

---

## GET /api/v1/users/me/attendance?year=&month=

**요구사항**: FR-DASHBOARD-002
**인증**: 필요

### 요청 파라미터

| 이름 | 타입 | 필수 | 설명 |
|------|------|------|------|
| year | int | Y | 조회 연도 |
| month | int | Y | 조회 월 (1-12) |

예시:
`GET /api/v1/users/me/attendance?year=2026&month=5`

### 응답 (200 OK)

```json
{
  "success": true,
  "data": {
    "year": 2026,
    "month": 5,
    "summary": {
      "educationDays": 20,
      "presentDays": 18,
      "lateDays": 1,
      "absentDays": 1,
      "earlyLeaveDays": 0,
      "outingDays": 0,
      "excusedDays": 0,
      "attendanceRate": 95.0
    },
    "days": [
      {
        "date": "2026-05-01",
        "isEducationDay": true,
        "title": "근로자의 날",
        "status": "EXCUSED",
        "reasonStatus": "APPROVED"
      }
    ]
  }
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| data.year | int | 기준 연도 |
| data.month | int | 기준 월 |
| data.summary.educationDays | int | 교육일 수 |
| data.summary.presentDays | int | 정상 출석 일수 |
| data.summary.lateDays | int | 지각 일수 |
| data.summary.absentDays | int | 결석 일수 |
| data.summary.earlyLeaveDays | int | 조퇴 일수 |
| data.summary.outingDays | int | 외출 일수 |
| data.summary.excusedDays | int | 공가/예외 인정 일수 |
| data.summary.attendanceRate | number | 월간 출석률 (%) |
| data.days[].date | string | 날짜 (ISO 8601) |
| data.days[].isEducationDay | boolean | 교육일 여부 |
| data.days[].title | string? | 교육일 표시명 또는 휴일명 |
| data.days[].status | string? | `NORMAL`, `LATE`, `ABSENT`, `EARLY_LEAVE`, `OUTING`, `EXCUSED`, `PENDING` |
| data.days[].reasonStatus | string? | `NONE`, `PENDING`, `APPROVED`, `REJECTED`, `UNEXCUSED` |

### 오류 응답

| HTTP | code | 조건 |
|------|------|------|
| 400 | ERR-CMN-003 | year 또는 month 누락 |
| 400 | ERR-CMN-003 | month 범위 오류 |

---

## GET /api/v1/users/me/points?page=&size=

**요구사항**: FR-DASHBOARD-003
**인증**: 필요

### 요청 파라미터

| 이름 | 타입 | 필수 | 설명 |
|------|------|------|------|
| page | int | N | 페이지 번호 (기본값 0) |
| size | int | N | 페이지 크기 (기본값 10, 최대 50) |

예시:
`GET /api/v1/users/me/points?page=0&size=10`

### 응답 (200 OK)

```json
{
  "success": true,
  "data": {
    "currentScholarshipPoint": 1200,
    "page": 0,
    "size": 10,
    "totalElements": 32,
    "totalPages": 4,
    "content": [
      {
        "id": 101,
        "transactionType": "EARN",
        "pointAmount": 100,
        "expAmount": 30,
        "reason": "Quest 완료",
        "targetType": "QUEST",
        "targetId": 12,
        "createdAt": "2026-05-11T09:30:00"
      }
    ]
  }
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| data.currentScholarshipPoint | int | 현재 장학 포인트 잔액 |
| data.page | int | 현재 페이지 |
| data.size | int | 페이지 크기 |
| data.totalElements | long | 전체 이력 수 |
| data.totalPages | int | 전체 페이지 수 |
| data.content[].id | long | 이력 ID |
| data.content[].transactionType | string | `EARN`, `USE`, `ADJUST`, `EXPIRE` |
| data.content[].pointAmount | int | 변동 포인트 |
| data.content[].expAmount | int | 변동 경험치 |
| data.content[].reason | string? | 변동 사유 |
| data.content[].targetType | string? | 연관 대상 타입 |
| data.content[].targetId | long? | 연관 대상 ID |
| data.content[].createdAt | string | 발생 시각 (ISO 8601) |

### 오류 응답

| HTTP | code | 조건 |
|------|------|------|
| 400 | ERR-CMN-003 | page가 0 미만 |
| 400 | ERR-CMN-003 | size가 1 미만 또는 50 초과 |
