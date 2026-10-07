#!/usr/bin/env bash
# Create the GitHub repo, push, and enable GitHub Pages (Actions source).
# Requires a working `gh auth login`.
set -euo pipefail
cd "$(dirname "$0")/.."
OWNER=threewisemonkeys-as
REPO=wn
gh repo view "$OWNER/$REPO" >/dev/null 2>&1 || \
  gh repo create "$OWNER/$REPO" --public --description "Forest of evergreen notes (Forester)"
git push -u origin main
gh api -X POST "repos/$OWNER/$REPO/pages" -f build_type=workflow >/dev/null 2>&1 || \
  gh api -X PUT "repos/$OWNER/$REPO/pages" -f build_type=workflow
gh workflow run deploy.yml --repo "$OWNER/$REPO" --ref main || true
echo "Site will be live at https://$OWNER.github.io/$REPO/ once the Actions run finishes."
