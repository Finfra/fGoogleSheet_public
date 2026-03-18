# fGoogleSheet Claude Code Plugin

A Claude Code plugin that manages Google Sheets data via the fGoogleSheet REST API.
After installation, add lines, find unanswered questions, and check sheet status using slash commands in Claude Code.

---

## Plugin Structure

```
.claude-plugin/
└── plugin.json          # Plugin manifest
skills/
└── fgooglesheet/
    └── SKILL.md         # Google Sheets management skill
```

---

## Skills

### `fgooglesheet` — Google Sheets Data Management

Manage Google Sheets data (add key/value lines, find unanswered questions, check status) via the fGoogleSheet REST API.

**Usage:**
```
/fgooglesheet:fgooglesheet What is Docker? Container virtualization platform
/fgooglesheet:fgooglesheet --unanswered
/fgooglesheet:fgooglesheet --status
/fgooglesheet:fgooglesheet --next-row
```

**Features:**
- Add key/value data lines to Google Sheets
- Find unanswered questions (A column filled, B column empty)
- Check app status (execution state, authentication, sheet info)
- Find next available row
- Guides user to launch fGoogleSheet.app if server is not running

**Options:**

| Option            | Description                | Default                 |
| ----------------- | -------------------------- | ----------------------- |
| `--unanswered`    | Find unanswered questions  | -                       |
| `--status`        | Check app status           | -                       |
| `--next-row`      | Find next empty row        | -                       |
| `--server=<url>`  | Change server address      | `http://localhost:3013` |

**API Summary:**

| Endpoint             | Method | Description                        |
| -------------------- | ------ | ---------------------------------- |
| `GET /`              | GET    | Health check                       |
| `POST /api/add-line` | POST   | Add key/value data to Google Sheet |
| `GET /api/unanswered`| GET    | Find unanswered questions          |
| `GET /api/status`    | GET    | Check app status                   |
| `GET /api/next-row`  | GET    | Find next empty row                |

---

## Installation

### Option 1: Plugin Install (Recommended)

```bash
/plugin marketplace add nowage/fGoogleSheet
/plugin install fgooglesheet
```

### Option 2: Manual Copy

Copy the plugin directory to your project:

```bash
# From fGoogleSheet project root
cp -r _public/agents/claude/.claude-plugin .claude-plugin
cp -r _public/agents/claude/skills .claude/skills
```

### Option 3: Symbolic Link

```bash
ln -sf _public/agents/claude/skills/fgooglesheet .claude/skills/fgooglesheet
```

---

## Prerequisites

The fGoogleSheet REST API server must be running:

| Server             | How to Run                                           |
| ------------------ | ---------------------------------------------------- |
| macOS Native App   | Launch fGoogleSheet.app (enable REST API in Settings)|

> If the server is not running, the skill will prompt the user to launch fGoogleSheet.app.

---

## Related Extensions

| Extension                  | Location       | Description                                              |
| -------------------------- | -------------- | -------------------------------------------------------- |
| [MCP Server](../../mcp/)  | `_public/mcp/` | Google Sheets management via MCP protocol (Claude Desktop compatible) |

---

## License

MIT
