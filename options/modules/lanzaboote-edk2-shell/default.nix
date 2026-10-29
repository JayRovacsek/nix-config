# Deploys a Lanzaboote-signed EDK2 UEFI Shell boot entry to the ESP so the
# firmware shell stays reachable for Secure Boot recovery when the UKIs fail
# to boot. The shell binary is signed with Lanzaboote's keys at activation
# time, so this module requires boot.lanzaboote.enable.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.boot.lanzaboote-edk2-shell;

  esp = config.boot.loader.efi.efiSysMountPoint;
  lanzaboote = config.boot.lanzaboote;

  shell = pkgs.edk2-uefi-shell;

  deployShell = pkgs.writeShellScript "deploy-edk2-shell" ''
    set -euo pipefail

    esp=${lib.escapeShellArg esp}

    if ! ${pkgs.util-linux}/bin/mountpoint -q "$esp"; then
      echo "ESP is not mounted at $esp" >&2
      exit 1
    fi

    destination="$esp/efi/edk2-uefi-shell/shell.efi"
    entry="$esp/loader/entries/edk2-uefi-shell.conf"
    tmp="$(${pkgs.coreutils}/bin/mktemp)"

    trap '${pkgs.coreutils}/bin/rm -f "$tmp"' EXIT

    ${pkgs.sbsigntool}/bin/sbsign \
      --key ${lib.escapeShellArg (toString lanzaboote.privateKeyFile)} \
      --cert ${lib.escapeShellArg (toString lanzaboote.publicKeyFile)} \
      --output "$tmp" \
      ${shell}/shell.efi

    ${pkgs.coreutils}/bin/install -D -m 0644 \
      "$tmp" "$destination"

    ${pkgs.coreutils}/bin/install -D -m 0644 \
      /dev/stdin "$entry" <<'ENTRY'
    title EDK2 UEFI Shell
    efi /efi/edk2-uefi-shell/shell.efi
    sort-key o_edk2-uefi-shell
    ENTRY
  '';
in
{
  options.boot.lanzaboote-edk2-shell.enable = lib.mkEnableOption ''
    deployment of a Lanzaboote-signed EDK2 UEFI Shell boot entry to the ESP
  '';

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lanzaboote.enable;
        message = "The EDK2 shell deployment requires Lanzaboote.";
      }
    ];

    systemd.services.lanzaboote-edk2-shell = {
      description = "Install signed EDK2 UEFI Shell boot entry";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = deployShell;
      };
    };
  };
}
