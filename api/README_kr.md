# fGoogleSheet REST API 문서

## 개요

fGoogleSheet은 Google Sheets에 Key/Value 데이터를 업로드하고 관리하는 REST API를 제공합니다.

| 서버 구현 | 기술 스택 | 기본 포트 |
|-----------|-----------|-----------|
| macOS 네이티브 앱 | Swift / Network.framework (NWListener) | 3013 |

**보안 정책**: API 서버는 기본적으로 비활성화되어 있습니다. 활성화 시 localhost(127.0.0.1)에만 바인딩됩니다. 설정 UI의 체크박스를 통해 외부 접속을 허용할 수 있으며, CIDR 범위(예: `192.168.0.0/24`)로 IP 필터링을 제어합니다.

> OpenAPI 3.0 스펙: [openapi.yaml](./openapi.yaml) | [openapi_kr.yaml](./openapi_kr.yaml)

---

## 엔드포인트

### 1. 서버 상태 확인 (Health Check)

```
GET /
```

**응답**:
```json
{
  "status": "ok",
  "app": "fGoogleSheet",
  "port": 3013,
  "accessMode": "API"
}
```

---

### 2. Google Sheets에 데이터 추가

```
POST /api/add-line
Content-Type: application/json
```

#### 요청 파라미터

| 필드 | 타입 | 필수 | 기본값 | 설명 |
|------|------|------|--------|------|
| `key` | string | 예 | - | A열에 입력할 텍스트 (질문/키) |
| `value` | string | 아니오 | `""` | B열에 입력할 텍스트 (답변/값) |

#### 요청 예시

```json
{
  "key": "Swift란 무엇인가?",
  "value": "Apple의 프로그래밍 언어입니다."
}
```

#### 응답

