#!/bin/bash
# =============================================================================
# ventoy-persistence.sh
# Maakt een Ventoy persistence bestand aan voor Xubuntu 25
# Voer dit uit op een werkende Linux machine met de USB stick aangesloten
# =============================================================================

set -e

echo "============================================"
echo "  Ventoy Persistence Setup"
echo "  DevaClaudeCodeOpVentoy"
echo "============================================"
echo ""

# --- Configuratie ---
# Pas deze waarden aan aan jouw situatie:
ISO_NAME="xubuntu-25.04-desktop-amd64.iso"
PERSISTENCE_SIZE_GB=50      # Grootte persistence partitie in GB
VENTOY_MOUNT="/media/$USER/Ventoy"  # Ventoy partitie mountpoint

# --- Controleer root rechten ---
if [[ $EUID -ne 0 ]]; then
    echo "Dit script moet als root (sudo) worden uitgevoerd."
    echo "Gebruik: sudo bash setup/ventoy-persistence.sh"
    exit 1
fi

# --- Controleer of Ventoy partitie gemount is ---
if [ ! -d "$VENTOY_MOUNT" ]; then
    echo "FOUT: Ventoy partitie niet gevonden op $VENTOY_MOUNT"
    echo "Zorg dat de USB stick aangesloten en gemount is."
    echo ""
    echo "Beschikbare mounts:"
    df -h | grep -E "media|mnt"
    exit 1
fi

# --- Bestandsnaam voor persistence ---
PERSISTENCE_FILE="${ISO_NAME%.iso}.persistence"
PERSISTENCE_PATH="$VENTOY_MOUNT/$PERSISTENCE_FILE"
PERSISTENCE_BYTES=$((PERSISTENCE_SIZE_GB * 1024 * 1024 * 1024))

echo "ISO naam:          $ISO_NAME"
echo "Persistence bestand: $PERSISTENCE_FILE"
echo "Grootte:           ${PERSISTENCE_SIZE_GB}GB"
echo "Locatie:           $PERSISTENCE_PATH"
echo ""

# --- Controleer of bestand al bestaat ---
if [ -f "$PERSISTENCE_PATH" ]; then
    echo "WAARSCHUWING: Persistence bestand bestaat al: $PERSISTENCE_PATH"
    read -r -p "Overschrijven? (j/N) " bevestig
    if [[ "$bevestig" != "j" && "$bevestig" != "J" ]]; then
        echo "Afgebroken."
        exit 0
    fi
fi

# --- Controleer beschikbare ruimte ---
VRIJE_RUIMTE=$(df -B1 "$VENTOY_MOUNT" | tail -1 | awk '{print $4}')
if [ "$VRIJE_RUIMTE" -lt "$PERSISTENCE_BYTES" ]; then
    VRIJE_GB=$((VRIJE_RUIMTE / 1024 / 1024 / 1024))
    echo "FOUT: Niet genoeg ruimte op Ventoy partitie."
    echo "Beschikbaar: ${VRIJE_GB}GB, Nodig: ${PERSISTENCE_SIZE_GB}GB"
    exit 1
fi

# --- Maak persistence bestand aan ---
echo "Persistence bestand aanmaken (dit kan even duren)..."
dd if=/dev/zero of="$PERSISTENCE_PATH" bs=1M count=$((PERSISTENCE_SIZE_GB * 1024)) status=progress

# --- Formatteer als ext4 met juist label ---
echo ""
echo "Formatteren als ext4..."
mkfs.ext4 -L "casper-rw" "$PERSISTENCE_PATH"

# --- Ventoy persistence configuratie ---
VTOY_CONF="$VENTOY_MOUNT/ventoy/ventoy.json"
mkdir -p "$(dirname "$VTOY_CONF")"

# Controleer of ventoy.json al bestaat
if [ -f "$VTOY_CONF" ]; then
    echo ""
    echo "WAARSCHUWING: $VTOY_CONF bestaat al."
    echo "Voeg handmatig de persistence configuratie toe:"
    cat << JSONCONF

    Toevoegen aan ventoy.json:
    {
        "persistence": [
            {
                "image": "/$ISO_NAME",
                "backend": "/$PERSISTENCE_FILE",
                "autosel": 1
            }
        ]
    }

JSONCONF
else
    # Maak nieuwe ventoy.json aan
    cat > "$VTOY_CONF" << JSONEOF
{
    "persistence": [
        {
            "image": "/$ISO_NAME",
            "backend": "/$PERSISTENCE_FILE",
            "autosel": 1
        }
    ]
}
JSONEOF
    echo "Ventoy configuratie aangemaakt: $VTOY_CONF"
fi

echo ""
echo "============================================"
echo "  Persistence setup voltooid!"
echo "============================================"
echo ""
echo "Bestand aangemaakt: $PERSISTENCE_PATH (${PERSISTENCE_SIZE_GB}GB)"
echo ""
echo "Volgende stap: Boot Xubuntu via Ventoy."
echo "Persistence wordt automatisch geactiveerd."
echo ""
echo "Na het booten, installeer Claude Code:"
echo "  bash ~/DevaClaudeCodeOpVentoy/setup/install-claude-code.sh"
echo ""
