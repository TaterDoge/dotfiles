#!/usr/bin/env bash
# 新 Mac 一键恢复：Homebrew + dotfiles + Brewfile + mise + fish
# 用法: bash <(curl -fsSL https://raw.githubusercontent.com/TaterDoge/dotfiles/main/bootstrap.sh)
set -euo pipefail

DOTFILES="https://github.com/TaterDoge/dotfiles.git"
CONFIG="$HOME/.config"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# 1. Xcode CLT —— brew 的前置
xcode-select -p >/dev/null 2>&1 || {
  log "安装 Xcode Command Line Tools（弹窗后请点确认，装完重跑本脚本）"
  xcode-select --install || true
  exit 1
}

# 2. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  log "安装 Homebrew"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# 3. dotfiles → ~/.config（$CONFIG 已存在也能跑：init + fetch + 强制 checkout）
if [ -d "$CONFIG/.git" ]; then
  log "更新 dotfiles"
  git -C "$CONFIG" fetch --depth=1 origin main
  git -C "$CONFIG" reset --hard origin/main
else
  log "拉取 dotfiles 到 $CONFIG"
  mkdir -p "$CONFIG"
  git -C "$CONFIG" init -q
  git -C "$CONFIG" remote add origin "$DOTFILES"
  git -C "$CONFIG" fetch --depth=1 origin main
  git -C "$CONFIG" checkout -f -t origin/main
fi

# 4. brew bundle（Brewfile 在 $CONFIG 下，cd 进去即可自动发现）
log "brew bundle"
(cd "$CONFIG" && brew bundle)

# 5. mise 工具链（读 ~/.config/mise/config.toml，上一步已带下来）
command -v mise >/dev/null 2>&1 && { log "mise install"; mise install; }

# 6. fish 设为默认 shell
FISH="$(command -v fish || echo /opt/homebrew/bin/fish)"
if [ -x "$FISH" ] && [ "$SHELL" != "$FISH" ]; then
  grep -qxF "$FISH" /etc/shells || echo "$FISH" | sudo tee -a /etc/shells >/dev/null
  chsh -s "$FISH" && log "默认 shell 已切到 fish"
fi

# 7. 手动收尾（脚本不碰密钥）
cat <<'EOF'

==> 还需要手动做的：
  1. cp ~/.config/fish/.env.example ~/.config/fish/.env  然后填 LLM_API_KEY / GITHUB_TOKEN / TAVILY_API_KEY
  2. 恢复 ~/.ssh（id_ed25519 + config）和 ~/.gitconfig —— 不在 dotfiles 里
  3. gh auth login  （或 export GITHUB_TOKEN）
  4. 打开 aerospace / karabiner / raycast / sketchybar，授予辅助功能与录屏权限
EOF
