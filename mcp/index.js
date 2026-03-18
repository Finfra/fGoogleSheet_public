#!/usr/bin/env node

/*
 Usage:
   node index.js [--server=<url>]

 Arguments:
   --server=<url> : (optional) fGoogleSheet REST API server URL (default: http://localhost:3013)

 Environment Variables:
   FGOOGLESHEET_SERVER : REST API server URL (overridden by --server flag)

 Server URL Resolution Order:
   1. CLI argument: --server=<url>
   2. Environment variable: FGOOGLESHEET_SERVER
   3. Default: http://localhost:3013
*/

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

// --- Server URL Resolution ---
function resolveServerUrl() {
  // 1. CLI argument
  const serverArg = process.argv.find((arg) => arg.startsWith("--server="));
  if (serverArg) {
    return serverArg.split("=").slice(1).join("=").replace(/\/+$/, "");
  }

  // 2. Environment variable
  if (process.env.FGOOGLESHEET_SERVER) {
    return process.env.FGOOGLESHEET_SERVER.replace(/\/+$/, "");
  }

  // 3. Default
  return "http://localhost:3013";
}

const SERVER_URL = resolveServerUrl();

// --- HTTP Helper ---
async function apiRequest(method, path, body = null) {
  const url = `${SERVER_URL}${path}`;
  const options = {
    method,
    headers: { "Content-Type": "application/json" },
  };

  if (body) {
    options.body = JSON.stringify(body);
  }

  try {
    const response = await fetch(url, options);
    const text = await response.text();

    let data;
    try {
      data = JSON.parse(text);
    } catch {
      data = text;
    }

    if (!response.ok) {
      return {
        isError: true,
        content: [
          {
            type: "text",
            text: `HTTP ${response.status}: ${typeof data === "string" ? data : JSON.stringify(data, null, 2)}`,
          },
        ],
      };
    }

    return {
      content: [
        {
          type: "text",
          text: typeof data === "string" ? data : JSON.stringify(data, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      isError: true,
      content: [
        {
          type: "text",
          text: `Connection error: ${error.message}\nServer URL: ${url}\nMake sure fGoogleSheet app is running with REST API enabled.`,
        },
      ],
    };
  }
}

// --- MCP Server Setup ---
const server = new McpServer({
  name: "fgooglesheet-mcp",
  version: "1.0.0",
});

// Tool 1: health_check
server.tool(
  "health_check",
  "Check if fGoogleSheet REST API server is running and responsive",
  {},
  async () => {
    return await apiRequest("GET", "/");
  }
);

// Tool 2: add_line
server.tool(
  "add_line",
  "Add a key/value pair to Google Sheets. Uploads data to the next available row.",
  {
    key: z.string().describe("The key (column A) to write to Google Sheets"),
    value: z
      .string()
      .optional()
      .default("")
      .describe("The value (column B) to write to Google Sheets"),
  },
  async ({ key, value }) => {
    return await apiRequest("POST", "/api/add-line", { key, value });
  }
);

// Tool 3: find_unanswered
server.tool(
  "find_unanswered",
  "Find unanswered questions in Google Sheets. Returns rows where column A has content but column B is empty.",
  {
    start_row: z
      .number()
      .optional()
      .default(2)
      .describe("Row number to start searching from (default: 2, skipping header)"),
  },
  async ({ start_row }) => {
    return await apiRequest("GET", `/api/unanswered?startRow=${start_row}`);
  }
);

// Tool 4: get_status
server.tool(
  "get_status",
  "Get current status of fGoogleSheet application including configuration and connection state",
  {},
  async () => {
    return await apiRequest("GET", "/api/status");
  }
);

// Tool 5: find_next_row
server.tool(
  "find_next_row",
  "Find the next empty row in Google Sheets for data entry",
  {
    start_row: z
      .number()
      .optional()
      .default(2)
      .describe("Row number to start searching from (default: 2, skipping header)"),
  },
  async ({ start_row }) => {
    return await apiRequest("GET", `/api/next-row?startRow=${start_row}`);
  }
);

// --- Start Server ---
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error(`fgooglesheet-mcp server started (target: ${SERVER_URL})`);
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
