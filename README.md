# DevaClaudeCodeOpVentoy

> **Status: Experimenteel — werk in uitvoering**

Claude Code als portable code companion op een Ventoy USB stick (256GB Kingston DataTraveler).
Draait Xubuntu 25 live via Ventoy met persistente opslag zodat Claude Code al je instellingen en projecten onthoudt.

---

## Doel

Een volledig draagbare ontwikkelomgeving op een USB 3.0 stick waarbij:
- Claude Code altijd beschikbaar is als AI coding companion
- Projecten en configuratie bewaard blijven tussen sessies (Ventoy persistence)
- Toegang tot externe systemen via SSH vanuit de USB omgeving
- Geen afhankelijkheid van de host laptop (werkt op elke x86-64 machine)

## Hardware

| Component | Details |
|-----------|---------|
| USB Stick | Kingston DataTraveler 256GB USB 3.0 |
| Boot systeem | [Ventoy](https://www.ventoy.net/) |
| OS | Xubuntu 25.04 (live met persistence) |

## Structuur

```
DevaClaudeCodeOpVentoy/
├── setup/
│   ├── install-claude-code.sh      # Claude Code installeren op USB
│   ├── ventoy-persistence.sh       # Ventoy persistence partition aanmaken
│   └── ssh-config-template.sh      # SSH toegang tot je systemen instellen
├── config/
│   ├── claude-settings.json        # Claude Code instellingen template
│   └── .env.template               # API sleutel template (nooit echte sleutels committen!)
├── workspace/
│   └── .gitkeep                    # Jouw projecten komen hier
├── docs/
│   └── SETUP_PLAN.md               # Stap-voor-stap handleiding
└── README.md
```

## Snelstart

Zie [docs/SETUP_PLAN.md](docs/SETUP_PLAN.md) voor de volledige handleiding.

```bash
# 1. Ventoy persistence instellen
bash setup/ventoy-persistence.sh

# 2. Claude Code installeren (in live Xubuntu sessie)
bash setup/install-claude-code.sh

# 3. API sleutel configureren
cp config/.env.template ~/.claude/.env
nano ~/.claude/.env   # Vul je ANTHROPIC_API_KEY in

# 4. Starten
claude
```

## Veiligheid

- Sla **nooit** je Anthropic API key op in git
- Gebruik `.env.template` als voorbeeld, vul de echte key in via de terminal
- Zie `.gitignore` voor uitgesloten bestanden
