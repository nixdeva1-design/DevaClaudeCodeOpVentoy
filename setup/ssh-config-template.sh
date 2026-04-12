#!/bin/bash
# =============================================================================
# ssh-config-template.sh
# Stelt SSH toegang in vanuit de USB omgeving naar je systemen
# Pas de variabelen onderaan aan naar jouw situatie
# =============================================================================

set -e

echo "============================================"
echo "  SSH Configuratie Setup"
echo "  DevaClaudeCodeOpVentoy"
echo "============================================"
echo ""

SSH_DIR="$HOME/.ssh"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# --- Genereer USB-specifieke SSH sleutel ---
KEY_FILE="$SSH_DIR/id_ed25519_usb"

if [ ! -f "$KEY_FILE" ]; then
    echo "[1/3] SSH sleutel aanmaken..."
    ssh-keygen -t ed25519 -C "claude-usb-$(hostname)-$(date +%Y%m%d)" -f "$KEY_FILE" -N ""
    echo "Sleutel aangemaakt: $KEY_FILE"
else
    echo "[1/3] SSH sleutel bestaat al: $KEY_FILE (overgeslagen)"
fi

echo ""
echo "Jouw publieke sleutel (voeg toe aan servers):"
echo "---"
cat "${KEY_FILE}.pub"
echo "---"

# --- SSH config aanmaken ---
echo ""
echo "[2/3] SSH config aanmaken..."
SSH_CONFIG="$SSH_DIR/config"

# Pas deze hosts aan naar jouw systemen:
cat >> "$SSH_CONFIG" << 'SSHCONF'

# ==============================================
# DevaClaudeCodeOpVentoy SSH configuratie
# Pas aan naar jouw systemen
# ==============================================

# Voorbeeld: thuisserver
# Host thuis
#     HostName 192.168.1.100
#     User jouwgebruikersnaam
#     IdentityFile ~/.ssh/id_ed25519_usb
#     Port 22

# Voorbeeld: VPS of cloud server
# Host mijnvps
#     HostName jouw-server.example.com
#     User root
#     IdentityFile ~/.ssh/id_ed25519_usb

# Voorbeeld: Raspberry Pi
# Host pi
#     HostName raspberrypi.local
#     User pi
#     IdentityFile ~/.ssh/id_ed25519_usb

# Globale instellingen voor alle hosts
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    IdentityFile ~/.ssh/id_ed25519_usb
    AddKeysToAgent yes

SSHCONF

chmod 600 "$SSH_CONFIG"
echo "SSH config aangemaakt: $SSH_CONFIG"

# --- Aanwijzingen ---
echo ""
echo "[3/3] Aanwijzingen voor het koppelen aan je systemen:"
echo ""
echo "Kopieer je publieke sleutel naar een server:"
echo "  ssh-copy-id -i ~/.ssh/id_ed25519_usb.pub gebruiker@server"
echo ""
echo "Of handmatig:"
echo "  cat ~/.ssh/id_ed25519_usb.pub"
echo "  # Plak de inhoud in ~/.ssh/authorized_keys op de server"
echo ""
echo "Test verbinding:"
echo "  ssh thuis  (als je 'thuis' hebt geconfigureerd in ~/.ssh/config)"
echo ""
echo "Claude Code kan dan bestanden lezen/schrijven op je servers:"
echo "  claude  # start in een projectmap, Claude heeft SSH toegang"
echo ""
echo "============================================"
echo "  SSH configuratie klaar!"
echo "============================================"
