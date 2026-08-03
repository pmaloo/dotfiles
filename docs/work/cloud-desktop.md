# Cloud Desktop Setup

**Dotfiles:** https://github.com/pmaloo/dotfiles

## Bootstrap

After provisioning a new Cloud Desktop, SSH in and run:

```bash
mwinit -o
toolbox install toolbox
curl -sL https://raw.githubusercontent.com/pmaloo/dotfiles/master/scripts/bootstrap-cloud-desktop.sh | bash
```

That single script handles: dotfiles, oh-my-zsh, plugins, p10k, fzf, Node, toolbox registries, tools, MCP servers, Brazil config, SSH key, systemd services, crons, and startpage.

## Manual Steps After Script

1. **`mwinit -o`** — registers the new SSH key for bastion/EMR access
2. **DNS alias** — update at internal DNS management tool
   - Alias: `<your-alias>-dev.<internal-dns-zone>`
   - Points to: `<new hostname>`
3. **`sudo reboot`** — apply kernel update
4. **Update laptop SSH config** — point `clouddesk` HostName to new hostname

## Migration (from existing desktop)

```bash
# On OLD desktop:
tar czf /tmp/migrate.tar.gz .aim .claude .meshclaw .aws

# SCP to new desktop:
scp /tmp/migrate.tar.gz <new-host>:/home/$USER/

# On NEW desktop (before running bootstrap):
tar xzf ~/migrate.tar.gz -C /local/home/$USER/
rm ~/migrate.tar.gz
```

Then run the bootstrap script — it'll skip what's already present.

## Tools

| Tool | Purpose |
|---|---|
| claude-code | Claude Code CLI |
| brazilcli | Brazil build system |
| aim | AIM agent/MCP manager |
| meshclaw | AI agent gateway |
| tunnels | Port tunnel service |
| bemol | LSP config for Brazil workspaces |
| gordian-knot | Version set conflict resolver |
| fzf | Fuzzy finder (Ctrl+R, Ctrl+T) |
| BrazilCDN | Faster package downloads |

## MCP Servers (Claude Code)

All registered in `~/.claude.json` (user scope).

| Capability | Server | Auth |
|---|---|---|
| Slack (read/search/post/DM) | `slack-enterprise-mcp` | OAuth, re-auth ~daily |
| Email + Calendar + Files (M365) | `grasp-mcp` | Midway SSO (auto) |
| Meetings (schedule/rooms) | `amazon-meetings-mcp` | Federate/Midway (auto) |
| Chorus docs | `local-chorus-mcp` | Midway (auto) |
| Internal search/code/wiki | `builder-mcp` | Midway (auto) |

### AL2 / GLIBC Constraint

Cloud Desktops run Amazon Linux 2 (GLIBC ~2.26). **Node 20+ servers crash.** Only Rust/native servers work:

| Dead (node 20+) | Working (Rust/native) |
|---|---|
| `slack-mcp`, `aws-outlook-mcp`, `andes-mcp` | `slack-enterprise-mcp`, `grasp-mcp`, `amazon-meetings-mcp` |

### Slack Re-auth (daily)

1. `slack-enterprise-mcp auth`
2. Open the authorize URL in browser, approve
3. Browser redirects to `localhost:<port>/callback?...` → "can't be reached" (expected)
4. Copy the full URL, deliver from cloud desktop: `curl "http://localhost:<port>/callback?code=...&state=..."`
5. `/mcp` → reconnect in Claude Code

### Maintenance

| Task | When | Action |
|---|---|---|
| Re-auth Slack | ~daily + after reboot | Slack auth procedure above |
| Refresh Midway | ~daily | `mwinit -o` (GRASP + Meetings depend on it) |
| Update a server | occasionally | `mcp-registry install <name>` or `aim mcp install <name>` |

## What's NOT in Dotfiles (desktop-specific)

| Component | Location |
|---|---|
| Toolbox tools + registries | `~/.toolbox/` |
| AIM plugins + agents | `~/.aim/` |
| Claude Code config + memory | `~/.claude/` |
| MeshClaw state | `~/.meshclaw/` |
| AWS credentials | `~/.aws/` |
| Systemd services | `/etc/systemd/system/` |
| Cron jobs | `crontab -l` |
