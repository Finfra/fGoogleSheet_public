---
title: fGoogleSheet 사용자 매뉴얼 및 기능 명세서 (User Manual & Functional Specification)
description: 본 문서는 fGoogleSheet의 핵심 가치 창출 도구인 **Key/Value 기반 데이터 입력**과 **Google Sheets API v4 직접 연동** 시스템에 대한 총체적이고 상세한 가이드를 제공합니다.
date: 2026.03.14
tags: [매뉴얼, 사용자 가이드, 기능 명세]
---

# fGoogleSheet이란? (Overview)

fGoogleSheet는 반복적인 데이터 기록 작업을 빠르게 처리하기 위해 데스크탑 환경에서 **Google Sheets**로 즉각적인 접근을 지원하는 macOS 전용 생산성 극대화 도구입니다. 복잡한 외부 의존성 없이 Google Sheets API v4와 직접 통신하며, 직관적인 UI를 제공합니다.

---

# 1. 데이터 입력 기능 (Data Input & Upload)

## 1.1. Key/Value 듀얼 레이아웃 구조
화면은 1:3 비율의 Key(질문)와 Value(답변) 입력창으로 나뉘어 있습니다. 
사용자는 긴 질문이나 텍스트를 파악하고, 이에 대응하는 답변을 신속하게 입력할 수 있습니다.
- 멀티라인 TextEditor를 지원하여 긴 글도 손쉽게 작성 가능합니다.
- `Tab` 키를 통해 Key ↔ Value 창 사이를 자연스럽게 이동합니다.

## 1.2. 한글 지원 및 에러 처리
입력한 모든 텍스트는 UTF-8 포맷으로 안전하게 처리되며, 한글 입력 시에도 깨짐 현상 없이 Google Sheets에 반영될 수 있도록 설계되었습니다.

---

# 2. Google Sheets API 연동 시스템

## 2.1. 외부 의존성 없는 직접(Direct) 통신
fGoogleSheet는 앱 내부에 포함된 `GoogleSheetsService` 인프라를 통해 Google REST API v4 규격과 직접 통신합니다. 외부 SDK(Firebase 등)를 거치지 않아 가볍고 신속하며 커스텀 처리가 용이합니다.

## 2.2. 빈 행 자동 탐색 및 이어쓰기
데이터 업로드 시, 앱은 시트의 데이터를 읽어 마지막으로 데이터가 입력된 위치(빈 행)를 자동으로 파악하고, 그 다음 행부터 데이터를 안전하게 덧붙여(Append) 기록합니다. 기존 데이터의 손실이 발생하지 않도록 보호합니다.

---

# 3. 미답변 데이터 추적 및 관리

## 3.1. 답변 없는 질문 확인 기능 (`cmd+f`)
수많은 Key 값만 입력되어 있고 Value가 비어 있는 경우, 스프레드시트 상태를 자동 검사하여 답변이 필요한 Key 항목들을 즉시 불러옵니다. 기록 누락을 막기 위한 필수적인 트래킹 시스템입니다.

---

# 4. 앱 구동 시스템 및 설정 환경

## 4.1. 유연한 환경 설정 (ConfigManager)
새로운 문서(Target Document ID)에 접근하거나, 대상 시트 탭 이름이 변경되었을 때 소스 코드를 재수정할 필요가 없습니다. 앱 내의 설정창에서 값을 수정하기만 하면 파일 시스템에 즉각 영구 보관되며 API 통신에 실시간으로 반영됩니다.

## 4.2. 단축키 글로벌 커맨드
데이터 입력 및 관리의 효율성을 위해 마우스 클릭보다는 키보드 커맨드를 지향합니다.
- `cmd+k`: 입력 폼 데이터 클리어
- `cmd+r`: 데이터 저장 및 API 전송
- `cmd+f`: 답변 없는 질문(빈 Value 영역) 확인
- `cmd+enter`: 데이터 저장 및 API 전송 후 앱 숨기기

---

# 5. REST API 서버 (외부 연동)

