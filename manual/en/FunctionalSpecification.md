---
title: fGoogleSheet User Manual & Functional Specification
description: This document provides a comprehensive and detailed guide to fGoogleSheet's core value creation tools — **Key/Value-based data input** and **direct Google Sheets API v4 integration** system.
date: 2026.03.14
tags: [manual, user guide, functional specification]
---

# What is fGoogleSheet? (Overview)

fGoogleSheet is a macOS-exclusive productivity maximization tool that provides immediate access to **Google Sheets** from the desktop environment for quickly handling repetitive data recording tasks. It communicates directly with Google Sheets API v4 without complex external dependencies and offers an intuitive UI.

---

# 1. Data Input & Upload

## 1.1. Key/Value Dual Layout Structure
The screen is divided into Key (question) and Value (answer) input fields at a 1:3 ratio.
Users can review long questions or text and quickly enter corresponding answers.
- Multi-line TextEditor is supported for easy composition of lengthy text.
- Use the `Tab` key to naturally navigate between Key and Value fields.

## 1.2. Korean Support & Error Handling
All entered text is safely processed in UTF-8 format, designed to ensure that Korean input is reflected in Google Sheets without any character corruption.

---

# 2. Google Sheets API Integration System

## 2.1. Direct Communication Without External Dependencies
fGoogleSheet communicates directly with the Google REST API v4 specification through its built-in `GoogleSheetsService` infrastructure. By not going through external SDKs (such as Firebase), it is lightweight, fast, and easy to customize.

## 2.2. Automatic Empty Row Detection & Append
When uploading data, the app reads the sheet data to automatically identify the last position where data was entered (empty row) and safely appends data starting from the next row. This protects against loss of existing data.

---

# 3. Unanswered Data Tracking & Management

## 3.1. Check Unanswered Questions (`cmd+f`)
When many Key values have been entered but Values are empty, the app automatically inspects the spreadsheet status and immediately retrieves Key items that need answers. This is an essential tracking system to prevent recording omissions.

---

# 4. App Runtime System & Configuration Environment

## 4.1. Flexible Configuration (ConfigManager)
When accessing a new document (Target Document ID) or when the target sheet tab name changes, there is no need to modify the source code. Simply modify values in the app's settings window and they are immediately persisted to the file system and reflected in real-time for API communication.

## 4.2. Global Keyboard Commands
For efficiency in data input and management, keyboard commands are preferred over mouse clicks.
- `cmd+k`: Clear input form data
- `cmd+r`: Save data and send via API
- `cmd+f`: Check unanswered questions (empty Value fields)
- `cmd+enter`: Save data, send via API, and hide app

---

# 5. REST API Server (External Integration)

## 5.1. Built-in HTTP Server
fGoogleSheet provides a built-in REST API server based on NWListener. External clients (curl, scripts, automation tools) can control the app's core features via HTTP requests.

## 5.2. Available Endpoints

| Method | Path | Function |
|--------|------|----------|
| `GET` | `/` | Health check (server status verification) |
| `POST` | `/api/add-line` | Key/Value data upload |
| `GET` | `/api/unanswered` | Query unanswered questions |
| `GET` | `/api/status` | Query app status |
| `GET` | `/api/next-row` | Query next empty row |

### 5.2.1. `GET /` — Health Check
Verifies that the server is operating normally.

```bash
curl http://localhost:3013/
```
**Response example:**
```json
{"status": "ok", "app": "fGoogleSheet", "port": 3013, "accessMode": "API"}
```

### 5.2.2. `POST /api/add-line` — Data Upload
Uploads a Key/Value pair to Google Sheets. Key is recorded in column A, Value in column B.

```bash
curl -X POST http://localhost:3013/api/add-line \
  -H "Content-Type: application/json" \
  -d '{"key":"What is Swift?","value":"A programming language developed by Apple"}'
```
**Response example:**
```json
{"success": true, "targetRow": 5, "nextRow": 6, "newQuestionCnt": 2, "hasNewQuestions": true}
```
- `key` (required): Text to enter in column A
- `value` (optional): Text to enter in column B (empty string allowed)

