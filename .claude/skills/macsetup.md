---
name: macsetup
description: Understand and manage the full Mac + Cloud Desktop setup — dotfiles, LaunchAgents, scripts, MCP servers, Homebrew, shell config. Use when the user asks about their computer setup, wants to add/change automation, install tools, or troubleshoot their environment.
model: sonnet
---

# Mac Setup Knowledge Base

You are helping the user manage their Mac development environment. Before answering, read the relevant files below to get current state — don't rely on memory alone.

## Source of Truth Locations

### Dotfiles (`~/dotfiles/` — git repo, github.com/pmaloo/dotfiles)

**Personal (portable, public-safe):**
- `Brewfile` — personal Homebrew formulae, casks, VS Code extensions
- `aliases` (→ `~/.aliases`) — portable shell aliases (eza, git, navigation)
- `functions` (→ `~/.functions`) — portable helper functions
- `zshrc`, `bashrc`, `vimrc`, `tmux.conf`, `p10k.zsh` — shell/editor configs
- `gitconfig` (→ `~/.gitconfig`) — portable git settings + `[include] path = ~/.gitconfig-work`
- `gitignore` (→ `~/.gitignore`) — global ignores

**Work (Amazon-specific, remove/unlink when leaving):**
- `work` (→ `~/.work`) — Amazon aliases, functions (`mw`, `bbq`, `cdport`), paths
- `gitconfig-work` (→ `~/.gitconfig-work`) — Amazon email + CodeCommit credential
- `Brewfile.work` — Amazon-only packages (`amzn/amzn` tap, `ninja-dev-sync`, Amazon Q)
- `scripts/bootstrap-cloud-desktop.sh` — Cloud Desktop provisioning script

**Dotbot config:** `install.conf.yaml` — defines all symlinks, run with `./install`

### Automation (`~/Library/LaunchAgents/`)
- `com.pmaloo.mwinit-auto.plist` — headless Midway cert refresh every 15 min
- `com.pmaloo.mwinit-refresh.plist` — AEA posture cookie refresh every 55 min
- `com.pmaloo.midway-sync.plist` — sync Midway cookie to Cloud Desktops on change
- `com.pmaloo.clouddesk-tunnel.plist` — persistent SSH tunnel to Cloud Desktop
- `com.cloudmesh.tunnel.plist` — MeshClaw tunnel
- `com.pmaloo.brazil-package-cache.plist` — Java daemon for mcp-registry
- `homebrew.mxcl.sleepwatcher` — runs `~/.wakeup` on lid-open

### Scripts (`~/.local/bin/`)
- `mwinit-auto.sh` — cert expiry check → PIN from Keychain → mwinit → sync cookie
- `brazil-package-cache-launcher.sh` — daemon with ENVROOT
- `brazil-package-cache` — wrapper for rust CLI

### Wake Hook
- `~/.wakeup` (→ `dotfiles/wakeup`) — sleepwatcher trigger, calls `mwinit-auto.sh` after 3s network delay

### MCP Servers (`~/.claude.json` → mcpServers)
- `builder-mcp` — Amazon internal systems (code, wiki, search, ticketing)
- `slack-enterprise-mcp` — Slack read/write
- `grasp-mcp` — M365 email/calendar/files
- `amazon-meetings-mcp` — calendar management
- `local-chorus-mcp` — Chorus docs read/write

### Setup Docs (`~/dotfiles/docs/` — source of truth, committed to git)
- `mac.md` — personal Mac setup (dotfiles, brew, shell, tools) — fully public-safe
- `work/cloud-desktop.md` — Cloud Desktop bootstrap, MCP auth, migration
- `work/midway.md` — Midway automation (mwinit, sleepwatcher, cookie sync)
- `work/meshclaw.md` — MeshClaw gateway + tunnel (both platforms)

### Chorus Mirror
Internal mirror with real hostnames/IDs (no placeholders). Sync after significant doc changes using `local-chorus-mcp` tools. Doc IDs are in the local-only version of this skill at `~/.claude/skills/macsetup.md`.

### SSH
- `~/.ssh/config` — aliases: `clouddesk`, `devdesk`
- `~/.ssh/id_ecdsa-cert.pub` — Midway cert (expires, refreshed by mwinit-auto)

### Key Environment
- `ENVROOT` — dynamically resolved to latest brazilcli version in `~/.toolbox/tools/brazilcli/`
- `AWS_PROFILE=notebook`
- Keychain stores FIDO2 PIN for mwinit automation

## NEVER Commit to Public Repo

The dotfiles repo is **public on GitHub**. NEVER commit any of the following:

- SSH config (`~/.ssh/config`) — contains internal hostnames
- AWS credentials (`~/.aws/credentials`, `~/.aws/config`) — account IDs, role ARNs
- Midway cookies (`~/.midway/`)
- Keychain secrets (FIDO2 PIN, tokens)
- Internal hostnames, IP addresses, or DNS aliases
- API keys, tokens, or connection strings
- `.env` files or anything with `SECRET`, `TOKEN`, `PASSWORD`, `KEY` in the name
- Chorus doc IDs, Slack user/team IDs, or internal folder IDs

If a doc or script references internal infra, use placeholders: `<your-cloud-desktop-hostname>`, `<your-alias>`.

**Before every commit:** scan staged files for internal hostnames (`grep -rE 'amazon\.com|a2z\.com|corp\.|dev-dsk' <files>`). If found, replace with placeholders or move to Chorus-only.

## How to Respond

1. **Read first** — always read the relevant file(s) before answering to get current state
2. **Edit in place** — prefer modifying existing files over creating new ones
3. **Keep Brewfile updated** — if you install anything via brew, add it to `~/dotfiles/Brewfile`
4. **Update docs** — if you make significant changes, update the relevant markdown in `~/dotfiles/docs/`
5. **Sync to Chorus** — after updating a doc, sync to the Chorus mirror (use local skill at `~/.claude/skills/macsetup.md` for doc IDs)
6. **Commit dotfiles** — after any change to `~/dotfiles/`, stage the changed files and commit with a descriptive message, then push to origin
7. **Symlinks** — `~/.work`, `~/.aliases`, `~/.wakeup`, etc. are symlinks to `~/dotfiles/` — edit the real file at `~/dotfiles/<name>`
8. **LaunchAgents** — after editing a plist, reload with `launchctl unload/load`
9. **Test changes** — verify scripts work before committing
10. **Security scan** — before pushing, run `grep -rE 'amazon\.com|a2z\.com|corp\.|dev-dsk' <staged files>` to catch leaks

## Common Tasks

- **Add personal tool**: `brew install <pkg>`, add to `~/dotfiles/Brewfile`, commit
- **Add work tool**: `brew install <pkg>`, add to `~/dotfiles/Brewfile.work`, commit
- **Add new automation**: create script in `~/.local/bin/`, create plist in `~/Library/LaunchAgents/`, load it, update `docs/work/` doc
- **Debug automation**: check `/tmp/<agent-name>.log` and `.err` files, `launchctl list | grep <name>`
- **Sync to Cloud Desktop**: cookie sync is automatic via midway-sync LaunchAgent; for other files use `scp clouddesk:~/path`
- **Leaving Amazon**: unlink `~/.work`, `~/.gitconfig-work`; delete `Brewfile.work`, `scripts/`, `docs/work/`