**성공 (200)**:
```json
{
  "success": true,
  "targetRow": 5,
  "nextRow": 6,
  "newQuestionCnt": 2,
  "hasNewQuestions": true
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| `success` | boolean | 업로드 성공 여부 |
| `targetRow` | integer | 데이터가 입력된 행 번호 |
| `nextRow` | integer | 다음 빈 행 번호 |
| `newQuestionCnt` | integer | 미답변 질문 수 |
| `hasNewQuestions` | boolean | 미답변 질문 존재 여부 |

**에러**:

| 상태 코드 | 원인 | 응답 예시 |
|-----------|------|-----------|
| 400 | key 누락 또는 JSON 파싱 실패 | `{"error": "key 필드는 필수입니다"}` |
| 401 | OAuth 토큰 만료 또는 미설정 | `{"error": "인증이 필요합니다"}` |
| 500 | Google Sheets API 실패 | `{"error": "Google Sheets API 호출 실패"}` |
| 503 | 앱 미초기화 | `{"error": "DataManager가 초기화되지 않았습니다"}` |

---

### 3. 미답변 질문 조회

```
GET /api/unanswered?startRow=2
```

#### 요청 파라미터

| 파라미터 | 위치 | 필수 | 기본값 | 설명 |
|----------|------|------|--------|------|
| `startRow` | query | 아니오 | 2 | 스캔 시작 행 번호 |

#### 응답

**성공 (200)**:
```json
{
  "count": 2,
  "questions": [
    {
      "row": 5,
      "question": "Swift에서 async/await란?",
      "cellA": "A5",
      "cellB": "B5"
    },
    {
      "row": 8,
      "question": "SwiftUI의 @State란?",
      "cellA": "A8",
      "cellB": "B8"
    }
  ]
}
```

A열에 내용이 있지만 B열이 비어있는 행을 찾습니다. 연속 10개 빈 행이 발견되면 스캔을 종료합니다.

---

### 4. 앱 상태 조회

```
GET /api/status
```

**응답 (200)**:
```json
{
  "executionState": "idle",
  "accessMode": "API",
  "currentRow": 5,
  "sheetName": "Sheet1",
  "hasUnansweredQuestions": true,
  "unansweredQuestionsCount": 2,
  "isAuthenticated": true,
  "restServerPort": 3013
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| `executionState` | string | 현재 실행 상태 (`idle`, `saving`, `executing`, `completed`, `failed`, `loadingConfig`, `needsRestart`) |
| `accessMode` | string | Google Sheets 접근 방식 (`API`, `AppsScript`, `Playwright`) |
| `currentRow` | integer | 현재 데이터 입력 행 번호 |
| `sheetName` | string | 현재 시트 탭 이름 |
| `isAuthenticated` | boolean | OAuth 인증 유효 여부 |
| `restServerPort` | integer | REST 서버 포트 번호 |

---

### 5. 다음 빈 행 조회

```
GET /api/next-row?startRow=2
```

#### 요청 파라미터

| 파라미터 | 위치 | 필수 | 기본값 | 설명 |
|----------|------|------|--------|------|
| `startRow` | query | 아니오 | 2 | 스캔 시작 행 번호 |

#### 응답

**성공 (200)**:
```json
{
  "nextRow": 15,
  "newQuestionCnt": 3
}
```

---

## 사용 예시

### cURL

```bash
# 데이터 추가
curl -X POST http://localhost:3013/api/add-line \
  -H "Content-Type: application/json" \
  -d '{"key": "Swift란 무엇인가?", "value": "Apple의 프로그래밍 언어입니다."}'

# Key만 추가 (답변 없음)
curl -X POST http://localhost:3013/api/add-line \
  -H "Content-Type: application/json" \
  -d '{"key": "SwiftUI란 무엇인가?"}'

# 미답변 질문 조회
curl http://localhost:3013/api/unanswered

# 앱 상태 확인
curl http://localhost:3013/api/status

# 다음 빈 행 조회
curl http://localhost:3013/api/next-row

# 헬스 체크
curl http://localhost:3013/
```

### Python

```python
import requests

BASE_URL = 'http://localhost:3013'

# 데이터 추가
response = requests.post(
    f'{BASE_URL}/api/add-line',
    json={'key': 'Swift란 무엇인가?', 'value': 'Apple의 프로그래밍 언어입니다.'}
)
print(response.json())

# 미답변 질문 조회
response = requests.get(f'{BASE_URL}/api/unanswered')
print(response.json())

# 앱 상태 확인
response = requests.get(f'{BASE_URL}/api/status')
print(response.json())
```

---

## 보안

| 항목 | 설명 |
|------|------|
| 기본 상태 | API 서버 **비활성화** |
| 바인딩 | localhost (127.0.0.1) 전용 |
| 외부 접속 | 설정 UI 체크박스로 허용 가능 |
| IP 필터링 | CIDR 범위 설정 (예: `192.168.0.0/24`) |
| CORS | `Access-Control-Allow-Origin: *` |
| 거부 응답 | 403 Forbidden (`{"error": "접근 거부: IP가 허용된 CIDR 범위에 포함되지 않습니다"}`) |

---

## 앱 UI 연동

REST API 요청 시 앱 UI와 자동으로 연동됩니다:

- `POST /api/add-line` 호출 시 앱 UI 입력란에 데이터가 자동 반영
- 업로드 완료 후 현재 행 번호 자동 증가
- 설정 변경은 보안상 REST API에서 **제외** (앱 UI에서만 가능)

---

## 테스트

```bash
# 자동화 테스트 (9개 항목)
bash api/test-api.sh

# 원격 서버 테스트
bash api/test-api.sh --server=http://192.168.0.10:3013
```

테스트 항목:
1. Health Check - 상태 코드 200 및 `status` 필드 확인
2. Health Check - `app` 필드가 `fGoogleSheet`인지 확인
3. 앱 상태 - 상태 코드 200 및 `executionState` 필드 확인
4. 앱 상태 - `accessMode` 필드 존재 확인
5. 데이터 추가 - key+value 업로드 (200)
6. 데이터 추가 - key 누락 시 400 반환
7. 미답변 질문 - `count` 필드 포함 응답 확인
8. 다음 빈 행 - `nextRow` 필드 포함 응답 확인
9. 404 처리 - 잘못된 경로 시 404 반환
