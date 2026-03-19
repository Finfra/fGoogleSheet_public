# fGoogleSheet Settings Guide

## 1. Prerequisites

### 1.1 Install Node.js
Node.js is **required only in Playwright mode**. You do not need to install it if you are not using this feature.

The app requires Node.js (v18 or higher) for Google Sheets integration.

```bash
# Install via Homebrew
brew install node

# Verify version
node --version   # v18 or higher required
npm --version
```

### 1.2 Install npm Packages
Install the required packages in the project's `extModule` directory.

```bash
cd fGoogleSheet/extModule
npm install
```

Packages installed:
- `express` - REST API server
- `body-parser` - Request body parsing
- `playwright` - Browser automation (Google Sheets manipulation)

### 1.3 Install Playwright Chromium Browser
You need to separately install the Chromium browser used by Playwright.

```bash
cd fGoogleSheet/extModule
npx playwright install chromium
```

> If the above environment is not ready when the app starts, a diagnostic result and resolution commands will be automatically displayed.

---

## 2. App Settings (cmd+,)

Configure the following items in the app's settings edit screen.

### 2.1 Short URL (Display Name)
- A simple name displayed at the top of the main screen
- Example: `Lecture Notes`, `Q&A Sheet`

### 2.2 Google Sheets URL
- The full URL of the Google Sheets document
- Format: `https://docs.google.com/spreadsheets/d/{SPREADSHEET_ID}/edit#gid=0`
- Copy and paste the URL directly from the browser address bar in Google Sheets

### 2.3 Current Row Number
- The row number where data will be entered next (1~1000)
- Automatically increments with each execution

### 2.4 Input Field Font Size
- Font size for Key/Value input fields (12~128pt)
- Default: 64pt

### 2.5 Apps Script Web App URL (Optional)
- Allows read/write access without OAuth
- When configured, this method takes priority
- Format: `https://script.google.com/macros/s/.../exec`

### 2.6 Google Sheets API Key (Optional)
- API Key issued from Google Cloud Console
- Used for read-only operations

### 2.7 Sheet Tab Name
- The name of the sheet tab where data will be entered
- Default: `Sheet1`

### 2.8 OAuth 2.0 Authentication (Optional, for Writing)
- Google Cloud Console > Credentials > OAuth 2.0 Client ID (Desktop type)
- Enter Client ID and Client Secret, then authenticate via the "Google Login" button

### 2.9 Hide App After Execution
- Option to automatically hide the app after execution completes
- Does not hide if unanswered questions are found

### 2.10 REST API Server Settings
A built-in REST API server that allows external clients (curl, scripts, other apps) to control app features via HTTP.

| Item | Description | Default |
|------|-------------|---------|
| API Server Enable | REST API server on/off | Disabled |
| Port | Server listening port number | 3013 |
| Allow External Access | Allow access from non-local IPs | Disallowed |
| Allowed CIDR | Allowed IP range (CIDR notation) | 127.0.0.1/32 |

**CIDR Examples:**
| CIDR | Allowed Range |
|------|---------------|
| `127.0.0.1/32` | Local only (default) |
| `192.168.0.0/24` | 192.168.0.1~254 |
| `0.0.0.0/0` | All IPs (use with caution) |

**Usage Examples:**
```bash
# Health check
curl http://localhost:3013/

# Upload data
curl -X POST http://localhost:3013/api/add-line \
  -H "Content-Type: application/json" \
  -d '{"key":"Question","value":"Answer"}'

# Query unanswered questions
curl http://localhost:3013/api/unanswered

# Check app status
curl http://localhost:3013/api/status

# Query next empty row
curl http://localhost:3013/api/next-row
```

> Full API documentation: See `api/openapi.yaml`

---

## 3. Configuration File Locations

All settings are stored as text files in the `fGoogleSheet/extModule/` directory.

| Filename | Purpose |
|----------|---------|
| `config_address.txt` | Google Sheets URL |
| `config_short_url.txt` | Display Short URL |
| `config_cell_key.txt` | Current Key data |
| `config_cell_val.txt` | Current Value data |
| `config_currentRow.txt` | Current row number |
| `config_font_size.txt` | Input field font size |
| `config_hide_after_execution.txt` | Hide after execution setting |
| `config_api_key.txt` | Google Sheets API Key |
| `config_sheet_tab.txt` | Sheet tab name |
| `config_oauth_client_id.txt` | OAuth Client ID |
| `config_oauth_client_secret.txt` | OAuth Client Secret |
| `config_refresh_token.txt` | OAuth Refresh Token |
| `config_webapp_url.txt` | Apps Script Web App URL |
| `config_rest_api_enabled.txt` | REST API server enabled |
| `config_rest_api_port.txt` | REST API server port |
| `config_rest_api_allow_external.txt` | External access allowed |
| `config_rest_api_cidr.txt` | Allowed CIDR range |

---

## 4. Keyboard Shortcuts

| Shortcut | Function |
|----------|----------|
| `cmd+r` | Save and execute (input to Google Sheets) |
| `cmd+k` | Clear input fields |
| `cmd+f` | Check unanswered questions |
| `cmd+enter` | Save and execute (hide) |
| `Tab` | Move focus (Key <-> Value) |
| `cmd+,` | Edit settings |

---

## 5. Troubleshooting

### Node.js Related
| Issue | Resolution |
|-------|------------|
| Node.js not installed | `brew install node` |
| Node.js version too low (below v18) | `brew upgrade node` |
| npm packages not installed | `cd fGoogleSheet/extModule && npm install` |
| Playwright Chromium not installed | `cd fGoogleSheet/extModule && npx playwright install chromium` |

### App Execution Related
| Issue | Resolution |
|-------|------------|
| Playwright server startup error | Kill existing processes: `pkill -f "node.*fLecNoteManager"` |
| Browser connection lost | App will attempt automatic reconnection, or restart the app |
| Google login required | Log in to your Google account in the browser window and proceed |
