# fGoogleSheet REST API Documentation

## Overview

fGoogleSheet provides a REST API for uploading and managing Key/Value data to Google Sheets.

| Server | Tech Stack | Default Port |
|--------|-----------|--------------|
| macOS Native App | Swift / Network.framework (NWListener) | 3013 |

**Security**: The API server is disabled by default. When enabled, it binds to localhost (127.0.0.1) only. External access can be allowed via a checkbox in the settings UI, with IP filtering controlled by a CIDR range (e.g. `192.168.0.0/24`).

> OpenAPI 3.0 Spec: [openapi.yaml](./openapi.yaml) | [openapi_kr.yaml](./openapi_kr.yaml)

---

## Endpoints

### 1. Health Check

```
GET /
```

**Response**:
```json
{
  "status": "ok",
  "app": "fGoogleSheet",
  "port": 3013,
  "accessMode": "API"
}
```

---

### 2. Add Line to Google Sheets

```
POST /api/add-line
Content-Type: application/json
```

#### Request Parameters

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `key` | string | Yes | - | Text to write in column A (question/key) |
| `value` | string | No | `""` | Text to write in column B (answer/value) |

#### Request Example

```json
{
  "key": "What is Swift?",
  "value": "A programming language by Apple."
}
```

#### Response

**Success (200)**:
```json
{
  "success": true,
  "targetRow": 5,
  "nextRow": 6,
  "newQuestionCnt": 2,
  "hasNewQuestions": true
}
```

| Field | Type | Description |
|-------|------|-------------|
| `success` | boolean | Whether the upload succeeded |
| `targetRow` | integer | Row number where data was written |
| `nextRow` | integer | Next empty row number |
| `newQuestionCnt` | integer | Count of unanswered questions |
| `hasNewQuestions` | boolean | Whether there are unanswered questions |

**Errors**:

| Status Code | Cause | Response Example |
|-------------|-------|------------------|
| 400 | Missing key or JSON parsing failed | `{"error": "key field is required"}` |
| 401 | OAuth token expired or not configured | `{"error": "Authentication required"}` |
| 500 | Google Sheets API failure | `{"error": "Google Sheets API call failed"}` |
| 503 | App not initialized | `{"error": "DataManager not initialized"}` |

---

### 3. Find Unanswered Questions

```
GET /api/unanswered?startRow=2
```

#### Request Parameters

| Parameter | In | Required | Default | Description |
|-----------|-----|----------|---------|-------------|
| `startRow` | query | No | 2 | Row number to start scanning from |

#### Response

**Success (200)**:
```json
{
  "count": 2,
  "questions": [
    {
      "row": 5,
      "question": "What is async/await in Swift?",
      "cellA": "A5",
      "cellB": "B5"
    },
    {
      "row": 8,
      "question": "What is @State in SwiftUI?",
      "cellA": "A8",
      "cellB": "B8"
    }
  ]
}
```

Finds rows where column A has content but column B is empty. Scanning stops after 10 consecutive empty rows.

---

### 4. App Status

```
GET /api/status
```

**Response (200)**:
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

| Field | Type | Description |
|-------|------|-------------|
| `executionState` | string | Current state (`idle`, `saving`, `executing`, `completed`, `failed`, `loadingConfig`, `needsRestart`) |
| `accessMode` | string | Google Sheets access method (`API`, `AppsScript`, `Playwright`) |
| `currentRow` | integer | Current row number for data input |
| `sheetName` | string | Current sheet tab name |
| `isAuthenticated` | boolean | Whether OAuth authentication is valid |
| `restServerPort` | integer | REST server port number |

---

### 5. Find Next Empty Row

```
GET /api/next-row?startRow=2
```

#### Request Parameters

| Parameter | In | Required | Default | Description |
|-----------|-----|----------|---------|-------------|
| `startRow` | query | No | 2 | Row number to start scanning from |

#### Response

**Success (200)**:
```json
{
  "nextRow": 15,
  "newQuestionCnt": 3
}
```

---

## Usage Examples

### cURL

```bash
# Add data
curl -X POST http://localhost:3013/api/add-line \
  -H "Content-Type: application/json" \
  -d '{"key": "What is Swift?", "value": "A programming language by Apple."}'

# Add key only (no answer)
curl -X POST http://localhost:3013/api/add-line \
  -H "Content-Type: application/json" \
  -d '{"key": "What is SwiftUI?"}'

# Find unanswered questions
curl http://localhost:3013/api/unanswered

# Check app status
curl http://localhost:3013/api/status

# Find next empty row
curl http://localhost:3013/api/next-row

# Health check
curl http://localhost:3013/
```

### Python

```python
import requests

BASE_URL = 'http://localhost:3013'

# Add data
response = requests.post(
    f'{BASE_URL}/api/add-line',
    json={'key': 'What is Swift?', 'value': 'A programming language by Apple.'}
)
print(response.json())

# Find unanswered questions
response = requests.get(f'{BASE_URL}/api/unanswered')
print(response.json())

# Check app status
response = requests.get(f'{BASE_URL}/api/status')
print(response.json())
```

---

## Security

| Item | Description |
|------|-------------|
| Default State | API server **disabled** |
| Binding | localhost (127.0.0.1) only |
| External Access | Enabled via settings UI checkbox |
| IP Filtering | CIDR range configuration (e.g. `192.168.0.0/24`) |
| CORS | `Access-Control-Allow-Origin: *` |
| Denied Response | 403 Forbidden (`{"error": "Access denied: IP not in allowed CIDR range"}`) |

---

## App UI Integration

REST API requests are automatically synchronized with the app UI:

- `POST /api/add-line` automatically reflects data in the app's input fields
- Current row number increments automatically after upload
- Configuration changes are **excluded** from the REST API for security (settings UI only)

---

## Testing

```bash
# Automated tests (9 items)
bash api/test-api.sh

# Remote server test
bash api/test-api.sh --server=http://192.168.0.10:3013
```

Test items:
1. Health Check - status code 200 and `status` field
2. Health Check - `app` field is `fGoogleSheet`
3. App Status - status code 200 and `executionState` field
4. App Status - `accessMode` field exists
5. Add Line - key+value upload (200)
6. Add Line - missing key returns 400
7. Unanswered Questions - response with `count` field
8. Next Row - response with `nextRow` field
9. 404 Not Found - invalid path returns 404
