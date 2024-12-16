{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (self) common;
  inherit (self.common.home-manager-module-sets) base hyprland-desktop-minimal;
  inherit (self.lib) merge;

  builder = common.users.builder {
    inherit config pkgs;
    modules = base;
  };

  jay = common.users.jay {
    inherit config pkgs;
    modules =
      hyprland-desktop-minimal
      ++ (with self.homeManagerModules; [
        impermanence
        mako
        waybar
      ]);
  };

  user-configs = merge [
    builder
    jay
  ];

in
{
  inherit (user-configs) users home-manager;

  imports = with self.nixosModules; [
    ./disk-config.nix
    agenix
    generations
    gnupg
    grafana-agent
    greetd
    hyprland
    i18n
    impermanence
    journald
    lorri
    minimal-boot-filesystems
    nix
    nix-topology
    openssh
    sudo
    systemd-networkd
    time
    timesyncd
    zsh
  ];

  age = {
    identityPaths = [
      "/agenix/id-ed25519-wireless-primary"
    ];

    secrets.wireless-env = {
      file = ../../secrets/wireless/wireless-iot.env.age;
      mode = "0400";
      symlink = false;
    };
  };

  boot = {
    # Set the headphone jack as the default output
    extraModprobeConfig = ''
      options snd_bcm2835 enable_headphones=1
    '';

    kernelParams = [
      "8250.nr_uarts=1"
      "boot.shell_on_fail"
      "cma=256M"
      "console=tty1"
    ];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    jellyfin-media-player
  ];

  networking = {
    hostName = lib.mkForce "wigglytuff";
    hostId = "d2a7b80b";
    wireless = {
      enable = true;
      secretsFile = config.age.secrets.wireless-env.path;
      interfaces = [ "wlan0" ];
      networks."Ooo Ooo Net IOT".pskRaw = "ext:PSK";
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  programs.fuse.userAllowOther = true;

  services = {
    openssh.settings.PermitRootLogin = lib.mkForce "no";

    timesyncd.servers = lib.mkForce [
      "137.92.140.80" # -> ntp.ise.canberra.edu.au
      "138.194.21.154" # -> ntp.mel.nml.csiro.au
      "129.6.15.28" # -> time-a-g.nist.gov
      "129.6.15.29" # -> time-b-g.nist.gov
    ];
  };
}
