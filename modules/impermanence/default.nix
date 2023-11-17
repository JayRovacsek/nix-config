{ config, lib, ... }:
let
  inherit (config.flake.lib.microvm)
    has-microvm is-microvm-host is-microvm-guest;

  persist-microvm = if (has-microvm config) then
    builtins.any (x: x) [ (is-microvm-host config) (is-microvm-guest config) ]
  else
    false;

  # normal-users = lib.filterAttrs (n: v: v.isNormalUser) config.users.users;

in {
  environment.persistence."/persistent" = {
    hideMounts = true;
    directories =
      # Default inclusions
      [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/private"
        "/var/lib/systemd"
      ]

      # Optional inclusions depending on configuration
      ++ (lib.optional config.services.clamav.daemon.enable "/var/lib/clamav")
      ++ (lib.optional config.virtualisation.docker.enable "/var/lib/docker")
      ++ (lib.optionals config.services.xserver.displayManager.lightdm.enable [
        "/var/lib/lightdm"
        "/var/lib/lightdm-data"
      ]) ++ (lib.optional config.virtualisation.docker.enable "/var/lib/docker")
      ++ (lib.optional persist-microvm "/var/lib/microvms")
      ++ (lib.optionals config.services.xserver.displayManager.sddm.enable
        [ "/var/lib/sddm" ])
      ++ (lib.optional config.services.tailscale.enable "/var/lib/tailscale");
    files = [ "/etc/machine-id" ];

    # TODO: Look into if inf recursion can be avoided here: 
    # doing this per user is kinda :sad-panda:

    # users = builtins.mapAttrs (_: _: {
    #   directories = [
    #     "dev"
    #     "Nextcloud"
    #     "Pictures"
    #     "Videos"
    #     {
    #       directory = ".gnupg";
    #       mode = "0700";
    #     }
    #     {
    #       directory = ".ssh";
    #       mode = "0700";
    #     }
    #     {
    #       directory = ".local/share/keyrings";
    #       mode = "0700";
    #     }
    #     ".local/share/direnv"
    #   ];
    # }) normal-users;

    # As an MVP example
    users.jay = {
      directories = [
        "dev"
        "Nextcloud"
        "Pictures"
        "Videos"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        ".local/share/direnv"
      ];
    };
  };
}
