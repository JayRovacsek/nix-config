{ lib, self, ... }: {
  imports = with self.nixosModules; [ disable-assertions nix-topology ];

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = "nix-command flakes";
      http-connections = 0;
      sandbox = true;
      trusted-users = [ "@wheel" ];
    };
  };

  networking = {
    firewall.allowedTCPPorts = [ 22 ];
    hostName = "ditto";
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
      };
    };
    timesyncd.servers = [
      "0.au.pool.ntp.org"
      "1.au.pool.ntp.org"
      "2.au.pool.ntp.org"
      "3.au.pool.ntp.org"
    ];
  };

  system.stateVersion = "24.05";

  time.timeZone = "Australia/Sydney";

  users.users.root.openssh.authorizedKeys.keys =
    self.common.networking.services.openssh.public-keys;

  # Everything beyond here is just space saving. Within REPL utilise:
  # nixosConfigurations.HOST.options.environment.systemPackages.definitionsWithLocations
  # To understand where or what might be causing size costs.
  #
  # Alternatively nix-tree:
  # nix-tree .#nixosConfigurations.HOST.config.system.build.toplevel --derivation

  boot.enableContainers = false;

  documentation.enable = false;

  programs = {
    dconf.enable = lib.mkDefault false;
    nano.enable = false;
  };

  xdg = {
    icons.enable = false;
    sounds.enable = false;
  };
}
