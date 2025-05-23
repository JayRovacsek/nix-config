{
  config,
  lib,
  self,
  ...
}:
let
  inherit (self.lib.microvm) has-microvm is-microvm-host;

  microvm = (has-microvm config) && (is-microvm-host config);
  # Microvms persist state via their machine-id, which is simply 
  # an md5 of hostname.
  microvm-state-dirs = builtins.map (
    x: "/var/lib/${builtins.hashString "md5" x}"
  ) (builtins.attrNames config.microvm.vms);

  agenix-in-use = builtins.hasAttr "age" config;

  # If instances are defined, assume they may be all utilised
  # TODO: check if a filter for enabled is required here in the case of 
  # failure on directory not existing
  authelia = config.services.authelia.instances != { };
  authelia-instances = lib.optionals authelia (
    builtins.attrNames config.services.authelia.instances
  );
in
{
  imports = [ self.inputs.impermanence.nixosModules.impermanence ];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [
        "defaults"
        "mode=755"
      ];
    };
    "/agenix" = lib.mkIf agenix-in-use { neededForBoot = true; };
  };

  boot.tmp = {
    useTmpfs = true;
    cleanOnBoot = true;
  };

  environment.persistence."/persistent" = {
    hideMounts = true;
    directories =
      # Default inclusions
      [
        "/etc/ssh"
        "/nix"
        "/var/lib/nixos"
        "/var/lib/private"
        "/var/lib/systemd"
        "/var/log"
        "/var/tmp"
      ]

      # Optional inclusions depending on configuration
      ## Agenix
      ++ (lib.optional agenix-in-use "/agenix")
      ## Authelia
      ++ (lib.optionals authelia authelia-instances)
      ## Bluetooth
      ++ (lib.optional config.hardware.bluetooth.enable "/var/lib/bluetooth")
      ## ClamAV
      ++ (lib.optional config.services.clamav.daemon.enable "/var/lib/clamav")
      # Magic values as per: https://github.com/NixOS/nixpkgs/blob/e92b6015881907e698782c77641aa49298330223/nixos/modules/services/networking/ddclient.nix#L6C3-L6C10
      ## ddclient
      ++ (lib.optional config.services.ddclient.enable "/var/lib/ddclient")
      ## Deluge
      ++ (lib.optional config.services.deluge.enable config.services.deluge.config.download_location)
      ## Docker
      ++ (lib.optional config.virtualisation.docker.enable "/var/lib/docker")
      ## Greetd
      # Note that tuigreet is assumed; if it is not utilised an empty directory exists
      ++ (lib.optional config.services.greetd.enable "/var/cache/tuigreet")
      ## Grafana
      ++ (lib.optional config.services.grafana.enable config.services.grafana.dataDir)
      # Magic values as per: https://github.com/NixOS/nixpkgs/blob/e92b6015881907e698782c77641aa49298330223/nixos/modules/services/networking/headscale.nix#L10
      ## Headscale
      ++ (lib.optional config.services.headscale.enable "/var/lib/${config.systemd.services.headscale.serviceConfig.StateDirectory}")

      ++ (lib.optionals config.services.xserver.displayManager.lightdm.enable [
        "/var/lib/lightdm"
        "/var/lib/lightdm-data"
      ])
      # Microvms
      ++ (lib.optionals microvm ([ "/var/lib/microvms" ] ++ microvm-state-dirs))
      ## Mysql
      ++ (lib.optional config.services.mysql.enable config.services.mysql.dataDir)
      ## SDDM
      ++ (lib.optionals config.services.displayManager.sddm.enable [
        "/var/lib/sddm"
      ])
      ## Tailscale
      ++ (lib.optional config.services.tailscale.enable "/var/lib/tailscale");
  };
}
