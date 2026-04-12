#!/usr/bin/env bash
# worktree-helper.sh
# Git worktrees: meerdere branches tegelijk uitchecken in aparte mappen
# Zo kan je op DEZELFDE repo parallel werken zonder branch-switches.

set -euo pipefail

REPO_ROOT="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)"
WORKTREES_DIR="$(dirname "$REPO_ROOT")/worktrees"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log()  { echo -e "${BLUE}[worktree]${NC} $*"; }
ok()   { echo -e "${GREEN}[OK]${NC} $*"; }
warn() { echo -e "${YELLOW}[INFO]${NC} $*"; }

usage() {
    cat <<EOF
Gebruik: $(basename "$0") <commando> [opties]

Commando's:
  add <branch>        Maak nieuwe worktree aan voor <branch>
  add-new <branch>    Maak worktree + nieuwe branch aan
  list                Toon alle actieve worktrees
  remove <branch>     Verwijder worktree voor <branch>
  run-all <cmd>       Voer <cmd> parallel uit in alle worktrees
  demo                Demonstreer parallel werken via worktrees

Voorbeeld:
  $(basename "$0") add-new feature/login
  $(basename "$0") run-all "git status"
  $(basename "$0") demo
EOF
}

cmd_add() {
    local branch="$1"
    local path="$WORKTREES_DIR/$branch"
    mkdir -p "$(dirname "$path")"
    git -C "$REPO_ROOT" worktree add "$path" "$branch"
    ok "Worktree aangemaakt: $path  (branch: $branch)"
}

cmd_add_new() {
    local branch="$1"
    local path="$WORKTREES_DIR/$branch"
    mkdir -p "$(dirname "$path")"
    git -C "$REPO_ROOT" worktree add -b "$branch" "$path"
    ok "Nieuwe branch + worktree: $path  (branch: $branch)"
}

cmd_list() {
    log "Actieve worktrees:"
    git -C "$REPO_ROOT" worktree list
}

cmd_remove() {
    local branch="$1"
    local path="$WORKTREES_DIR/$branch"
    git -C "$REPO_ROOT" worktree remove "$path"
    ok "Worktree verwijderd: $path"
}

# Voer een commando parallel uit in alle worktrees (behalve de hoofd-repo)
cmd_run_all() {
    local cmd="$*"
    log "Parallel uitvoeren in alle worktrees: '$cmd'"

    # Haal alle worktree-paden op (sla de eerste/hoofd-repo over)
    local paths
    mapfile -t paths < <(git -C "$REPO_ROOT" worktree list --porcelain \
        | grep '^worktree ' | awk '{print $2}' | tail -n +2)

    if [[ ${#paths[@]} -eq 0 ]]; then
        warn "Geen extra worktrees gevonden. Gebruik eerst: $(basename "$0") add <branch>"
        return 0
    fi

    local pids=()
    for wt_path in "${paths[@]}"; do
        (
            echo "--- [$(basename "$wt_path")] $ $cmd ---"
            cd "$wt_path" && eval "$cmd"
        ) &
        pids+=($!)
    done

    for pid in "${pids[@]}"; do
        wait "$pid"
    done
    ok "Klaar in alle ${#paths[@]} worktrees."
}

# Demo: maak twee tijdelijke worktrees en work er parallel in
cmd_demo() {
    log "Demo: parallel werken in twee worktrees"

    local branch_a="demo/worker-a"
    local branch_b="demo/worker-b"

    # Aanmaken
    cmd_add_new "$branch_a"
    cmd_add_new "$branch_b"

    # Parallel een bestand aanmaken in beide worktrees
    log "Parallel bestanden aanmaken..."
    (
        cd "$WORKTREES_DIR/$branch_a"
        echo "Werk van worker-A op $(date)" > worker-a.txt
        git add worker-a.txt
        git commit -m "chore: worker-A bestand"
        ok "[worker-A] commit klaar"
    ) &
    local pid_a=$!

    (
        cd "$WORKTREES_DIR/$branch_b"
        echo "Werk van worker-B op $(date)" > worker-b.txt
        git add worker-b.txt
        git commit -m "chore: worker-B bestand"
        ok "[worker-B] commit klaar"
    ) &
    local pid_b=$!

    wait "$pid_a" && wait "$pid_b"

    log "Status van alle worktrees:"
    cmd_run_all "git log --oneline -3"

    # Opruimen
    log "Worktrees opruimen..."
    cmd_remove "$branch_a"
    cmd_remove "$branch_b"
    git -C "$REPO_ROOT" branch -D "$branch_a" "$branch_b" 2>/dev/null || true
    ok "Demo klaar."
}

# ── Dispatchen ────────────────────────────────────────────────────────────────
case "${1:-}" in
    add)      cmd_add     "${2:?Branch vereist}"   ;;
    add-new)  cmd_add_new "${2:?Branch vereist}"   ;;
    list)     cmd_list                              ;;
    remove)   cmd_remove  "${2:?Branch vereist}"   ;;
    run-all)  shift; cmd_run_all "$@"              ;;
    demo)     cmd_demo                              ;;
    *)        usage; exit 1                         ;;
esac
