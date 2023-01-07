{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  home-manager-modules = with common.home-manager-modules; [
    alacritty
    bat
    dconf
    dircolours
    direnv
    emacs
    firefox
    fzf
    git
    jq
    lsd
    man
    rofi
    starship
    vscodium
    zsh
  ];
  jay = common.users.jay { inherit config pkgs home-manager-modules; };

in {
  # TODO: wrap this far better to make it consumable.
  inherit (jay) users home-manager;
  recursive = {
    inherit flake;
    config = config // { passthru = { }; };
  };

  age = {
    secrets."tailscale-dns-preauth-key" = {
      file = ../../secrets/tailscale/preauth-dns.age;
      mode = "0400";
    };
    identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];
  };

  services.tailscale.tailnet = "admin";

  imports =
    [ ./hardware-configuration.nix ./modules.nix ./system-packages.nix ];

  networking = {
    hostName = "alakazam";
    hostId = "ef26b1be";
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  system.stateVersion = "22.11";
}
