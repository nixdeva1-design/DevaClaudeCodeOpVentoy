# Stap 6 — Ventoy menu configureren

> **Je bent nu in:** NixOS (geïnstalleerd, werkend)  
> **Doel:** Ventoy menu instellen met alle opties voor klantbezoeken

---

## Welke ISOs op de Ventoy partitie?

| ISO bestand | Gebruik |
|-------------|---------|
| `nixos-*.iso` | NixOS installeren bij klant of als live herstel |
| `xubuntu-*.iso` | Lichtgewicht Linux live, werkt op bijna alles |
| `windows-*.iso` | Windows installeren of repareren bij klant |
| `clonezilla-*.iso` | Schijven kopiëren / backups maken |
| `gparted-*.iso` | Schijven bewerken |

---

## Ventoy automatisch NixOS laten starten

Na installatie wil je dat Ventoy **automatisch NixOS opstart** als je niets kiest.  
Alleen als je een toets indrukt zie je het volledige menu (voor klantwerk).

Maak dit bestand aan op de Ventoy partitie:

**Bestand:** `/ventoy/ventoy.json`
```json
{
    "default_search": {
        "timeout": 5
    },
    "auto_install": [
        {
            "image": "/iso/nixos-*.iso"
        }
    ]
}
```

---

## ISOs toevoegen aan Ventoy

Ventoy is simpel: kopieer een ISO naar de Ventoy partitie en het verschijnt automatisch in het menu.

```bash
# Ventoy partitie koppelen
sudo mkdir -p /mnt/ventoy
sudo mount /dev/sdb1 /mnt/ventoy

# ISO kopiëren (voorbeeld)
sudo cp ~/Downloads/windows11.iso /mnt/ventoy/iso/

# Ontkoppelen
sudo umount /mnt/ventoy
```

---

## Notities voor klantbezoeken

### NixOS installeren bij klant
1. USB insteken in klant-computer
2. Opstarten → Ventoy menu → NixOS installer ISO kiezen
3. Installeren op klant-schijf
4. Of: dual-boot naast Windows kiezen in installer

### Windows repareren
1. USB insteken
2. Ventoy menu → Windows ISO kiezen
3. "Repair your computer" kiezen in Windows setup

### Snel eigen werkplek starten
1. USB insteken
2. Ventoy menu → NixOS werkplek (of wacht 5 seconden, start automatisch)
3. Aan het werk