### 5.2.3. `GET /api/unanswered` — Query Unanswered Questions
Searches for rows where column A has content but column B is empty. Scanning stops after encountering 10 consecutive empty rows.

```bash
# Default query (starting from row 2)
curl http://localhost:3013/api/unanswered

# Query from a specific row
curl "http://localhost:3013/api/unanswered?startRow=10"
```
**Response example:**
```json
{
  "count": 2,
  "questions": [
    {"row": 5, "question": "What is async/await?", "cellA": "A5", "cellB": "B5"},
    {"row": 8, "question": "What is @State?", "cellA": "A8", "cellB": "B8"}
  ]
}
```

### 5.2.4. `GET /api/status` — Query App Status
Returns the current state of the app (execution state, access mode, authentication status, etc.).

```bash
curl http://localhost:3013/api/status
```
**Response example:**
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

### 5.2.5. `GET /api/next-row` — Query Next Empty Row
Queries the next empty row number from Google Sheets.

```bash
curl http://localhost:3013/api/next-row

# Scan from a specific row
curl "http://localhost:3013/api/next-row?startRow=10"
```
**Response example:**
```json
{"nextRow": 15, "newQuestionCnt": 3}
```

## 5.3. Security Policy
- **Disabled by default**: Must be explicitly enabled in settings to operate
- **localhost only**: When enabled, binds only to `127.0.0.1` by default
- **CIDR-based IP filtering**: Requests from outside the allowed range return `403 Forbidden`
- **External access**: Must be separately enabled in settings for external IP access
- **Configuration changes excluded**: Sensitive settings such as API Key, OAuth tokens, and URLs cannot be changed via REST API
- **CORS support**: All responses include `Access-Control-Allow-Origin: *` header

### CIDR Configuration Examples

| CIDR | Allowed Range |
|------|---------------|
| `127.0.0.1/32` | Local only (default) |
| `192.168.0.0/24` | 192.168.0.1~254 |
| `10.0.0.0/8` | All 10.x.x.x |
| `0.0.0.0/0` | All IPs (use with caution) |

## 5.4. Server Configuration Items

| Setting | Description | Default |
|---------|-------------|---------|
| API Server Enable | REST API server on/off | Disabled |
| Port | Server listening port number | 3013 |
| Allow External Access | Allow access from non-local IPs | Disallowed |
| Allowed CIDR | Allowed IP range (CIDR notation) | `127.0.0.1/32` |

## 5.5. HTTP Error Codes

| Code | Situation |
|------|-----------|
| `200` | Successful response |
| `400` | Bad request (missing key, JSON parsing failure) |
| `401` | Authentication failure (OAuth token expired or not configured) |
| `403` | Access denied (IP outside CIDR range) |
| `500` | Internal error (Google Sheets API call failure) |
| `503` | Service unavailable (app initialization incomplete) |

## 5.6. Automatic UI Sync
When data is uploaded via REST API, the app UI input fields are automatically updated with the data. Real-time synchronization with ContentView is achieved through NotificationCenter.

> Full API specification: See `api/openapi.yaml`

---

# 6. Claude Code Skill (AI Agent Integration)

## 6.1. Overview
fGoogleSheet provides a dedicated plugin (skill) for Claude Code. After installation, you can directly manage Google Sheets data from the Claude Code conversation window using the slash command (`/fgooglesheet`). Since it uses the REST API server as a bridge, the app must be running and REST API must be enabled.

## 6.2. Key Features
- **Add data**: Instantly upload Key/Value pairs to Google Sheets
- **Query unanswered questions**: Search for rows where column A exists but column B is empty
- **Query app status**: Check execution state, authentication status, sheet information, etc.
- **Find next empty row**: Query the next data entry position
- **Server not running notification**: If the REST API server is off, guides user to launch fGoogleSheet.app

## 6.3. Installation

### Method 1: Plugin Installation (Recommended)
```bash
/plugin marketplace add nowage/fGoogleSheet
/plugin install fgooglesheet
```