## 5.1. 내장 HTTP 서버
fGoogleSheet는 NWListener 기반 내장 REST API 서버를 제공합니다. 외부 클라이언트(curl, 스크립트, 자동화 도구)에서 HTTP 요청으로 앱의 핵심 기능을 제어할 수 있습니다.

## 5.2. 제공 엔드포인트

| 메서드 | 경로 | 기능 |
|--------|------|------|
| `GET` | `/` | 헬스 체크 (서버 상태 확인) |
| `POST` | `/api/add-line` | Key/Value 데이터 업로드 |
| `GET` | `/api/unanswered` | 미답변 질문 조회 |
| `GET` | `/api/status` | 앱 상태 조회 |
| `GET` | `/api/next-row` | 다음 빈 행 조회 |

### 5.2.1. `GET /` — 헬스 체크
서버가 정상 동작 중인지 확인합니다.

```bash
curl http://localhost:3013/
```
**응답 예시:**
```json
{"status": "ok", "app": "fGoogleSheet", "port": 3013, "accessMode": "API"}
```

### 5.2.2. `POST /api/add-line` — 데이터 업로드
Key/Value 쌍을 Google Sheets에 업로드합니다. Key는 A열, Value는 B열에 기록됩니다.

```bash
curl -X POST http://localhost:3013/api/add-line \
  -H "Content-Type: application/json" \
  -d '{"key":"Swift란?","value":"Apple이 개발한 프로그래밍 언어"}'
```
**응답 예시:**
```json
{"success": true, "targetRow": 5, "nextRow": 6, "newQuestionCnt": 2, "hasNewQuestions": true}
```
- `key` (필수): A열에 입력할 텍스트
- `value` (선택): B열에 입력할 텍스트 (빈 문자열 허용)

### 5.2.3. `GET /api/unanswered` — 미답변 질문 조회
A열에 내용이 있지만 B열이 비어있는 행을 검색합니다. 연속 10개의 빈 행을 만나면 스캔을 중단합니다.

```bash
# 기본 조회 (2행부터)
curl http://localhost:3013/api/unanswered

# 특정 행부터 조회
curl "http://localhost:3013/api/unanswered?startRow=10"
```
**응답 예시:**
```json
{
  "count": 2,
  "questions": [
    {"row": 5, "question": "async/await란?", "cellA": "A5", "cellB": "B5"},
    {"row": 8, "question": "@State란?", "cellA": "A8", "cellB": "B8"}
  ]
}
```

### 5.2.4. `GET /api/status` — 앱 상태 조회
앱의 현재 상태 (실행 상태, 접근 모드, 인증 상태 등)를 반환합니다.

```bash
curl http://localhost:3013/api/status
```
**응답 예시:**
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

### 5.2.5. `GET /api/next-row` — 다음 빈 행 조회
Google Sheets에서 다음 빈 행 번호를 조회합니다.

```bash
curl http://localhost:3013/api/next-row

# 특정 행부터 스캔
curl "http://localhost:3013/api/next-row?startRow=10"
```
**응답 예시:**
```json
{"nextRow": 15, "newQuestionCnt": 3}
```

## 5.3. 보안 정책
- **기본 비활성**: 설정에서 명시적으로 활성화해야 동작
- **localhost 전용**: 활성화 시 기본적으로 `127.0.0.1`에만 바인딩
- **CIDR 기반 IP 필터링**: 허용 범위 외 요청은 `403 Forbidden` 반환
- **외부 접속 허용**: 설정에서 별도로 활성화해야 외부 IP 접근 가능
- **설정 변경 제외**: API Key, OAuth 토큰, URL 등 민감한 설정은 REST API로 변경 불가
- **CORS 지원**: 모든 응답에 `Access-Control-Allow-Origin: *` 헤더 포함

### CIDR 설정 예시

| CIDR | 허용 범위 |
|------|-----------|
| `127.0.0.1/32` | 로컬만 (기본값) |
| `192.168.0.0/24` | 192.168.0.1~254 |
| `10.0.0.0/8` | 10.x.x.x 전체 |
| `0.0.0.0/0` | 모든 IP (주의 필요) |

