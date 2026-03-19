# fgooglesheet-mcp

**fGoogleSheet** macOS Google Sheets 관리 애플리케이션을 위한 MCP (Model Context Protocol) 서버입니다.

AI 어시스턴트(Claude Code, Claude Desktop 등)와 fGoogleSheet의 REST API를 연결하여, 자연어로 Google Sheets 작업을 수행할 수 있습니다.

## 아키텍처

```
AI 어시스턴트 (Claude)
       │
       │ MCP 프로토콜 (stdio)
       ▼
┌─────────────────────┐
│  fgooglesheet-mcp   │
│  (MCP 서버)         │
└─────────┬───────────┘
          │ HTTP REST API
          ▼
┌─────────────────────┐
│  fGoogleSheet 앱    │
│  (포트 3013)        │
└─────────┬───────────┘
          │ Google Sheets API v4
          ▼
┌─────────────────────┐
│  Google Sheets      │
└─────────────────────┘
```

## 설치 방법

### 방법 1: npm 전역 설치

```bash
npm install -g fgooglesheet-mcp
```

### 방법 2: npx (설치 없이 실행)

```bash
npx fgooglesheet-mcp
```

### 방법 3: 소스에서 직접 실행

```bash
git clone https://github.com/nowage/fGoogleSheet.git
cd fGoogleSheet/mcp
npm install
node index.js
```

## 설정

### Claude Code 설정

`~/.claude/settings.json`에 추가:

```json
{
  "mcpServers": {
    "fgooglesheet": {
      "command": "npx",
      "args": ["-y", "fgooglesheet-mcp"]
    }
  }
}
```

### Claude Desktop 설정

Claude Desktop 설정 파일(`~/Library/Application Support/Claude/claude_desktop_config.json`)에 추가:

```json
{
  "mcpServers": {
    "fgooglesheet": {
      "command": "npx",
      "args": ["-y", "fgooglesheet-mcp"]
    }
  }
}
```

### 원격 서버 지정

다른 머신에서 실행 중인 fGoogleSheet에 연결하려면:

```json
{
  "mcpServers": {
    "fgooglesheet": {
      "command": "npx",
      "args": ["-y", "fgooglesheet-mcp", "--server=http://192.168.1.100:3013"]
    }
  }
}
```

환경변수를 사용할 수도 있습니다:

```json
{
  "mcpServers": {
    "fgooglesheet": {
      "command": "npx",
      "args": ["-y", "fgooglesheet-mcp"],
      "env": {
        "FGOOGLESHEET_SERVER": "http://192.168.1.100:3013"
      }
    }
  }
}
```

### 서버 URL 결정 순서

1. CLI 인자: `--server=<url>`
2. 환경변수: `FGOOGLESHEET_SERVER`
3. 기본값: `http://localhost:3013`

## 도구 목록

### health_check

fGoogleSheet REST API 서버의 동작 여부를 확인합니다.

```
파라미터: 없음
```

**사용 예시**: "fGoogleSheet 서버가 실행 중인지 확인해줘"

### add_line

Google Sheets에 Key/Value 쌍을 추가합니다.

```
파라미터:
  key   (string, 필수) - A열에 입력할 내용
  value (string, 선택) - B열에 입력할 내용 (기본값: "")
```

**사용 예시**: "'REST API란 무엇인가?'를 Google Sheets에 추가해줘"

### find_unanswered

A열에 내용이 있지만 B열이 비어있는 미답변 행을 조회합니다.

```
파라미터:
  start_row (number, 선택) - 검색 시작 행 (기본값: 2)
```

**사용 예시**: "스프레드시트에서 아직 답변 안 된 질문 보여줘"

### get_status

현재 애플리케이션 상태 및 설정 정보를 조회합니다.

```
파라미터: 없음
```

**사용 예시**: "fGoogleSheet 현재 상태가 어때?"

### find_next_row

데이터 입력이 가능한 다음 빈 행을 조회합니다.

```
파라미터:
  start_row (number, 선택) - 검색 시작 행 (기본값: 2)
```

**사용 예시**: "다음으로 사용 가능한 행이 몇 번째야?"

## MCP Inspector로 테스트

```bash
npx @modelcontextprotocol/inspector npx fgooglesheet-mcp
```

웹 UI가 열리며, 각 도구를 인터랙티브하게 테스트할 수 있습니다.

## 사전 요구사항

- **fGoogleSheet.app**이 실행 중이고 REST API가 활성화되어 있어야 합니다
- REST API 서버는 기본적으로 포트 3013에서 대기합니다
- Node.js >= 18.0.0

## 라이선스

MIT