### Method 2: Manual Copy
```bash
# Run from fGoogleSheet project root
cp -r agents/claude/.claude-plugin .claude-plugin
cp -r agents/claude/skills .claude/skills
```

### Method 3: Symbolic Link
```bash
ln -sf agents/claude/skills/fgooglesheet .claude/skills/fgooglesheet
```

## 6.4. Usage Examples
```bash
# Add Key/Value data
/fgooglesheet:fgooglesheet What is Docker? A container virtualization platform

# Query unanswered questions
/fgooglesheet:fgooglesheet --unanswered

# Check app status
/fgooglesheet:fgooglesheet --status

# Query next empty row
/fgooglesheet:fgooglesheet --next-row

# Change server address
/fgooglesheet:fgooglesheet --server=http://192.168.1.10:3013 What is Docker? Container
```

## 6.5. Options List

| Option | Description | Default |
|--------|-------------|---------|
| `--unanswered` | Query unanswered questions | - |
| `--status` | Query app status | - |
| `--next-row` | Find next empty row | - |
| `--server=<address>` | Change server address | `http://localhost:3013` |

## 6.6. Prerequisites
- fGoogleSheet.app must be running
- REST API server must be enabled in app settings
- Default server address: `http://localhost:3013`

> Plugin details: See `agents/claude/README_kr.md`

---

# 7. MCP Server (Model Context Protocol)

## 7.1. Overview
MCP (Model Context Protocol) is a protocol for AI agents to communicate with external tools in a standardized way. fGoogleSheet provides an MCP server that enables automatic management of Google Sheets data from MCP-compatible clients such as Claude Desktop and Claude Code.

## 7.2. Architecture

```
[MCP Client]              [MCP Server]              [fGoogleSheet App]
(Claude Desktop,    -->   fgooglesheet-mcp   -->   REST API Server
 Claude Code, etc.)       (Node.js, stdio)         (NWListener, port 3013)
```

The MCP server acts as a bridge that calls fGoogleSheet app's REST API. It uses standard stdio transport and is implemented based on `@modelcontextprotocol/sdk`.

## 7.3. Available Tools (5)

| Tool Name | Description | Parameters |
|-----------|-------------|------------|
| `health_check` | Check REST API server availability | None |
| `add_line` | Upload Key/Value pair to Google Sheets | `key` (required), `value` (optional) |
| `find_unanswered` | Query unanswered questions with content in column A but empty column B | `start_row` (optional, default: 2) |
| `get_status` | Query app status (execution state, authentication, sheet info) | None |
| `find_next_row` | Query next empty row number | `start_row` (optional, default: 2) |

## 7.4. Installation

### Method 1: Run with npx (No Installation Required)
```bash
npx fgooglesheet-mcp
```

### Method 2: npm Global Installation
```bash
npm install -g fgooglesheet-mcp
fgooglesheet-mcp
```

### Method 3: Run from Source
```bash
cd mcp
npm install
node index.js
```

## 7.5. Server URL Configuration

The server URL is determined by the following priority:

1. **CLI argument**: `--server=<url>`
2. **Environment variable**: `FGOOGLESHEET_SERVER`
3. **Default**: `http://localhost:3013`

```bash
# Specify via CLI argument
node index.js --server=http://192.168.1.10:3013

# Specify via environment variable
FGOOGLESHEET_SERVER=http://192.168.1.10:3013 node index.js
```

## 7.6. Claude Desktop Configuration

Add the following to `claude_desktop_config.json`:

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

When using a custom server address:
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

When using environment variables:
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

## 7.7. Claude Code Configuration

```bash
# Register MCP server in Claude Code
claude mcp add fgooglesheet npx fgooglesheet-mcp

# When specifying server address
claude mcp add fgooglesheet npx fgooglesheet-mcp -- --server=http://192.168.1.10:3013
```

## 7.8. Prerequisites
- Node.js v18 or higher
- fGoogleSheet.app must be running with REST API enabled
- MCP-compatible client (Claude Desktop, Claude Code, etc.)

> MCP server source: See `mcp/`
