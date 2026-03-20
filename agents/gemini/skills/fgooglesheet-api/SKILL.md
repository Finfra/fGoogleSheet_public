---
name: fgooglesheet-api
description: Use this skill to interact with the running fGoogleSheet macOS application via its local REST API (http://localhost:3013). This allows adding rows to Google Sheets, checking unanswered questions, and getting app status.
---

# fGoogleSheet API Skill

## Overview

This skill provides instructions on how to interact with the fGoogleSheet macOS application while it is running. The app exposes a local REST API on `http://localhost:3013` that allows you to add data to Google Sheets, query unanswered questions, and check the app's status.

## How to use the API

You can use standard CLI tools like `curl` or `run_shell_command` with `curl` to interact with the endpoints.

### 1. Check App Health / Status

Before performing operations, you should ensure the app is running and the API is accessible.

```bash
# Health Check
curl -s http://localhost:3013/

# Get detailed app status (execution state, authentication, sheet info)
curl -s http://localhost:3013/api/status
```

### 2. Add a Row to Google Sheets

You can add a key/value pair. The key goes to Column A, and the value goes to Column B.

```bash
# Add both question and answer
curl -s -X POST http://localhost:3013/api/add-line \
  -H "Content-Type: application/json" \
  -d '{"key": "What is Swift?", "value": "A programming language by Apple."}'

# Add only a question (unanswered)
curl -s -X POST http://localhost:3013/api/add-line \
  -H "Content-Type: application/json" \
  -d '{"key": "What is SwiftUI?"}'
```

### 3. Find Unanswered Questions

Finds rows where Column A has a question, but Column B is empty.

```bash
curl -s "http://localhost:3013/api/unanswered?startRow=2"
```

### 4. Find Next Empty Row

```bash
curl -s "http://localhost:3013/api/next-row?startRow=2"
```

## API Reference

For full details on request/response schemas, refer to the [openapi.yaml](references/openapi.yaml) file included in this skill's `references` directory.
