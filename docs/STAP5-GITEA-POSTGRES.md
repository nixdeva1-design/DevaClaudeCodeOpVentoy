# Stap 5 — Gitea + PostgreSQL instellen

> **Je bent nu in:** NixOS (werkend, Claude Code actief)  
> **Doel:** Eigen Git server (Gitea) en database (PostgreSQL) op de USB  
> **Daarna:** Je USB werkplek is compleet!

---

## Wat zijn Gitea en PostgreSQL?

**Gitea** is jouw eigen persoonlijke GitHub — maar dan op je USB stick.  
Je kunt er repositories (projectmappen) in bewaren, versies bijhouden, alles lokaal.  
Werkt zelfs zonder internet.

**PostgreSQL** is een database — een georganiseerde opslag voor gegevens.  
Gitea heeft een database nodig om te werken. PostgreSQL levert dat.

---

## 5.1 — Controleer of services draaien

In NixOS worden Gitea en PostgreSQL gestart via de `configuration.nix`.  
Als je de configuratie uit stap 3 hebt gebruikt, draaien ze al automatisch.

Controleer:
```
systemctl status gitea
systemctl status postgresql
```

Als je `active (running)` ziet: beide services werken.  
Als je een foutmelding ziet: laat het weten, we lossen het op.

---

## 5.2 — Gitea eerste keer instellen

Open Firefox en ga naar:
```
http://localhost:3000
```

Je ziet de Gitea installatiepagina.

Vul in:
| Veld | Waarde |
|------|--------|
| Database type | PostgreSQL |
| Database host | `127.0.0.1:5432` |
| Database naam | `gitea` |
| Database gebruiker | `gitea` |
| Database wachtwoord | (leeglaten, wordt automatisch ingesteld) |
| Site titel | `Deva USB Gitea` (of wat je wilt) |
| Repository pad | `/var/lib/gitea/repositories` |

Scroll naar beneden en klik **Install Gitea**.

---

## 5.3 — Eerste gebruiker aanmaken

Na de installatie zie je een registratiescherm.

Maak een account aan:
- Gebruikersnaam: `deva` (of jouw naam)
- E-mail: jouw emailadres
- Wachtwoord: kies iets dat je onthoudt

**De eerste gebruiker wordt automatisch beheerder.**

---

## 5.4 — Repository aanmaken in Gitea

1. Klik op het **+** icoontje rechtsboven
2. Kies **New Repository**
3. Naam: `DevaClaudeCodeOpVentoy`
4. Beschrijving: `Mijn USB werkplek configuratie`
5. Vink aan: **Initialize this repository**
6. Klik **Create Repository**

---

## 5.5 — Lokale projecten koppelen aan Gitea

```
cd ~/projecten/DevaClaudeCodeOpVentoy
git remote add lokaal http://localhost:3000/deva/DevaClaudeCodeOpVentoy.git
git push lokaal main
```

Nu staat je project ook lokaal op de USB, los van GitHub.

---

## Je werkplek is nu compleet!

```
┌─────────────────────────────────────────────────────┐
│  Kingston 256GB USB  —  Jouw Werkplek               │
│                                                     │
│  NixOS                                              │
│  ├── Claude Code CLI  (AI coding assistent)         │
│  ├── Gitea            (eigen Git server)            │
│  │     http://localhost:3000                        │
│  ├── PostgreSQL       (database)                    │
│  └── ~/projecten/     (jouw code)                  │
│                                                     │
│  Werkt op elke computer  •  Alles bewaard           │
└─────────────────────────────────────────────────────┘
```

---

## Dagelijks gebruik

**USB insteken + opstarten:**
```
# Computer start automatisch NixOS op
```

**Claude Code starten:**
```
cd ~/projecten/mijn-project
claude
```

**Gitea bekijken:**
```
# Open Firefox → http://localhost:3000
```

**Systeem updaten:**
```
sudo nixos-rebuild switch --upgrade
```
