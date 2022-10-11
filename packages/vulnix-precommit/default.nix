{ stdenv, pkgs, lib }:
with lib;
let
  name = "vulnix-precommit";
  pname = "vulnix-precommit";
  version = "0.0.1";
  meta = {
    description =
      "A simple shell wrapper for vulnix to check for existence of spicy vulns on a system";
    platforms = platforms.unix;
  };

  vulnix-precommit-wrapped = pkgs.writeShellScriptBin "vulnix-precommit" ''
    SEVERITY_TOLERANCE=$1

    if ! [[ $SEVERITY_TOLERANCE =~ ^[0-9]+(\.[0-9]+)?$ ]]; 
       then echo "ERROR: First parameter is not a number!" >&2; exit 1 
    fi

    VULNS=$(vulnix -w ./.vulnix/allowlist.toml --system --json)
    VULN_COUNT=$(echo $VULNS | jq --arg sev $SEVERITY_TOLERANCE '[.[] | select(.cvssv3_basescore | to_entries | .[].value | . >= ($sev | tonumber))] | length')

    if [ $VULN_COUNT -eq 0 ]; then
        echo "Detected no significant vulnerabilities. Heck yeah!"
        exit 0
    else
        echo ""
        echo "Detected $VULN_COUNT derivations with a possible CVE greater than or equal to severity $1!"
        echo "Note that these should be checked for reachability and/or build-time ephemerality and allowlisted if determined to be low/incorrect risk"
        echo ""

        echo "Run the following command to identify and remediate vulnerabilities:"
        echo ""
        echo "vulnix --system --json | jq -C --arg sev $SEVERITY_TOLERANCE '[.[] | select(.cvssv3_basescore | to_entries | .[].value | . >= (\$sev | tonumber))] | length' | less -R"
        echo "OR to write to a local file to review:"
        echo "vulnix --system --json | jq --arg sev $SEVERITY_TOLERANCE '[.[] | select(.cvssv3_basescore | to_entries | .[].value | . >= (\$sev | tonumber))]' > vulns.json"
        exit 1
    fi;
  '';

  phases = [ "installPhase" "fixupPhase" ];

in stdenv.mkDerivation {
  inherit name pname version meta phases;

  buildInputs = [ vulnix-precommit-wrapped ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${vulnix-precommit-wrapped}/bin/vulnix-precommit $out/bin
  '';
}
