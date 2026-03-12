# Future: Multi-LLM Support

## Goal

Let users choose which AI coding tool to install on their dev VM. One tool at a time — pick during setup, and the bootstrap process installs and configures it.

## Supported Tools

### Claude Code
- **Install**: `npm install -g @anthropic-ai/claude-code`
- **Env vars**: `ANTHROPIC_API_KEY`
- **Dependencies**: Node.js 18+
- **Notes**: Current default. Runs as a CLI in the terminal.

### Codex CLI
- **Install**: `npm install -g @openai/codex`
- **Env vars**: `OPENAI_API_KEY`
- **Dependencies**: Node.js 22+
- **Notes**: OpenAI's CLI agent. Requires a newer Node version than Claude Code.

### OpenCode
- **Install**: `curl -fsSL https://opencode.ai/install | bash` (or `go install` from source)
- **Env vars**: Varies by provider (supports Anthropic, OpenAI, and others via config)
- **Dependencies**: None (single binary)
- **Notes**: TUI-based. Supports multiple LLM backends through its own config file.

### Pi Agent
- **Install**: `npm install -g pi-agent`
- **Env vars**: Depends on configured LLM provider
- **Dependencies**: Node.js 18+
- **Notes**: Terminal-based AI coding agent.

## Integration Point

### Before Go CLI
If implemented while still using Ansible, add a variable (e.g., `ai_tool: claude-code`) to the Ansible playbook. Use it to conditionally run the correct installation tasks.

### With Go CLI
This becomes a prompt in the `init` wizard:
```
Which AI coding tool would you like to install?
  1. Claude Code (Anthropic)
  2. Codex CLI (OpenAI)
  3. OpenCode
  4. Pi Agent
```

The selection is stored in `cloud-init-agent.yaml` and the `deploy` command runs the appropriate install steps over SSH.

## Per-Tool Bootstrap Steps

Each tool needs:
1. Install runtime dependencies (Node.js, etc.) if not already present
2. Install the tool itself (npm global install, curl script, etc.)
3. Set environment variables (API keys) — prompt the user or read from config
4. Verify the installation works (`<tool> --version` or equivalent)
