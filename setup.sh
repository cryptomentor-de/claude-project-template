#!/usr/bin/env bash
# Claude Code Projekt-Setup
# Bindet das passende CLAUDE.md aus dem claude-rules Repo ein.
set -euo pipefail

RULES_REPO="https://github.com/cryptomentor-de/claude-rules.git"
SUBMODULE_DIR=".claude-rules"

# Bereits eingerichtet?
if [ -f "CLAUDE.md" ] && [ -d "$SUBMODULE_DIR" ]; then
  echo "Claude-Regeln bereits eingerichtet."
  echo "Zum Update: git submodule update --remote $SUBMODULE_DIR"
  exit 0
fi

echo ""
echo "Claude Code Projekt-Setup"
echo "========================="
echo ""
echo "Welcher Projekttyp?"
echo "  (1) Entwicklungsprojekt     — Web-Apps, APIs, Bots, Scripts"
echo "  (2) Knowledge/Skill-Projekt — Wissensdatenbanken, Claude-Skills"
echo "  (3) Marketing-Projekt       — Funnels, Ads, Avatare"
echo "  (4) Server-Administration   — Infrastruktur, Ansible, Docker, IaC"
echo ""
read -rp "Typ [1-4]: " choice

case "$choice" in
  1) TYPE="dev" ;;
  2) TYPE="knowledge" ;;
  3) TYPE="marketing" ;;
  4) TYPE="server-admin" ;;
  *)
    echo "Ungültige Auswahl. Abbruch."
    exit 1
    ;;
esac

echo ""
echo "Typ: $TYPE"
echo ""

# Git-Repo prüfen
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Kein Git-Repository gefunden. Bitte zuerst 'git init' ausführen."
  exit 1
fi

# Submodule hinzufügen
echo "Füge Submodule hinzu ($RULES_REPO) ..."
git submodule add "$RULES_REPO" "$SUBMODULE_DIR"
git submodule update --init

# Symlink CLAUDE.md → richtige Datei im Submodule
SOURCE=".claude-rules/$TYPE/CLAUDE.md"
if [ ! -f "$SOURCE" ]; then
  echo "Fehler: $SOURCE nicht gefunden."
  exit 1
fi

ln -sf "$SOURCE" CLAUDE.md
echo "CLAUDE.md → $SOURCE"

# Commit
git add .gitmodules "$SUBMODULE_DIR" CLAUDE.md
git commit -m "chore: Claude-Regeln eingebunden ($TYPE)"

echo ""
echo "Fertig. Claude Code liest jetzt die $TYPE-Regeln."
echo ""
echo "Regeln aktualisieren: git submodule update --remote $SUBMODULE_DIR && git add $SUBMODULE_DIR && git commit -m 'chore: claude-rules aktualisiert'"