## 5.4. 서버 설정 항목

| 설정 항목 | 설명 | 기본값 |
|-----------|------|--------|
| API 서버 활성화 | REST API 서버 on/off | 비활성 |
| 포트 | 서버 리스닝 포트 번호 | 3013 |
| 외부 접속 허용 | 로컬 외 IP 접근 허용 여부 | 비허용 |
| 허용 CIDR | 접근 허용 IP 범위 (CIDR 표기) | `127.0.0.1/32` |

## 5.5. HTTP 에러 코드

| 코드 | 상황 |
|------|------|
| `200` | 정상 응답 |
| `400` | 잘못된 요청 (key 누락, JSON 파싱 실패) |
| `401` | 인증 실패 (OAuth 토큰 만료 또는 미설정) |
| `403` | 접근 거부 (CIDR 범위 외 IP) |
| `500` | 내부 오류 (Google Sheets API 호출 실패) |
| `503` | 서비스 불가 (앱 초기화 미완료) |

## 5.6. UI 자동 반영
REST API를 통한 데이터 업로드 시 앱 UI의 입력 필드에 자동으로 데이터가 반영됩니다. NotificationCenter를 통해 ContentView와 실시간 동기화됩니다.

> 전체 API 스펙: `api/openapi.yaml` 참조

---

# 6. Claude Code Skill (AI 에이전트 연동)

## 6.1. 개요
fGoogleSheet는 Claude Code 전용 플러그인(스킬)을 제공합니다. 설치 후 Claude Code 대화창에서 슬래시 커맨드(`/fgooglesheet`)로 Google Sheets 데이터를 직접 관리할 수 있습니다. REST API 서버를 브릿지로 사용하므로, 앱이 실행 중이고 REST API가 활성화된 상태여야 합니다.

## 6.2. 주요 기능
- **데이터 추가**: Key/Value 쌍을 Google Sheets에 즉시 업로드
- **미답변 질문 조회**: A열은 있지만 B열이 비어있는 행을 검색
- **앱 상태 조회**: 실행 상태, 인증 상태, 시트 정보 등 확인
- **다음 빈 행 찾기**: 다음 데이터 입력 위치 조회
- **서버 미실행 안내**: REST API 서버가 꺼져 있으면 fGoogleSheet.app 실행을 안내

## 6.3. 설치 방법

### 방법 1: Plugin 설치 (권장)
```bash
/plugin marketplace add nowage/fGoogleSheet
/plugin install fgooglesheet
```

### 방법 2: 수동 복사
```bash
# fGoogleSheet 프로젝트 루트에서 실행
cp -r agents/claude/.claude-plugin .claude-plugin
cp -r agents/claude/skills .claude/skills
```

### 방법 3: 심볼릭 링크
```bash
ln -sf agents/claude/skills/fgooglesheet .claude/skills/fgooglesheet
```

## 6.4. 사용 예시
```bash
# Key/Value 데이터 추가
/fgooglesheet:fgooglesheet Docker란? 컨테이너 가상화 플랫폼

# 미답변 질문 조회
/fgooglesheet:fgooglesheet --unanswered

# 앱 상태 확인
/fgooglesheet:fgooglesheet --status

# 다음 빈 행 조회
/fgooglesheet:fgooglesheet --next-row

# 서버 주소 변경
/fgooglesheet:fgooglesheet --server=http://192.168.1.10:3013 Docker란? 컨테이너
```

## 6.5. 옵션 목록

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `--unanswered` | 미답변 질문 조회 | - |
| `--status` | 앱 상태 조회 | - |
| `--next-row` | 다음 빈 행 찾기 | - |
| `--server=<주소>` | 서버 주소 변경 | `http://localhost:3013` |

## 6.6. 전제 조건
- fGoogleSheet.app이 실행 중이어야 합니다
- 앱 설정에서 REST API 서버가 활성화되어 있어야 합니다
- 기본 서버 주소: `http://localhost:3013`

