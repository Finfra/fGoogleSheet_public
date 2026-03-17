# fGoogleSheet 설정 가이드

## 1. 사전 요구사항

### 1.1 Node.js 설치
앱은 Google Sheets 연동을 위해 Node.js (v18 이상)가 필요합니다.

```bash
# Homebrew로 설치
brew install node

# 버전 확인
node --version   # v18 이상 필요
npm --version
```

### 1.2 npm 패키지 설치
프로젝트의 `extModule` 디렉토리에서 필요한 패키지를 설치합니다.

```bash
cd fGoogleSheet/extModule
npm install
```

설치되는 패키지:
- `express` - REST API 서버
- `body-parser` - 요청 본문 파싱
- `playwright` - 브라우저 자동화 (Google Sheets 조작)

### 1.3 Playwright Chromium 브라우저 설치
Playwright가 사용할 Chromium 브라우저를 별도로 설치해야 합니다.

```bash
cd fGoogleSheet/extModule
npx playwright install chromium
```

> 앱 시작 시 위 환경이 준비되지 않으면 자동으로 점검 결과와 해결 명령어가 표시됩니다.

---

## 2. 앱 설정 (cmd+,)

앱 내 설정 편집 화면에서 다음 항목을 설정합니다.

### 2.1 Short URL (화면 표시용)
- 메인 화면 상단에 표시되는 간단한 이름
- 예: `강의 노트`, `Q&A 시트`

### 2.2 Google Sheets URL
- Google Sheets의 전체 URL
- 형식: `https://docs.google.com/spreadsheets/d/{SPREADSHEET_ID}/edit#gid=0`
- Google Sheets에서 브라우저 주소창의 URL을 그대로 복사하여 붙여넣기

### 2.3 현재 행 번호
- 다음에 데이터를 입력할 행 번호 (1~1000)
- 실행할 때마다 자동으로 증가

### 2.4 입력창 폰트 크기
- Key/Value 입력창의 폰트 크기 (12~128pt)
- 기본값: 64pt

### 2.5 Apps Script Web App URL (선택)
- OAuth 없이 읽기/쓰기가 가능한 방식
- 설정 시 이 방식이 우선 사용됨
- 형식: `https://script.google.com/macros/s/.../exec`

### 2.6 Google Sheets API Key (선택)
- Google Cloud Console에서 발급받은 API Key
- 읽기 전용 작업에 사용

### 2.7 시트 탭 이름
- 데이터를 입력할 시트 탭 이름
- 기본값: `Sheet1`

### 2.8 OAuth 2.0 인증 (선택, 쓰기용)
- Google Cloud Console → 사용자 인증 정보 → OAuth 2.0 Client ID (Desktop 유형)
- Client ID와 Client Secret을 입력 후 "Google 로그인" 버튼으로 인증

### 2.9 실행 후 앱 숨기기
- 실행 완료 후 자동으로 앱을 숨기는 옵션
- 답변이 없는 질문이 발견되면 숨기지 않음

---

## 3. 설정 파일 위치

모든 설정은 `fGoogleSheet/extModule/` 디렉토리에 텍스트 파일로 저장됩니다.

| 파일명 | 용도 |
|--------|------|
| `config_address.txt` | Google Sheets URL |
| `config_short_url.txt` | 화면 표시용 Short URL |
| `config_cell_key.txt` | 현재 Key 데이터 |
| `config_cell_val.txt` | 현재 Value 데이터 |
| `config_currentRow.txt` | 현재 행 번호 |
| `config_font_size.txt` | 입력창 폰트 크기 |
| `config_hide_after_execution.txt` | 실행 후 숨기기 설정 |
| `config_api_key.txt` | Google Sheets API Key |
| `config_sheet_tab.txt` | 시트 탭 이름 |
| `config_oauth_client_id.txt` | OAuth Client ID |
| `config_oauth_client_secret.txt` | OAuth Client Secret |
| `config_refresh_token.txt` | OAuth Refresh Token |
| `config_webapp_url.txt` | Apps Script Web App URL |

---

## 4. 단축키

| 단축키 | 기능 |
|--------|------|
| `cmd+r` | 저장 및 실행 (Google Sheets에 입력) |
| `cmd+k` | 입력 필드 클리어 |
| `cmd+f` | 답변 없는 질문 확인 |
| `cmd+enter` | 저장 및 실행 (숨김) |
| `Tab` | 포커스 이동 (Key ↔ Value) |
| `cmd+,` | 설정 편집 |

---

## 5. 문제 해결

### Node.js 관련
| 문제 | 해결 명령어 |
|------|------------|
| Node.js 미설치 | `brew install node` |
| Node.js 버전 낮음 (v18 미만) | `brew upgrade node` |
| npm 패키지 미설치 | `cd fGoogleSheet/extModule && npm install` |
| Playwright Chromium 미설치 | `cd fGoogleSheet/extModule && npx playwright install chromium` |

### 앱 실행 관련
| 문제 | 해결 방법 |
|------|----------|
| Playwright 서버 시작 오류 | 기존 프로세스 종료: `pkill -f "node.*fLecNoteManager"` |
| 브라우저 연결 끊김 | 앱에서 자동 재연결 시도, 또는 앱 재시작 |
| Google 로그인 필요 | 브라우저 창에서 Google 계정 로그인 후 진행 |
