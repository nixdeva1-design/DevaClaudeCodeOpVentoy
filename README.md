# DevaClaudeCodeOpVentoy — Mobiele IT Werkplek

> Als de verbinding verbreekt: open deze pagina opnieuw en ga verder bij de stap waar je was gebleven.

## Wat is dit?

Een **Kingston 256GB USB 3.0** die dienst doet als complete mobiele IT-werkplek.  
Je steekt hem in bij een klant, start op naast hun Windows of Mac, en werkt.

```
┌─────────────────────────────────────────────────────────────────┐
│  Kingston 256GB USB  —  Jouw Mobiele Werkplek                   │
│                                                                 │
│  VENTOY MENU (altijd eerste scherm bij opstarten)               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  > NixOS werkplek starten    (jouw installed werkplek)   │   │
│  │    Xubuntu live              (noodoplossing / herstel)   │   │
│  │    NixOS installer ISO       (NixOS installeren bij klant│   │
│  │    Windows ISO               (Windows repareren/install) │   │
│  │    Clonezilla of GParted     (schijf tools)              │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  USB INDELING:                                                  │
│  ┌──────────┬──────┬───────┬──────┬───────────────────────┐    │
│  │  Ventoy  │VTOY  │ Boot  │ Swap │   NixOS werkplek       │    │
│  │  + ISOs  │ EFI  │512MB  │ 4GB  │      ~220 GB           │    │
│  │   30GB   │ 32MB │FAT32  │      │   al jouw werk hier    │    │
│  └──────────┴──────┴───────┴──────┴───────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

## Gebruik bij klanten

| Situatie | Wat je doet |
|----------|-------------|
| Klant heeft Windows probleem | USB insteken → Xubuntu live of NixOS booten → probleem bekijken |
| Klant wil NixOS proberen | USB insteken → NixOS installer ISO kiezen → installeren |
| Klant wil NixOS naast Windows | Dual-boot installatie via NixOS installer ISO |
| Jij wilt werken naast klant OS | USB insteken → NixOS werkplek kiezen → jij werkt, klant doet zijn ding |
| Windows totaal kapot | Windows ISO op Ventoy → opnieuw installeren |

## Over macOS / Darwin

> macOS kan **niet** als live USB draaien op niet-Apple hardware.  
> Wat je wél kunt: een **macOS herstelpartitie USB** maken op een Mac.  
> Die werkt dan alleen op Apple hardware.  
> Voor Mac-reparaties bij klanten: gebruik een echte Mac als tussenstap.

## De stappen

| # | Stap | Status |
|---|------|--------|
| 1 | [Voorbereiding](docs/STAP1-VOORBEREIDING.md) | Klaar |
| 2 | [NixOS live opstarten](docs/STAP2-NIXOS-LIVE.md) | Klaar |
| 3 | [NixOS installeren op USB](docs/STAP3-NIXOS-INSTALLATIE.md) | ← Bezig |
| 4 | [Claude Code instellen](docs/STAP4-CLAUDE-CODE.md) | Na stap 3 |
| 5 | [Gitea + PostgreSQL](docs/STAP5-GITEA-POSTGRES.md) | Na stap 4 |
| 6 | [Ventoy menu configureren](docs/STAP6-VENTOY-MENU.md) | Na stap 4 |