> 플러그인 상세 정보: `agents/claude/README_kr.md` 참조

---

# 7. MCP 서버 (Model Context Protocol)

## 7.1. 개요
MCP(Model Context Protocol)는 AI 에이전트가 외부 도구와 표준화된 방식으로 통신하기 위한 프로토콜입니다. fGoogleSheet는 MCP 서버를 제공하여 Claude Desktop, Claude Code 등 MCP 호환 클라이언트에서 Google Sheets 데이터를 자동으로 관리할 수 있습니다.

## 7.2. 아키텍처

```
[MCP 클라이언트]          [MCP 서버]              [fGoogleSheet 앱]
(Claude Desktop,    ──→   fgooglesheet-mcp   ──→   REST API Server
 Claude Code 등)          (Node.js, stdio)         (NWListener, 포트 3013)
```

MCP 서버는 fGoogleSheet 앱의 REST API를 호출하는 브릿지 역할을 합니다. 표준 stdio 트랜스포트를 사용하며, `@modelcontextprotocol/sdk` 기반으로 구현되었습니다.

## 7.3. 제공 도구 (5개)

| 도구명 | 설명 | 파라미터 |
|--------|------|----------|
| `health_check` | REST API 서버 동작 여부 확인 | 없음 |
| `add_line` | Key/Value 쌍을 Google Sheets에 업로드 | `key` (필수), `value` (선택) |
| `find_unanswered` | A열은 있지만 B열이 비어있는 미답변 질문 조회 | `start_row` (선택, 기본값: 2) |
| `get_status` | 앱 상태 조회 (실행 상태, 인증, 시트 정보) | 없음 |
| `find_next_row` | 다음 빈 행 번호 조회 | `start_row` (선택, 기본값: 2) |

## 7.4. 설치 방법

### 방법 1: npx 실행 (설치 없이)
```bash
npx fgooglesheet-mcp
```

### 방법 2: npm 글로벌 설치
```bash
npm install -g fgooglesheet-mcp
fgooglesheet-mcp
```

### 방법 3: 소스에서 직접 실행
```bash
cd mcp
npm install
node index.js
```

## 7.5. 서버 URL 설정

서버 URL은 다음 우선순위로 결정됩니다:

1. **CLI 인수**: `--server=<url>`
2. **환경 변수**: `FGOOGLESHEET_SERVER`
3. **기본값**: `http://localhost:3013`

```bash
# CLI 인수로 지정
node index.js --server=http://192.168.1.10:3013

# 환경 변수로 지정
FGOOGLESHEET_SERVER=http://192.168.1.10:3013 node index.js
```

## 7.6. Claude Desktop 설정

`claude_desktop_config.json` 파일에 다음을 추가합니다:

```json
{
  "mcpServers": {
    "fgooglesheet": {
      "command": "npx",
      "args": ["fgooglesheet-mcp"]
    }
  }
}
```

커스텀 서버 주소를 사용하는 경우:
```json
{
  "mcpServers": {
    "fgooglesheet": {
      "command": "npx",
      "args": ["fgooglesheet-mcp", "--server=http://192.168.1.10:3013"]
    }
  }
}
```

환경 변수를 사용하는 경우:
```json
{
  "mcpServers": {
    "fgooglesheet": {
      "command": "npx",
      "args": ["fgooglesheet-mcp"],
      "env": {
        "FGOOGLESHEET_SERVER": "http://192.168.1.10:3013"
      }
    }
  }
}
```

## 7.7. Claude Code 설정

```bash
# Claude Code에서 MCP 서버 등록
claude mcp add fgooglesheet npx fgooglesheet-mcp

# 서버 주소 지정 시
claude mcp add fgooglesheet npx fgooglesheet-mcp -- --server=http://192.168.1.10:3013
```

## 7.8. 전제 조건
- Node.js v18 이상
- fGoogleSheet.app이 실행 중이고 REST API가 활성화된 상태
- MCP 호환 클라이언트 (Claude Desktop, Claude Code 등)

> MCP 서버 소스: `mcp/` 참조
