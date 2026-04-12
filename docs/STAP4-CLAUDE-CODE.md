# Stap 4 — Claude Code instellen

> **Je bent nu in:** NixOS (net geïnstalleerd, eerste opstart)  
> **Doel:** Claude Code CLI werkend krijgen  
> **Daarna:** Stap 5 — Gitea + PostgreSQL

---

## Wat is Claude Code CLI?

Claude Code is een programma dat je in de terminal gebruikt.  
In plaats van via de browser met Claude praten, gebruik je je eigen computer.  
Je kunt Claude dan vragen om bestanden te lezen, code te schrijven, commando's uit te voeren.  
Het grote voordeel: Claude heeft dan toegang tot jouw projecten op de USB.

---

## 4.1 — API sleutel ophalen

Je hebt een "API sleutel" nodig — dit is een soort wachtwoord waarmee Claude Code  
weet dat jij het bent.

1. Ga in Firefox naar: `https://console.anthropic.com/`
2. Log in op je account
3. Klik op **API Keys** in het linker menu
4. Klik op **Create Key**
5. Geef het een naam bijv. `usb-stick`
6. Kopieer de sleutel — hij begint met `sk-ant-...`
7. Bewaar hem ergens veilig (bijv. in een teksteditor tijdelijk)

> **Let op:** Je ziet de sleutel maar één keer. Bewaar hem goed.

---

## 4.2 — Claude Code installen en configureren

Open een terminal en typ:

```
export ANTHROPIC_API_KEY=sk-ant-JOUW-SLEUTEL-HIER
```

Vervang `sk-ant-JOUW-SLEUTEL-HIER` met de sleutel die je bij 4.1 kopieerde.

Daarna permanent instellen:
```
echo 'export ANTHROPIC_API_KEY=sk-ant-JOUW-SLEUTEL-HIER' >> ~/.bashrc
source ~/.bashrc
```

Claude Code starten:
```
claude
```

Als alles goed is, zie je een welkomstbericht van Claude. Gelukt!

---

## 4.3 — Eerste test

Type in Claude Code (na het starten met `claude`):

```
Hallo, kun je me vertellen welke bestanden er in mijn thuismap staan?
```

Claude zal dan de bestanden bekijken en je antwoord geven.

---

## 4.4 — Projectenmap aanmaken

```
mkdir -p ~/projecten
cd ~/projecten
```

Alle nieuwe projecten komen in `~/projecten/naam-van-project`.  
Deze map staat op de NixOS partitie van je USB en blijft bewaard.

---

## Klaar met stap 4?

Ga naar [Stap 5 — Gitea + PostgreSQL](STAP5-GITEA-POSTGRES.md)
