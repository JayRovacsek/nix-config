{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.system.hydraAutoUpgrade;
in
{
  options = {
    system.hydraAutoUpgrade = {
      default = "switch";
      enable = lib.mkEnableOption "periodic hydra-based auto upgrade";
      operation = lib.mkOption {
        type = lib.types.enum [
          "switch"
          "boot"
        ];
      };
      dates = lib.mkOption {
        default = "04:40";
        example = "daily";
        type = lib.types.str;
      };

      instance = lib.mkOption {
        example = "https://hydra.rovacsek.com";
        type = lib.types.str;
      };

      project = lib.mkOption {
        example = "nix-config";
        type = lib.types.str;
      };

      jobset = lib.mkOption {
        default = "main";
        example = "main";
        type = lib.types.str;
      };

      job = lib.mkOption {
        type = lib.types.str;
        default = "nixosConfigurations${config.networking.hostName}";
      };

      oldFlakeRef = lib.mkOption {
        default = null;
        description = ''
          Current system's flake reference

          If non-null, the service will only upgrade if the new config is newer
          than this one's.
        '';
        type = lib.types.nullOr lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> !config.system.autoUpgrade.enable;
        message = ''
          hydraAutoUpgrade and autoUpgrade are mutually exclusive.
        '';
      }
    ];

    systemd.services.nixos-upgrade = {
      description = "NixOS Upgrade";
      restartIfChanged = false;
      serviceConfig.Type = "oneshot";
      unitConfig.X-StopOnRemoval = false;

      script =
        let
          evalUrl = "${cfg.instance}/jobset/${cfg.project}/${cfg.jobset}/latest-eval";
          buildUrl = "${cfg.instance}/job/${cfg.project}/${cfg.jobset}/${cfg.job}/latest";
        in
        (lib.optionalString (cfg.oldFlakeRef != null) ''
          flake="$(${pkgs.curl}/bin/curl -sLH 'accept: application/json' ${evalUrl} | ${pkgs.jq}/bin/jq -r '.flake')"
          echo "New flake: $flake" >&2
          new="$(${pkgs.nix}/bin/nix flake metadata "$flake" --json | ${pkgs.jq}/bin/jq -r '.lastModified')"
          echo "Modified at: $(date -d @$new)" >&2

          echo "Current flake: ${cfg.oldFlakeRef}" >&2
          current="$(${pkgs.nix}/bin/nix flake metadata "${cfg.oldFlakeRef}" --json | jq -r '.lastModified')"
          echo "Modified at: $(date -d @$current)" >&2

          if [ "$new" -le "$current" ]; then
            echo "Skipping upgrade, not newer" >&2
            exit 0
          fi
        '')
        + ''
          profile="/nix/var/nix/profiles/system"
          path="$(${pkgs.curl}/bin/curl -sLH 'accept: application/json' ${buildUrl} | ${pkgs.jq}/bin/jq -r '.buildoutputs.out.path')"

          if [ "$(${pkgs.coreutils}/bin/readlink -f "$profile")" = "$path" ]; then
            echo "Already up to date" >&2
            exit 0
          fi

          echo "Building $path" >&2
          ${pkgs.nix}/bin/nix build --no-link "$path"

          echo "Comparing changes" >&2
          ${pkgs.nvd}/bin/nvd --color=always diff "$profile" "$path"

          echo "Activating configuration" >&2
          "$path/bin/switch-to-configuration" test

          echo "Setting profile" >&2
          ${pkgs.nix}/bin/nix build --no-link --profile "$profile" "$path"

          echo "Adding to bootloader" >&2
          "$path/bin/switch-to-configuration" boot
        '';

      startAt = cfg.dates;
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };
  };
}
