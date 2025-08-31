{
  modulesPath,
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares.nix"
  ]
  ++ (with self.nixosModules; [
    bluetooth
    cinnamon
    fonts
    generations
    gnupg
    home-manager
    i18n
    lix
    nix
    time
    timesyncd
    tmp-tmpfs
    zramSwap
    zsh
  ]);

  environment = {
    etc = {
      "calamares/modules/locale.conf".source = pkgs.writers.writeYAML "locale.conf" {
        keyboardLayout = "us";
        locale = "en_AU.UTF-8";
        timezone = "Australia/Sydney";
      };
      "calamares/modules/packages.conf".source =
        pkgs.writers.writeYAML "packages.conf"
          {
            default = "cinnamon";
          };
      "calamares/modules/unfree.conf".source = pkgs.writers.writeYAML "unfree.conf" {
        packageChoice = "unfree";
      };
      "calamares/modules/users.conf".source = pkgs.writers.writeYAML "users.conf" {
        doAutologin = true;
        doReusePassword = true;
      };
    };
    systemPackages = with pkgs; [
      google-chrome
      netflix
      spotify
      vscode
    ];
  };

  nix.settings = {
    substituters = lib.mkForce [ ];
    trusted-public-keys = lib.mkForce [
    ];
  };

  networking.hostName = "grimer";

  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";
  };

  system.stateVersion = "25.11";
}
