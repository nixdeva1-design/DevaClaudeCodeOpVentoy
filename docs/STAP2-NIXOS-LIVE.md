# Stap 2 — NixOS live opstarten via Ventoy

> **Je bent nu in:** Xubuntu live sessie  
> **Doel:** Opnieuw opstarten en NixOS kiezen in het Ventoy menu  
> **Daarna:** Stap 3 — NixOS installeren

---

## Waarom opnieuw opstarten?

We hebben nu een werkend overzicht van je USB stick (stap 1).  
Nu starten we NixOS op — dat is het echte systeem dat we gaan installeren.  
NixOS start ook als "live" (tijdelijk), zodat we daarna kunnen installeren.

---

## 2.1 — Opslaan wat je nog open hebt

Controleer of er iets open staat dat je wilt bewaren:
- GitHub pagina? Bladwijzer toevoegen of het adres opschrijven
- Terminal tekst? Screenshot maken

---

## 2.2 — Computer opnieuw opstarten

In Xubuntu:
1. Klik op het **applicatiemenu** (linksboven of taakbalk)
2. Kies **Log Out** of **Restart**
3. Klik op **Restart**

De computer herstart en je ziet het **Ventoy menu** — een lijst met ISO bestanden.

---

## 2.3 — NixOS kiezen in Ventoy

In het Ventoy menu zie je een lijst van ISO bestanden.  
Je hebt 4 stuks, waaronder NixOS.

Doe dit:
1. Gebruik de **pijltjestoetsen** (omhoog/omlaag) om NixOS te selecteren
2. Druk op **Enter**
3. Als er een vervolgmenu verschijnt, kies dan de **eerste optie** (normaal opstarten)

NixOS laadt nu. Dit kan 1-2 minuten duren.

---

## 2.4 — Je bent nu in NixOS live

NixOS live ziet er mogelijk anders uit dan Xubuntu.  
Het kan zijn dat je een tekstinterface ziet (zwart scherm met tekst).  
Dat is normaal voor NixOS — het is een krachtig systeem, minder visueel dan Xubuntu.

Je ziet zoiets als:
```
NixOS 24.xx (...)
...
nixos login:
```

Of je wordt direct aangemeld en ziet een prompt:
```
[nixos@nixos:~]$
```

---

## 2.5 — Internetverbinding controleren

Type dit in en druk Enter:
```
ping -c 3 github.com
```

Als je zoiets ziet:
```
64 bytes from ... time=xx ms
```
Dan heb je internet. Goed!

Als je een foutmelding ziet, dan moet WiFi ingesteld worden — laat het weten.

---

## Klaar met stap 2?

Ga naar [Stap 3 — NixOS installeren op USB](STAP3-NIXOS-INSTALLATIE.md)
