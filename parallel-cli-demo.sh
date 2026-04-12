#!/usr/bin/env bash
# parallel-cli-demo.sh
# Demonstratie: parallel werken in CLI aan hetzelfde project
# Methodes: achtergrondprocessen, wachten op resultaten, output samenvoegen

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$PROJECT_ROOT/.parallel-logs"
mkdir -p "$LOG_DIR"

# ── Kleuren ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; NC='\033[0m'

log()  { echo -e "${BLUE}[$(date +%H:%M:%S)]${NC} $*"; }
ok()   { echo -e "${GREEN}[OK]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail() { echo -e "${RED}[FAIL]${NC} $*"; }

# ── Taak-functie (simuleert werk) ────────────────────────────────────────────
run_task() {
    local name="$1"
    local duration="$2"
    local logfile="$LOG_DIR/${name}.log"

    log "Start taak: $name (duurt ~${duration}s)" | tee "$logfile"
    sleep "$duration"
    echo "Taak $name klaar op $(date)" >> "$logfile"
    ok "Taak $name afgerond" | tee -a "$logfile"
}

# ── 1. Serieel (traag) ────────────────────────────────────────────────────────
demo_serieel() {
    echo ""
    echo "=== SERIEEL (taken na elkaar) ==="
    local start=$SECONDS
    run_task "lint"     1
    run_task "test"     2
    run_task "build"    1
    echo "Totale tijd serieel: $((SECONDS - start))s"
}

# ── 2. Parallel met & en wait ─────────────────────────────────────────────────
demo_parallel() {
    echo ""
    echo "=== PARALLEL (taken tegelijk met \`&\` en \`wait\`) ==="
    local start=$SECONDS
    local pids=()

    run_task "lint"  1 & pids+=($!)
    run_task "test"  2 & pids+=($!)
    run_task "build" 1 & pids+=($!)

    # Wacht op alle achtergrondprocessen en vang foutcodes op
    local failed=0
    for pid in "${pids[@]}"; do
        if ! wait "$pid"; then
            fail "Proces $pid mislukt"
            failed=1
        fi
    done

    echo "Totale tijd parallel: $((SECONDS - start))s"
    [[ $failed -eq 0 ]] && ok "Alle parallelle taken geslaagd" || fail "Een of meer taken mislukten"
    return $failed
}

# ── 3. Parallel met xargs -P ──────────────────────────────────────────────────
demo_xargs_parallel() {
    echo ""
    echo "=== PARALLEL met \`xargs -P\` ==="
    local start=$SECONDS

    # Voer maximaal 3 taken tegelijk uit
    printf '%s\n' "script-a" "script-b" "script-c" "script-d" \
        | xargs -P 3 -I{} bash -c '
            echo "[$(date +%H:%M:%S)] Start: {}"
            sleep 1
            echo "[$(date +%H:%M:%S)] Klaar: {}"
        '

    echo "Totale tijd xargs -P: $((SECONDS - start))s"
}

# ── Rapportage ────────────────────────────────────────────────────────────────
toon_logs() {
    echo ""
    echo "=== LOGBESTANDEN ==="
    for f in "$LOG_DIR"/*.log; do
        [[ -e "$f" ]] || continue
        echo "--- $(basename "$f") ---"
        cat "$f"
    done
}

# ── Hoofd ─────────────────────────────────────────────────────────────────────
main() {
    log "Parallel CLI demo gestart"
    demo_serieel
    demo_parallel
    demo_xargs_parallel
    toon_logs
    log "Demo klaar. Logs in: $LOG_DIR"
}

main "$@"
