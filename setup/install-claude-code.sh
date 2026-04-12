#!/bin/bash
# =============================================================================
# install-claude-code.sh
# Installeert Claude Code op een Ventoy/Xubuntu live USB sessie met persistence
# =============================================================================

set -e

echo "============================================"
echo "  Claude Code USB Installer"
echo "  DevaClaudeCodeOpVentoy"
echo "============================================"
echo ""

# --- Controleer of we op Linux draaien ---
if [[ "$(uname)" != "Linux" ]]; then
    echo "FOUT: Dit script werkt alleen op Linux."
    exit 1
fi

# --- Configuratie ---
NVM_DIR="$HOME/.nvm"
NODE_VERSION="22"
CLAUDE_CONFIG_DIR="$HOME/.claude"
PROJECTS_DIR="$HOME/projecten"

# --- Stap 1: nvm installeren (Node Version Manager) ---
echo "[1/5] nvm installeren..."
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    echo "nvm geinstalleerd."
else
    echo "nvm al aanwezig, overgeslagen."
fi

# Laad nvm in huidige shell
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# --- Stap 2: Node.js installeren ---
echo ""
echo "[2/5] Node.js $NODE_VERSION LTS installeren..."
nvm install "$NODE_VERSION"
nvm use "$NODE_VERSION"
nvm alias default "$NODE_VERSION"
echo "Node.js versie: $(node --version)"
echo "npm versie: $(npm --version)"

# --- Stap 3: Claude Code installeren ---
echo ""
echo "[3/5] Claude Code installeren via npm..."
npm install -g @anthropic-ai/claude-code
echo "Claude Code versie: $(claude --version 2>/dev/null || echo 'installatie controleren')"

# --- Stap 4: Mappen aanmaken ---
echo ""
echo "[4/5] Projectmappen aanmaken..."
mkdir -p "$CLAUDE_CONFIG_DIR"
mkdir -p "$PROJECTS_DIR"
echo "Aangemaakt: $CLAUDE_CONFIG_DIR"
echo "Aangemaakt: $PROJECTS_DIR"

# --- Stap 5: Shell integratie ---
echo ""
echo "[5/5] Shell integratie instellen..."

BASHRC="$HOME/.bashrc"
MARKER="# DevaClaudeCodeOpVentoy shell integratie"

if ! grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
    cat >> "$BASHRC" << 'SHELLCONFIG'

# DevaClaudeCodeOpVentoy shell integratie
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Laad API key als .env bestand bestaat
if [ -f "$HOME/.claude/.env" ]; then
    set -a
    # shellcheck source=/dev/null
    source "$HOME/.claude/.env"
    set +a
fi

# Handige aliases voor Claude Code
alias cc='claude'
alias cchat='claude --no-tools'

SHELLCONFIG
    echo "Shell integratie toegevoegd aan $BASHRC"
else
    echo "Shell integratie al aanwezig, overgeslagen."
fi

# --- Klaar ---
echo ""
echo "============================================"
echo "  Installatie voltooid!"
echo "============================================"
echo ""
echo "Volgende stappen:"
echo "  1. Stel je API key in:"
echo "     cp ~/DevaClaudeCodeOpVentoy/config/.env.template ~/.claude/.env"
echo "     nano ~/.claude/.env"
echo ""
echo "  2. Herstart je terminal of voer uit:"
echo "     source ~/.bashrc"
echo ""
echo "  3. Start Claude Code:"
echo "     cd ~/projecten"
echo "     claude"
echo ""
