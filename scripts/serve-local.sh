#!/usr/bin/env bash
# Preview the forest locally, restarting/rebuilding whenever trees, assets,
# the theme or forest.local.toml change.
#
# Usage: scripts/serve-local.sh [--static] [port]
#
#   (default)  `forester serve`: live server with backlinks, table of
#              contents, search (Cmd/Ctrl+K) and edit-in-Zed links.
#   --static   Build exactly what GitHub Pages serves (`forester build`, XSLT
#              theme) into .local-build/output and serve it over HTTP. Use
#              this to check the published rendering.
#
# The port defaults to 8080 and must match the url in forest.local.toml.
# Requires the forester fork (see README).
cd "$(dirname "$0")/.."
MODE=serve
if [[ "${1:-}" == "--static" ]]; then MODE=static; shift; fi
PORT="${1:-8080}"
ROOT="$PWD"

snapshot() { find trees assets theme forest.local.toml -type f -exec stat -f '%m %N' {} + 2>/dev/null | sort; }

# forester build always writes to ./output, so build from a scratch directory
# that links to the sources; this keeps output/ for the production build.
build_static() {
  mkdir -p .local-build
  for f in trees assets theme forest.local.toml; do ln -sfn "$ROOT/$f" ".local-build/$f"; done
  (cd .local-build && rm -rf output && forester build --dev forest.local.toml >/dev/null) \
    && echo "Built .local-build/output" || echo "Build failed"
}

start() {
  if [[ "$MODE" == static ]]; then
    build_static
    # Browsers will not apply the XSLT theme to file:// pages, so serve over HTTP.
    python3 -m http.server "$PORT" --bind 127.0.0.1 --directory .local-build/output >/dev/null 2>&1 & PID=$!
  else
    forester serve --port="$PORT" forest.local.toml & PID=$!
  fi
}
trap 'kill $PID 2>/dev/null; exit' INT TERM

start
echo "Serving ($MODE) at http://localhost:$PORT/ (watching for changes)"
last="$(snapshot)"
while sleep 1; do
  now="$(snapshot)"
  if [[ "$now" != "$last" ]]; then
    last="$now"
    if [[ "$MODE" == static ]]; then
      echo "Change detected, rebuilding..."
      build_static
    else
      echo "Change detected, restarting forester..."
      kill "$PID" 2>/dev/null; wait "$PID" 2>/dev/null
      start
    fi
  fi
done
