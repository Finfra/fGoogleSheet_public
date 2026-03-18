# fGoogleSheet 매뉴얼 개요 (Manual Structure Overview)

본 문서는 fGoogleSheet 사용자/개발자 매뉴얼의 상위 구조와 작성 가이드를 정의합니다. 실제 세부 문서는 본 구조에 따라 하위 `en`/`kr` 폴더나 문서 파일로 확장합니다.

## 목적과 범위
- 대상: 일반 사용자(설치/사용), 파워유저(데이터 관리), 개발자(빌드/디버깅)
- 범위: 설치 → 빠른 시작 → 사용자 가이드 → 디버깅 및 에러 처리
- 규칙: 모든 링크는 리포지토리 루트 기준 상대 경로 사용, 한국어 우선(`kr` 폴더, 영문은 `en` 폴더 내 작성)

## 디렉토리 구조(제안)
- 01_Overview/
  - Introduction.md: 제품 개요, 주요 기능(Key/Value 입력, G-Sheet 연동)
- 02_Install/
  - Install_macOS.md: 요구사항, 설치 방법, 첫 실행 체크리스트
  - Setup_API.md: Google Sheets API Key 발급 및 설정 가이드
- 03_QuickStart/
  - QuickStart.md: 앱 초기 설정 → 첫 데이터 전송 흐름
- 04_UserGuide/
  - UsingInput.md: Key/Value 입력 폼, 멀티라인 TextEditor 사용법
  - Search.md: 답변 없는 질문 검색(`cmd+f`) 동작 원리
  - Settings.md: 외부 ID, API Key, 탭 변경 및 폰트 크기 변경
- 05_REST_API/
  - REST_Setup.md: REST API 서버 활성화 및 설정 (포트, CIDR)
  - REST_Endpoints.md: 엔드포인트별 사용법 (curl 예시 포함)
  - REST_Security.md: CIDR 기반 IP 필터링, 보안 정책
  - REST_Automation.md: 외부 스크립트/자동화 연동 가이드
- 06_AI_Integration/
  - ClaudeSkill.md: Claude Code Skill 설치 및 사용법 (슬래시 커맨드)
  - MCP_Server.md: MCP 서버 설치, 설정, 도구 목록
  - MCP_ClaudeDesktop.md: Claude Desktop용 MCP 설정 가이드
  - MCP_ClaudeCode.md: Claude Code용 MCP 설정 가이드
- 07_Debugging/
  - Troubleshooting.md: API 권한(Network 이슈), 데이터 수신 에러 해결 등
- 08_Reference/
  - Shortcuts.md: 전역 및 앱 내 키보드 단축키
- 99_Appendix/
  - Glossary.md: 용어 사전(프로젝트 용어 통일)

## 작성 가이드
- 파일/제목 규칙: 폴더별 주제 중심, 명사형 제목 사용
- 링크 정책: 문서 간 교차 참조는 상대 경로 사용
- 스크린샷/캡처: `fGoogleSheet.capture` 폴더의 이미지를 참조 및 활용
- 버전/변경 이력: Release 하위에 요약 정리

## 빠른 시작(요약)
- 빌드(디버그): `xcodebuild -scheme fGoogleSheet -configuration Debug build`
- 초기 설정: 상단 모달을 열고 `Target Document ID`, `App ID`, `App Secret` 지정
- 활용: `Key`와 `Value` 입력 후 `cmd+r` 단축키로 시트에 데이터 적재

## 관련 리소스
- **REST API 스펙**: `_public/api/openapi.yaml` (OpenAPI 3.0.3)
- **Claude Code Skill**: `_public/agents/claude/` (플러그인 및 스킬 파일)
- **MCP 서버**: `_public/mcp/` (Node.js MCP 서버 소스)
- **기능 명세서**: `FunctionalSpecification.md` (REST API, Skill, MCP 상세 설명 포함)

## 향후 작성 일정(To‑Do)
- [ ] 01_Overview/Introduction.md 작성
- [ ] 02_Install/Setup_API.md 작성 (권한 획득 스크린샷)
- [ ] 04_UserGuide/Settings.md 작성 (UI 각 영역 설명)
- [ ] 05_REST_API/ 전체 작성 (설정, 엔드포인트, 보안, 자동화)
- [ ] 06_AI_Integration/ 전체 작성 (Claude Skill, MCP 서버 가이드)
- [ ] 08_Reference/Shortcuts.md 정리
- [ ] 09_FAQ/FAQ.md (자주 발생하는 시트 연동 오류 모음)

---
본 README는 fGoogleSheet 매뉴얼의 “맵” 역할을 합니다. 각 섹션 작성 시 본 구조를 기준으로 문서를 추가하고, 완료 후 본 리스트의 To‑Do를 체크하세요.
