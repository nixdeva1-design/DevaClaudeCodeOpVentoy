# Stap 3 — NixOS installeren op de USB stick

> **Je bent nu in:** NixOS live sessie  
> **Doel:** NixOS permanent installeren op de Kingston USB  
> **Daarna:** Stap 4 — Claude Code instellen

---

## Hoe werkt NixOS anders dan andere systemen?

Bij NixOS schrijf je je hele systeem op in één bestand: `configuration.nix`.  
Daarin staat alles: welke programma's je wilt, instellingen, gebruikers, services.  
Als je ooit opnieuw moet installeren, kopieer je dat bestand erbij en alles is terug.

Wij bewaren dat bestand in GitHub → zodat je het nooit kwijtraakt.

---

## Hoe de USB opgedeeld wordt

De Kingston 256GB wordt zo ingedeeld:

```
┌─────────────────────────────────────────────────────┐
│  Kingston 256GB USB                                 │
│                                                     │
│  ┌──────────┐  ┌────────┐  ┌────────────────────┐  │
│  │ EFI Boot │  │  Swap  │  │   NixOS + Data     │  │
│  │  512MB   │  │  4GB   │  │     ~250GB         │  │
│  └──────────┘  └────────┘  └────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

| Partitie | Grootte | Gebruik |
|----------|---------|---------|
| EFI | 512MB | Opstartbestanden (noodzakelijk) |
| Swap | 4GB | Extra geheugen als RAM vol is |
| Root `/` | Rest (~250GB) | NixOS zelf + al jouw bestanden |

---

## 3.1 — Schijfnaam vaststellen

We moeten weten hoe de computer de Kingston USB noemt.  
Type dit en druk Enter:

```
lsblk
```

Zoek de schijf met **~238GB** (dat is de 256GB USB).  
Onthoud de naam: `sda`, `sdb`, of `sdc` etc.

> **Voorbeeld:** Als de USB `sda` heet, dan werken we met `/dev/sda`

---

## 3.2 — Partities aanmaken

> **LET OP:** Dit wist alles op de USB stick. De ISO bestanden op Ventoy gaan weg.  
> Dat is OK — na de installatie boot je NixOS direct, Ventoy is niet meer nodig.  
> Wil je de ISO's bewaren? Kopieer ze naar een tweede USB of je telefoon via kabeloverdracht.

Vervang in de commando's hieronder `sdX` door de naam die je bij 3.1 vond (bijv. `sda`).

**Partitietabel aanmaken:**
```
sudo parted /dev/sdX -- mklabel gpt
```

**EFI partitie (512MB):**
```
sudo parted /dev/sdX -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/sdX -- set 1 esp on
```

**Swap partitie (4GB):**
```
sudo parted /dev/sdX -- mkpart primary linux-swap 512MB 4608MB
```

**Root partitie (de rest):**
```
sudo parted /dev/sdX -- mkpart primary ext4 4608MB 100%
```

---

## 3.3 — Partities formatteren

```
sudo mkfs.fat -F 32 -n boot /dev/sdX1
sudo mkswap /dev/sdX2
sudo mkfs.ext4 -L nixos /dev/sdX3
```

---

## 3.4 — Partities koppelen (mounten)

```
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
sudo swapon /dev/sdX2
```

---

## 3.5 — NixOS configuratie aanmaken

NixOS genereert een basis configuratie:
```
sudo nixos-generate-config --root /mnt
```

Nu kopiëren we onze eigen configuratie (met Claude Code, Gitea etc.) naar de USB:

```
sudo curl -o /mnt/etc/nixos/configuration.nix \
  https://raw.githubusercontent.com/nixdeva1-design/DevaClaudeCodeOpVentoy/claude/setup-usb-development-CpbxZ/nixos/configuration.nix
```

---

## 3.6 — NixOS installeren

```
sudo nixos-install
```

Dit duurt 10-30 minuten afhankelijk van je internetverbinding.  
NixOS downloadt en installeert alle software die in de configuratie staat.

Aan het einde vraagt het om een **root wachtwoord** — kies iets dat je onthoudt.

---

## 3.7 — Herstarten naar NixOS

```
sudo reboot
```

Verwijder NIETS — de USB stick blijft zitten.  
Na herstart boot de computer automatisch in jouw nieuwe NixOS.

---

## Klaar met stap 3?

Ga naar [Stap 4 — Claude Code instellen](STAP4-CLAUDE-CODE.md)
