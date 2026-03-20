# Gemini CLI Tools for fGoogleSheet

This directory contains specialized skills and workflows designed for the **Gemini CLI** to interact seamlessly with the running `fGoogleSheet` macOS application through its local REST API.

## Contents

- **skills/**: Contains the `fgooglesheet-api` skill, which provides the agent with knowledge about the fGoogleSheet REST API (including the `openapi.yaml` specifications) and instructions on how to use `curl` to interact with it.
- **workflows/**: Contains predefined `.md` workflows that instruct the agent on how to accomplish complex tasks, such as finding and answering unanswered questions.

## Installation Guide

### 1. Install the API Skill

The skill is provided as a packaged `.skill` file. You can install it into your local workspace (or globally for your user) using the Gemini CLI.

Run the following command in your terminal at the root of the `fGoogleSheet` project:

```bash
# Install the skill locally for this workspace
gemini skills install _public/agents/gemini/skills/fgooglesheet-api.skill --scope workspace
```

*Alternatively, to install it globally across all your projects, use `--scope user` instead.*

**Important:** After the installation is complete, you MUST manually execute the `/skills reload` command inside your interactive Gemini CLI session to enable the newly installed skill. 

### 2. Install the Workflows

Gemini CLI workflows are simple Markdown files placed in the `.agent/workflows/` directory.

To use the workflow, copy it into your local `.agent/workflows` folder:

```bash
mkdir -p .agent/workflows
cp _public/agents/gemini/workflows/answer_unanswered_questions.md .agent/workflows/
```

## Usage

Once installed and reloaded, simply open the Gemini CLI (`gemini`) and instruct the agent:

- *"Check the fGoogleSheet app status"*
- *"Find the unanswered questions using the fGoogleSheet API and answer them"*

The agent will automatically trigger the `fgooglesheet-api` skill and follow the defined workflows to execute your request against the local API at `http://localhost:3013`.
