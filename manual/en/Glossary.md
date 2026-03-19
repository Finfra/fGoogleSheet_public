# Glossary

This document organizes the key terms and multilingual translation standards used in the fGoogleSheet project. These terms serve as the reference for development, manual writing, and UI modifications.

| Description (Development)                        | English           | Korean            | Japanese               | German                 | Spanish                    | French                       |
| :----------------------------------------------- | :---------------- | :---------------- | :--------------------- | :--------------------- | :------------------------- | :--------------------------- |
| Core input data (question/item name, etc.)       | Key               | 키                | キー                   | Schlüssel              | Clave                      | Clé                          |
| Corresponding input data (answer/content, etc.)  | Value             | 값 (답변)         | 値                     | Wert                   | Valor                      | Valeur                       |
| Authentication key for Google Sheets access       | API Key           | API 키            | APIキー                | API-Schlüssel          | Clave de API               | Clé API                      |
| ID of the target spreadsheet                     | Document ID       | 문서 ID           | ドキュメントID         | Dokument-ID            | ID de documento            | ID du document               |
| Active tab of the sheet for data entry           | Sheet Tab         | 시트 탭           | シートタブ             | Tabellenblatt          | Pestaña de hoja            | Onglet de feuille            |
| Find empty row and append data                   | Append            | 이어쓰기 (추가)   | 追加                   | Anhängen               | Añadir                     | Ajouter                      |
| Question item with no answer found               | Unanswered        | 미답변 질문       | 未回答の質問           | Unbeantwortet          | Sin respuesta              | Sans réponse                 |
| Options that control app behavior                | Settings          | 설정              | 設定                   | Einstellungen          | Configuración              | Paramètres                   |
| Built-in HTTP API server                         | REST API Server   | REST API 서버     | REST APIサーバー       | REST-API-Server        | Servidor REST API          | Serveur REST API             |
| IP range allow notation                          | CIDR              | CIDR              | CIDR                   | CIDR                   | CIDR                       | CIDR                         |
| Server health verification request              | Health Check      | 헬스 체크         | ヘルスチェック         | Gesundheitscheck       | Verificación de estado     | Vérification de santé        |
| Cross-Origin Resource Sharing                    | CORS              | CORS              | CORS                   | CORS                   | CORS                       | CORS                         |
| Standard communication protocol between AI model and tools | MCP (Model Context Protocol) | MCP (모델 컨텍스트 프로토콜) | MCP (モデルコンテキストプロトコル) | MCP (Modellkontextprotokoll) | MCP (Protocolo de Contexto de Modelo) | MCP (Protocole de Contexte de Modèle) |
| Plugin skill for Claude Code                     | Claude Code Skill | Claude Code 스킬  | Claude Code スキル     | Claude Code Skill      | Claude Code Skill          | Claude Code Skill            |
| Bridge server based on MCP protocol              | MCP Server        | MCP 서버          | MCPサーバー            | MCP-Server             | Servidor MCP               | Serveur MCP                  |
| stdio-based standard I/O transport               | stdio Transport   | stdio 트랜스포트  | stdio トランスポート   | stdio Transport        | Transporte stdio           | Transport stdio              |
| Slash (/) prefixed command method                | Slash Command     | 슬래시 커맨드     | スラッシュコマンド     | Slash-Befehl           | Comando slash              | Commande slash               |

> **Note**:
> *   Empty cells indicate that the translation has not been finalized or an exact match was not found in the corresponding language resource files.
> *   Source Code References: `ConfigManager.swift`, `ContentView.swift`
