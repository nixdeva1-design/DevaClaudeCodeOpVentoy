# DevaClaudeCodeOpVentoy — USB Werkplek

> Als de verbinding verbreekt: open deze pagina opnieuw en ga verder bij de stap waar je was gebleven.

## Wat bouwen we?

Een **Kingston 256GB USB stick** die jouw complete werkplek is:
- Werkt op elke willekeurige computer (gewoon insteken en opstarten)
- **NixOS** als besturingssysteem (stabiel, alles configureerbaar)
- **Claude Code** als AI coding assistent
- **Gitea** (eigen GitHub op je USB)
- **PostgreSQL** (eigen database)
- Al je projecten staan op de USB

---

## De stappen (klik voor details)

| # | Stap | Status |
|---|------|--------|
| 1 | [Voorbereiding: schijf bekijken](docs/STAP1-VOORBEREIDING.md) | ← Begin hier |
| 2 | [NixOS starten vanuit Ventoy](docs/STAP2-NIXOS-LIVE.md) | Na stap 1 |
| 3 | [NixOS installeren op USB](docs/STAP3-NIXOS-INSTALLATIE.md) | Na stap 2 |
| 4 | [Claude Code instellen](docs/STAP4-CLAUDE-CODE.md) | Na stap 3 |
| 5 | [Gitea + PostgreSQL instellen](docs/STAP5-GITEA-POSTGRES.md) | Na stap 4 |

---

## Huidige situatie

Je zit nu in **Xubuntu live** (opgestart via Ventoy).  
Xubuntu is een tijdelijke omgeving — wijzigingen verdwijnen na herstart.  
Dat is OK voor nu. We gaan stap voor stap NixOS permanent installeren.

---

## Bij verbindingsverlies

1. Start je USB opnieuw op (kies Xubuntu in Ventoy menu)
2. Open Firefox → ga naar `github.com/nixdeva1-design/DevaClaudeCodeOpVentoy`
3. Klik op de stap waar je mee bezig was in de tabel hierboven
4. Ga verder
