# Stap 1 — Voorbereiding: schijf bekijken

> **Je bent nu in:** Xubuntu live sessie  
> **Doel:** Zien hoe jouw USB stick er van binnen uitziet  
> **Daarna:** Stap 2 — NixOS opstarten

---

## Wat gaan we doen?

We gaan kijken hoe de schijven in de computer eruitzien.  
De "terminal" is een tekstvenster waar je opdrachten kunt intikken.  
Je hoeft niet te begrijpen wat alles betekent — kopieer gewoon de tekst en plak hem in.

---

## 1.1 — Terminal openen

Doe dit:

1. Kijk rechtsonder op je scherm → er staat een taakbalk
2. Zoek naar een klein zwart rechthoekje (het terminal-icoontje)  
   **OF:** klik met de rechtermuisknop op het bureaublad → kies "Open Terminal"  
   **OF:** druk op de toetsen **Ctrl + Alt + T** tegelijk

Er verschijnt een zwart venster met tekst. Dat is de terminal. Goed zo.

---

## 1.2 — Schijfindeling opvragen

**Klik in het zwarte venster** zodat het actief is.

Typ dan precies dit over (of kopieer en plak het met rechtermuisknop → Plakken):

```
lsblk
```

Druk op **Enter**.

Je ziet nu een lijst van schijven en partities. Het ziet er ongeveer zo uit:

```
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    1 238.5G  0 disk
├─sda1   8:1    1   200M  0 part
├─sda2   8:2    1    32M  0 part
└─sda3   8:3    1   238G  0 part
```

---

## 1.3 — Maak een foto of noteer wat je ziet

**Belangrijk:** Maak een screenshot of schrijf op wat er staat.

Hoe screenshot maken in Xubuntu:
- Druk op de **Print Screen** toets op je toetsenbord
- Of: druk op **Alt + Print Screen** voor alleen het huidige venster

---

## 1.4 — Wat betekent wat je ziet?

| Naam | Wat is het? |
|------|-------------|
| `sda` | Een schijf (waarschijnlijk jouw Kingston USB) |
| `sdb` | Een tweede schijf (kan interne disk zijn, of niet aanwezig) |
| `sda1`, `sda2` etc. | Partities (onderdelen) van de schijf |
| `RM  1` | Verwisselbare schijf (removable) = USB stick |
| `238.5G` | Grootte — bij 256GB USB zie je ±238GB |

De USB stick die je gebruikt is de schijf met **RM = 1** en grootte **~238G**.

---

## 1.5 — Deel de uitvoer

Deel wat je ziet met Claude (kopieer de tekst uit het terminalvenster).

**Hoe tekst kopiëren uit terminal:**
1. Klik en sleep om de tekst te selecteren
2. Druk op **Ctrl + Shift + C** (niet gewoon Ctrl+C, dat werkt anders in terminal)
3. Plak het in het chatvenster met **Ctrl + V**

---

## Klaar met stap 1?

Ga naar [Stap 2 — NixOS live opstarten](STAP2-NIXOS-LIVE.md)
