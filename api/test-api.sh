#!/bin/bash
#
# Usage:
#   bash test-api.sh [--server=<url>]
#
# Arguments:
#   --server=<url> : (option) Server URL (default: http://localhost:3013)
#
# Examples:
#   bash test-api.sh
#   bash test-api.sh --server=http://192.168.0.10:3013
#

SERVER="http://localhost:3013"

for arg in "$@"; do
  case $arg in
    --server=*)
      SERVER="${arg#*=}"
      ;;
  esac
done

PASS=0
FAIL=0
TOTAL=0

run_test() {
  local name="$1"
  local result="$2"  # 0=pass, 1=fail
  TOTAL=$((TOTAL + 1))
  if [ "$result" -eq 0 ]; then
    PASS=$((PASS + 1))
    echo "  [PASS] #${TOTAL} ${name}"
  else
    FAIL=$((FAIL + 1))
    echo "  [FAIL] #${TOTAL} ${name}"
  fi
}

echo "=== fGoogleSheet REST API Test ==="
echo "Server: ${SERVER}"
echo ""

# 1. Health Check (GET /)
echo "--- Health Check ---"
RESPONSE=$(curl -s -w "\n%{http_code}" "${SERVER}/")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "200" ] && echo "$BODY" | grep -q '"status"'; then
  run_test "GET / - Health Check (200 + status field)" 0
else
  run_test "GET / - Health Check (200 + status field)" 1
fi

if echo "$BODY" | grep -q '"fGoogleSheet"'; then
  run_test "GET / - app field is fGoogleSheet" 0
else
  run_test "GET / - app field is fGoogleSheet" 1
fi

# 2. App Status (GET /api/status)
echo ""
echo "--- App Status ---"
RESPONSE=$(curl -s -w "\n%{http_code}" "${SERVER}/api/status")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "200" ] && echo "$BODY" | grep -q '"executionState"'; then
  run_test "GET /api/status - status response (200)" 0
else
  run_test "GET /api/status - status response (200)" 1
fi

if echo "$BODY" | grep -q '"accessMode"'; then
  run_test "GET /api/status - accessMode field exists" 0
else
  run_test "GET /api/status - accessMode field exists" 1
fi

# 3. Add Line (POST /api/add-line)
echo ""
echo "--- Add Line ---"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "${SERVER}/api/add-line" \
  -H "Content-Type: application/json" \
  -d '{"key": "TEST_KEY", "value": "TEST_VALUE"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "200" ] && echo "$BODY" | grep -q '"success"'; then
  run_test "POST /api/add-line - key+value (200)" 0
else
  run_test "POST /api/add-line - key+value (${HTTP_CODE})" 1
fi

# 3-1. Add Line - missing key (400)
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "${SERVER}/api/add-line" \
  -H "Content-Type: application/json" \
  -d '{}')
HTTP_CODE=$(echo "$RESPONSE" | tail -1)

if [ "$HTTP_CODE" = "400" ]; then
  run_test "POST /api/add-line - missing key (400)" 0
else
  run_test "POST /api/add-line - missing key (expected 400, got ${HTTP_CODE})" 1
fi

# 4. Unanswered Questions (GET /api/unanswered)
echo ""
echo "--- Unanswered Questions ---"
RESPONSE=$(curl -s -w "\n%{http_code}" "${SERVER}/api/unanswered")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "200" ] && echo "$BODY" | grep -q '"count"'; then
  run_test "GET /api/unanswered - response (200)" 0
else
  run_test "GET /api/unanswered - response (${HTTP_CODE})" 1
fi

# 5. Next Row (GET /api/next-row)
echo ""
echo "--- Next Row ---"
RESPONSE=$(curl -s -w "\n%{http_code}" "${SERVER}/api/next-row")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "200" ] && echo "$BODY" | grep -q '"nextRow"'; then
  run_test "GET /api/next-row - response (200)" 0
else
  run_test "GET /api/next-row - response (${HTTP_CODE})" 1
fi

# 6. 404 Not Found
echo ""
echo "--- Error Handling ---"
RESPONSE=$(curl -s -w "\n%{http_code}" "${SERVER}/api/nonexistent")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)

if [ "$HTTP_CODE" = "404" ]; then
  run_test "GET /api/nonexistent - 404 response" 0
else
  run_test "GET /api/nonexistent - expected 404, got ${HTTP_CODE}" 1
fi

# Summary
echo ""
echo "=== Results: ${PASS}/${TOTAL} passed, ${FAIL} failed ==="
if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
