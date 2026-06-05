#!/usr/bin/env bash
# Smoke tests for scripts/scaffold_vault.py. No Claude required.
# Exits 0 on success, 1 on first failure.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SCAFFOLD="$REPO_ROOT/scripts/scaffold_vault.py"
TMP="$(mktemp -d)"
trap "rm -rf $TMP" EXIT

green() { printf "\033[32m%s\033[0m\n" "$1"; }
red()   { printf "\033[31m%s\033[0m\n" "$1"; }
fail()  { red "FAIL: $1"; exit 1; }

# ── Test 1: basic scaffold with charter_seed ──────────────────────────────────
echo "Test 1: scaffold with charter_seed"
cat > "$TMP/config1.json" <<EOF
{
  "vault_path": "$TMP/vault1",
  "project_name": "TestOne",
  "charter_seed": "A test project for the smoke tests."
}
EOF
python3 "$SCAFFOLD" --config "$TMP/config1.json" --summary-only > "$TMP/out1.log"

[[ -d "$TMP/vault1/00_Index" ]]                            || fail "no 00_Index"
[[ -d "$TMP/vault1/10_Projects/TestOne" ]]                 || fail "no project dir"
[[ -f "$TMP/vault1/_Bases/Risks.base" ]]                   || fail "no Risks base"
[[ -f "$TMP/vault1/_Templates/Risk.md" ]]                  || fail "no Risk template"
[[ -f "$TMP/vault1/10_Projects/TestOne/Project Charter.md" ]] || fail "no charter"

grep -q "A test project for the smoke tests" "$TMP/vault1/10_Projects/TestOne/Project Charter.md" \
  || fail "charter_seed not in charter"
green "  ✓ basic scaffold + charter_seed"

# ── Test 2: idempotent re-run ─────────────────────────────────────────────────
echo "Test 2: idempotent re-run (should skip all)"
python3 "$SCAFFOLD" --config "$TMP/config1.json" --summary-only > "$TMP/out2.log"
grep -q "created 0 paths" "$TMP/out2.log" || fail "expected 0 created on re-run"
green "  ✓ idempotent re-run"

# ── Test 3: add second project to existing vault ──────────────────────────────
echo "Test 3: add second project to existing vault"
cat > "$TMP/config2.json" <<EOF
{
  "vault_path": "$TMP/vault1",
  "project_name": "TestTwo",
  "charter_seed": "Second test project."
}
EOF
python3 "$SCAFFOLD" --config "$TMP/config2.json" --summary-only > "$TMP/out3.log"

[[ -d "$TMP/vault1/10_Projects/TestTwo" ]] || fail "no TestTwo project dir"

# HOME.md should have BOTH projects
grep -q "TestOne" "$TMP/vault1/00_Index/HOME.md" || fail "TestOne missing from HOME"
grep -q "TestTwo" "$TMP/vault1/00_Index/HOME.md" || fail "TestTwo missing from HOME (splice failed)"

# AGENTS.md should be rewritten as project-agnostic
grep -q "hosting multiple projects" "$TMP/vault1/00_Index/AGENTS.md" \
  || fail "AGENTS.md not rewritten as project-agnostic"

# Existing TestOne files should be untouched
testone_charter_mtime_a=$(stat -c %Y "$TMP/vault1/10_Projects/TestOne/Project Charter.md" 2>/dev/null \
                          || stat -f %m "$TMP/vault1/10_Projects/TestOne/Project Charter.md")
sleep 1
python3 "$SCAFFOLD" --config "$TMP/config2.json" --summary-only > /dev/null
testone_charter_mtime_b=$(stat -c %Y "$TMP/vault1/10_Projects/TestOne/Project Charter.md" 2>/dev/null \
                          || stat -f %m "$TMP/vault1/10_Projects/TestOne/Project Charter.md")
[[ "$testone_charter_mtime_a" == "$testone_charter_mtime_b" ]] \
  || fail "TestOne charter modified during TestTwo scaffold"

green "  ✓ existing-vault splice + AGENTS rewrite + idempotent on existing project"

# ── Test 4: verify subcommand on a clean vault ────────────────────────────────
echo "Test 4: verify clean vault"
python3 "$SCAFFOLD" verify "$TMP/vault1" > "$TMP/out4.log" 2>&1
grep -q "^OK" "$TMP/out4.log" || fail "verify should report OK"
green "  ✓ verify on clean vault"

# ── Test 5: verify catches invalid type ───────────────────────────────────────
echo "Test 5: verify catches invalid type frontmatter"
cat > "$TMP/vault1/10_Projects/TestOne/Risks/Bad.md" <<EOF
---
type: Risk
project: TestOne
---
# Bad — capital R
EOF
set +e
python3 "$SCAFFOLD" verify "$TMP/vault1" > "$TMP/out5.log" 2>&1
rc=$?
set -e
[[ "$rc" == "1" ]] || fail "verify should exit 1 on invalid type, got $rc"
grep -q "invalid type \`Risk\`" "$TMP/out5.log" || fail "verify should call out the bad type"
green "  ✓ verify catches type case-mismatch"

# ── Test 6: skeleton mode (no charter_seed) ───────────────────────────────────
echo "Test 6: skeleton mode (empty charter blockquote)"
cat > "$TMP/config3.json" <<EOF
{
  "vault_path": "$TMP/vault-skel",
  "project_name": "Skeleton"
}
EOF
python3 "$SCAFFOLD" --config "$TMP/config3.json" --summary-only > /dev/null
grep -q "One-line pitch (fill in)" "$TMP/vault-skel/10_Projects/Skeleton/Project Charter.md" \
  || fail "skeleton charter should have placeholder blockquote"
green "  ✓ skeleton mode produces blank charter"

green ""
green "All smoke tests passed."
