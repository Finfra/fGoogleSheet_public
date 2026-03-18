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

## 5.3. 보안 정책
- **기본 비활성**: 설정에서 명시적으로 활성화해야 동작
- **CIDR 기반 IP 필터링**: 허용 범위 외 요청은 403 Forbidden
- **설정 변경 제외**: API Key, OAuth 토큰, URL 등 민감한 설정은 REST API로 변경 불가
- **CORS 지원**: 모든 응답에 `Access-Control-Allow-Origin: *` 포함

## 5.4. UI 자동 반영
REST API를 통한 데이터 업로드 시 앱 UI의 입력 필드에 자동으로 데이터가 반영됩니다. NotificationCenter를 통해 ContentView와 실시간 동기화됩니다.

> 전체 API 스펙: `_public/api/openapi.yaml` 참조
