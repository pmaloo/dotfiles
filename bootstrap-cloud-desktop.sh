#!/bin/bash
set -e

echo "=== Cloud Desktop Bootstrap ==="
echo "Run this after: mwinit -o && toolbox install toolbox"
echo ""

# === 1. Dotfiles ===
if [ ! -d ~/dotfiles ]; then
  git clone --recursive https://github.com/pmaloo/dotfiles.git ~/dotfiles
fi
cd ~/dotfiles && ./dotbot/bin/dotbot -d . -c install.conf.yaml

# === 2. Oh-My-Zsh + plugins ===
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ] || \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
[ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ] || \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# === 3. fzf ===
if [ ! -d ~/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all --no-bash --no-fish
fi

# === 4. Node.js ===
if ! command -v node &>/dev/null; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm" && . "$NVM_DIR/nvm.sh"
  nvm install 22
  ln -sf ~/.nvm/versions/node/v22.*/bin/node ~/.toolbox/bin/node
  ln -sf ~/.nvm/versions/node/v22.*/bin/npx ~/.toolbox/bin/npx
  ln -sf ~/.nvm/versions/node/v22.*/bin/npm ~/.toolbox/bin/npm
fi

# === 5. Toolbox registries ===
export PATH="$HOME/.toolbox/bin:$PATH"
toolbox registry add s3://buildertoolbox-meshclaw-us-west-2/tools.json 2>/dev/null || true
toolbox registry add s3://tunnels-toolbox-prod/tools.json 2>/dev/null || true
toolbox registry add s3://buildertoolbox-awsoutlook-mcp-us-west-2/tools.json 2>/dev/null || true
toolbox registry add s3://buildertoolbox-registry-arcc-cli-prod-us-west-2/tools.json 2>/dev/null || true
toolbox registry add s3://buildertoolbox-registry-grasp-tools-us-west-2/tools.json 2>/dev/null || true
toolbox registry add s3://buildertoolbox-registry-pippin-mcp-server-us-west-2/tools.json 2>/dev/null || true

# === 6. Toolbox tools ===
toolbox install claude-code brazilcli axe aim meshclaw tunnels bemol gordian-knot 2>/dev/null
toolbox install grasp-mcp pippin-mcp-server 2>/dev/null
aim mcp install local-chorus-mcp 2>/dev/null || true
aim mcp install spec-studio-mcp 2>/dev/null || true

# === 7. axe init (background — takes ~20 min) ===
echo "Starting axe init builder-tools in background..."
yes | axe init builder-tools &>/dev/null &

# === 8. Brazil config ===
brazil prefs --global --key packagecache.useBrazilCdn --value true 2>/dev/null
brazil prefs --global --key packagecache.disableEdgeCache --value true 2>/dev/null
sudo mkdir -p -m 755 /workplace/$USER
sudo chown -R ${USER}:amazon /workplace/$USER
ln -sf /workplace/$USER ~/workplace

# === 9. SSH key ===
if [ ! -f ~/.ssh/id_ecdsa ]; then
  ssh-keygen -t ecdsa -f ~/.ssh/id_ecdsa -N ''
  echo ">>> Run 'mwinit -o' to register the new SSH key"
fi

# === 10. Systemd services ===
sudo tee /etc/systemd/system/meshclaw.service > /dev/null << 'EOF'
[Unit]
Description=MeshClaw AI Agent Gateway
After=network-online.target
[Service]
Type=simple
User=pmaloo
ExecStart=/home/pmaloo/.toolbox/bin/meshclaw gateway
Restart=always
RestartSec=10
WorkingDirectory=/home/pmaloo
Environment=HOME=/home/pmaloo
Environment=PATH=/home/pmaloo/.toolbox/bin:/usr/local/bin:/usr/bin
[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/meshclaw-tunnel.service > /dev/null << 'EOF'
[Unit]
Description=MeshClaw Tunnel
After=meshclaw.service
BindsTo=meshclaw.service
[Service]
Type=simple
User=pmaloo
ExecStart=/home/pmaloo/.toolbox/bin/tunnel create 7777 --name meshclaw
Restart=always
RestartSec=5
Environment=HOME=/home/pmaloo
[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/startpage.service > /dev/null << 'EOF'
[Unit]
Description=Personal Startpage Server
After=network.target
[Service]
Type=simple
User=pmaloo
WorkingDirectory=/home/pmaloo/startpage
ExecStart=/usr/bin/python3 -m http.server 8888 --bind 127.0.0.1
Restart=always
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now meshclaw meshclaw-tunnel startpage

# === 11. Cron jobs ===
(crontab -l 2>/dev/null | grep -v refresh-aea | grep -v update-stats; \
  echo '*/90 * * * * /usr/bin/mwinit --refresh-aea >/dev/null 2>&1'; \
  echo '* * * * * /home/pmaloo/startpage/update-stats.sh') | crontab -

# === 12. Startpage ===
mkdir -p ~/startpage
cat > ~/startpage/update-stats.sh << 'STATS'
#!/bin/bash
cat > /home/pmaloo/startpage/stats.json <<SJSON
{
  "hostname": "$(hostname)",
  "uptime": "$(uptime -p 2>/dev/null || uptime | sed 's/.*up //' | sed 's/,.*//')",
  "disk_root": "$(df -h / | awk 'NR==2 {print $3"/"$2" ("$5")"}')",
  "disk_local": "$(df -h /local 2>/dev/null | awk 'NR==2 {print $3"/"$2" ("$5")"}' || echo 'N/A')",
  "memory": "$(free -h | awk '/Mem:/ {print $3"/"$2}')",
  "load": "$(cat /proc/loadavg | awk '{print $1, $2, $3}')",
  "meshclaw": "$(systemctl is-active meshclaw 2>/dev/null || echo 'unknown')",
  "tunnel": "$(systemctl is-active meshclaw-tunnel 2>/dev/null || echo 'unknown')",
  "updated_at": "$(date +%H:%M)"
}
SJSON
STATS
chmod +x ~/startpage/update-stats.sh

# === 13. .local-env ===
if [ ! -f ~/.local-env ]; then
  echo "export CLOUD_DESKTOP=\"$(hostname)\"" > ~/.local-env
  echo ">>> Created ~/.local-env with hostname"
fi

echo ""
echo "=== DONE ==="
echo ""
echo "Remaining manual steps:"
echo "  1. mwinit -o  (registers SSH key for bastion/EMR)"
echo "  2. Update DNS alias: https://dns-manage-web.corp.proxy.amazon.com/cgi-bin/cname-editor.cgi"
echo "  3. sudo reboot (kernel update)"
echo "  4. Copy startpage/index.html from old desktop or Chorus doc"
