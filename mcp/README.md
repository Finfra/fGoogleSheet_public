# fgooglesheet-mcp

MCP (Model Context Protocol) server for **fGoogleSheet** — a macOS Google Sheets management application.

This server bridges AI assistants (Claude Code, Claude Desktop, etc.) with fGoogleSheet's REST API, enabling direct Google Sheets operations through natural language.

## Architecture

```
AI Assistant (Claude)
       │
       │ MCP Protocol (stdio)
       ▼
┌─────────────────────┐
│  fgooglesheet-mcp   │
│  (MCP Server)       │
└─────────┬───────────┘
          │ HTTP REST API
          ▼
┌─────────────────────┐
│  fGoogleSheet App   │
│  (port 3013)        │
└─────────┬───────────┘
          │ Google Sheets API v4
          ▼
┌─────────────────────┐
│  Google Sheets      │
└─────────────────────┘
```

## Installation

### Option 1: npm global install

```bash
npm install -g fgooglesheet-mcp
```

### Option 2: npx (no install)

```bash
npx fgooglesheet-mcp
```

### Option 3: From source

```bash
git clone https://github.com/nowage/fGoogleSheet.git
cd fGoogleSheet/mcp
npm install
node index.js
```

## Configuration

### Claude Code

Add to `~/.claude/settings.json`:

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

### Claude Desktop

Add to Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json`):

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

### Remote Server

To connect to a remote fGoogleSheet instance:

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

Or use the environment variable:

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

### Server URL Resolution Order

1. CLI argument: `--server=<url>`
2. Environment variable: `FGOOGLESHEET_SERVER`
3. Default: `http://localhost:3013`

## Tools

### health_check

Check if the fGoogleSheet REST API server is running.

```
Parameters: none
```

**Example prompt**: "Is fGoogleSheet running?"

### add_line

Add a key/value pair to Google Sheets.

```
Parameters:
  key   (string, required) - Column A content
  value (string, optional) - Column B content (default: "")
```

**Example prompt**: "Add 'What is REST API?' to Google Sheets"

### find_unanswered

Find rows where column A has content but column B is empty.

```
Parameters:
  start_row (number, optional) - Start row (default: 2)
```

**Example prompt**: "Show me unanswered questions in the spreadsheet"

### get_status

Get current application status and configuration.

```
Parameters: none
```

**Example prompt**: "What's the current status of fGoogleSheet?"

### find_next_row

Find the next empty row available for data entry.

```
Parameters:
  start_row (number, optional) - Start row (default: 2)
```

**Example prompt**: "What's the next available row?"

## Testing with MCP Inspector

```bash
npx @modelcontextprotocol/inspector npx fgooglesheet-mcp
```

This opens a web UI where you can interactively test each tool.

## Prerequisites

- **fGoogleSheet.app** must be running with REST API enabled
- REST API server listens on port 3013 by default
- Node.js >= 18.0.0

## License

MIT
