---
name: answer-unanswered-questions
description: Workflow to find unanswered questions from the fGoogleSheet application via API and provide answers to them.
---

# Answer Unanswered Questions Workflow

This workflow is designed to automate finding unanswered questions in the currently running fGoogleSheet app and adding answers using the `fgooglesheet-api` skill.

## Prerequisites
- The fGoogleSheet macOS app must be running.
- The app's REST API must be enabled and accessible at `http://localhost:3013`.

## Workflow Steps

### 1. Check App Status
Ensure the application is running, connected to a sheet, and authenticated.
```bash
curl -s http://localhost:3013/api/status
```
Verify `isAuthenticated` is true, and check `currentRow`.

### 2. Find Unanswered Questions
Retrieve the list of unanswered questions currently present in the sheet.
```bash
curl -s "http://localhost:3013/api/unanswered?startRow=2"
```

### 3. Generate Answers
For each question retrieved from the previous step, use your knowledge base or available tools to draft an appropriate answer. 

### 4. Upload Answers
For each answered question, write it back to the sheet using the `add-line` endpoint. Note that `add-line` appends new rows; to update existing ones, you may need a separate Apps Script/Playwright skill. However, for adding new answered questions:
```bash
curl -s -X POST http://localhost:3013/api/add-line \
  -H "Content-Type: application/json" \
  -d '{"key": "Question Text", "value": "Answer Text"}'
```

### 5. Verify Target Row
After posting, verify the response contains `success: true` and observe the `targetRow`.
