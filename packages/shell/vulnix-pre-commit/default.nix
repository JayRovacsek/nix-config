{
  pkgs,
  ...
}:
# A pre-commit style wrapper around vulnix. All runtime dependencies are
# interpolated as absolute store paths so they are explicitly required in the
# wrapper's closure rather than assumed to be on the caller's PATH.
pkgs.writeShellScriptBin "vulnix-pre-commit" ''
  set -euo pipefail

  SEVERITY_TOLERANCE=''${1:-}
  TARGET=''${2:-result}

  if [ -z "$SEVERITY_TOLERANCE" ]; then
      echo "ERROR: First parameter (severity tolerance) is required!" >&2
      echo "Usage: vulnix-pre-commit <severity-tolerance> [target]" >&2
      echo "  severity-tolerance  minimum CVSS v3 base score (number) that fails the check" >&2
      echo "  target              derivation or store path to scan (default: ./result)" >&2
      exit 1
  fi

  if ! [[ $SEVERITY_TOLERANCE =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
      echo "ERROR: First parameter is not a number!" >&2
      exit 1
  fi

  # vulnix exits 0 with nothing to report, 1 with only whitelisted matches
  # and 2 when reportable vulnerabilities exist; anything else is a real
  # error. The allowlist is only passed when it actually exists.
  VULNIX_ARGS=(--json "$TARGET")
  if [ -f ./.vulnix/allowlist.toml ]; then
      VULNIX_ARGS=(-w ./.vulnix/allowlist.toml "''${VULNIX_ARGS[@]}")
  fi

  VULNS=$(${pkgs.vulnix}/bin/vulnix "''${VULNIX_ARGS[@]}") || rc=$?
  rc=''${rc:-0}
  if [ "$rc" -gt 2 ] || [ -z "$VULNS" ]; then
      echo "ERROR: vulnix failed with exit code $rc" >&2
      exit 1
  fi

  # Count each derivation at most once, regardless of how many CVEs at or
  # above the tolerance it carries, and skip entries without a score.
  JQ_FILTER='[.[] | select(.cvssv3_basescore != null and any(.cvssv3_basescore[]; . >= ($sev | tonumber)))]'
  VULN_COUNT=$(echo "$VULNS" | ${pkgs.jq}/bin/jq --arg sev "$SEVERITY_TOLERANCE" "$JQ_FILTER | length")

  if [ "$VULN_COUNT" -eq 0 ]; then
      echo "Detected no significant vulnerabilities. Heck yeah!"
      exit 0
  fi

  echo ""
  echo "Detected $VULN_COUNT derivations with a possible CVE greater than or equal to severity $SEVERITY_TOLERANCE!"
  echo "Note that these should be checked for reachability and/or build-time ephemerality and allowlisted if determined to be low/incorrect risk"
  echo ""

  echo "Run the following command to identify and remediate vulnerabilities:"
  echo ""
  echo "${pkgs.vulnix}/bin/vulnix ''${VULNIX_ARGS[*]} | ${pkgs.jq}/bin/jq -C --arg sev $SEVERITY_TOLERANCE '$JQ_FILTER' | less -R"
  echo "OR to write to a local file to review:"
  echo "${pkgs.vulnix}/bin/vulnix ''${VULNIX_ARGS[*]} | ${pkgs.jq}/bin/jq --arg sev $SEVERITY_TOLERANCE '$JQ_FILTER' > vulns.json"
  exit 1
''
