# Setup Plan: Claude Code op Ventoy USB

## Overzicht

```
┌─────────────────────────────────────────────────────┐
│  Kingston 256GB USB 3.0                             │
│                                                     │
│  ┌─────────────────┐  ┌──────────────────────────┐ │
│  │  Ventoy Boot    │  │  Persistence Partition   │ │
│  │  (FAT32/exFAT)  │  │  (ext4, ~50GB)           │ │
│  │                 │  │                          │ │
│  │  Xubuntu 25.iso │  │  /home/user/             │ │
│  │                 │  │  ~/.claude/              │ │
│  │                 │  │  ~/projecten/            │ │
│  │                 │  │  Claude Code binary      │ │
│  └─────────────────┘  └──────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

---

## Stap 1: Ventoy installeren op USB stick

**Doe dit eenmalig op een werkende computer (Windows of Linux)**

### Op Linux:
```bash
# Download Ventoy
wget https://github.com/ventoy/Ventoy/releases/download/v1.0.99/ventoy-1.0.99-linux.tar.gz
tar -xf ventoy-1.0.99-linux.tar.gz
cd ventoy-1.0.99

# Installeer op USB (VERVANG /dev/sdX met jouw USB device!)
# WAARSCHUWING: Dit wist de USB stick volledig
sudo sh Ventoy2Disk.sh -i /dev/sdX
```

### Op Windows:
1. Download Ventoy van https://www.ventoy.net/
2. Start `Ventoy2Disk.exe` als administrator
3. Selecteer je USB stick en klik "Install"

---

## Stap 2: Xubuntu ISO op USB zetten

```bash
# Kopieer de Xubuntu ISO naar de Ventoy partitie
cp xubuntu-25.04-desktop-amd64.iso /media/user/Ventoy/
```

---

## Stap 3: Ventoy Persistence instellen

Ventoy ondersteunt persistente opslag zodat wijzigingen bewaard blijven.

```bash
# Maak persistence bestand aan (zie setup/ventoy-persistence.sh)
bash setup/ventoy-persistence.sh
```

Dit script maakt een `xubuntu-25.04-desktop-amd64.persistence` bestand
op de Ventoy partitie zodat je /home en /etc bewaard blijven.

---

## Stap 4: Booten vanaf USB

1. Stop de USB stick in de laptop
2. Start de laptop op en druk op F12/F2/Del voor de boot menu
3. Selecteer de USB stick
4. Kies in het Ventoy menu voor Xubuntu
5. **Belangrijk:** Kies "Boot with persistence" als optie beschikbaar

---

## Stap 5: Claude Code installeren (in Xubuntu live sessie)

```bash
# Voer het installatiescript uit
bash ~/setup/install-claude-code.sh
```

Het script doet:
1. Node.js 22 LTS installeren via nvm (opgeslagen in persistence)
2. Claude Code installeren via npm
3. Configuratiemap aanmaken in ~/.claude/
4. Basis shell-integratie instellen

---

## Stap 6: API sleutel instellen

```bash
# Maak configuratiebestand aan vanuit template
cp ~/DevaClaudeCodeOpVentoy/config/.env.template ~/.claude/.env

# Vul je Anthropic API key in
nano ~/.claude/.env
# Zet: ANTHROPIC_API_KEY=sk-ant-...jouw-sleutel...

# Laad de variabele in je shell
echo 'export $(grep -v "^#" ~/.claude/.env | xargs)' >> ~/.bashrc
source ~/.bashrc
```

Haal je API key op via: https://console.anthropic.com/

---

## Stap 7: SSH toegang tot je systemen

```bash
# Genereer SSH sleutel (bewaard in persistence)
ssh-keygen -t ed25519 -C "claude-usb-stick" -f ~/.ssh/id_ed25519_usb

# Kopieer public key naar je servers/systemen
cat ~/.ssh/id_ed25519_usb.pub
# Plak dit in ~/.ssh/authorized_keys op je doelsysteem

# Stel SSH config in
bash ~/DevaClaudeCodeOpVentoy/setup/ssh-config-template.sh
```

---

## Stap 8: Claude Code gebruiken

```bash
# Start Claude Code in een projectmap
cd ~/projecten/mijn-project
claude

# Of met een specifieke taak
claude "help me met deze Python bug"
```

---

## Tips voor USB ontwikkeling

### Performance
- USB 3.0 poort gebruiken (blauw van kleur) voor snelste snelheid
- Bewaar grote bestanden (node_modules, .venv) in een RAM disk voor snelheid:
  ```bash
  # Maak RAM disk voor node_modules
  mkdir -p /tmp/node_modules_cache
  ```

### Backup
- Sync je projecten regelmatig naar GitHub:
  ```bash
  git push origin main
  ```
- De USB stick is je enige lokale opslag — maak regelmatig backups!

### Netwerk
- Claude Code heeft internetverbinding nodig voor de API
- Gebruik je telefoon als hotspot als er geen WiFi is

---

## Probleemoplossing

| Probleem | Oplossing |
|----------|-----------|
| Persistence werkt niet | Check of juiste persistence bestand naam gebruikt wordt |
| Claude Code niet gevonden | Herstart terminal of `source ~/.bashrc` uitvoeren |
| API key fout | Check `echo $ANTHROPIC_API_KEY` in terminal |
| USB stick langzaam | Gebruik USB 3.0 poort, vermijd USB hubs |
| SSH verbinding mislukt | Check of public key correct is toegevoegd aan server |
