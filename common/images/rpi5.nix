{ self }:
let
  inherit (self.inputs) nixos-raspberrypi;

  inherit (self.common.package-sets) aarch64-linux-unstable;
  inherit (aarch64-linux-unstable) system identifier;

  modules = self.common.modules.${identifier} ++ [
    self.nixosModules.raspberry-pi-5
    {
      # This is just a stub to enable hydra evaluation
      fileSystems."/" = {
        device = "none";
        fsType = "tmpfs";
      };
      networking.hostName = "rpi5";

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "yes";
          PasswordAuthentication = false;
        };
      };

      system.stateVersion = "24.11";

      users.users.root.openssh.authorizedKeys.keys =
        self.common.config.services.openssh.public-keys;
    }
  ];

  specialArgs = {
    inherit self;
  };
in
nixos-raspberrypi.lib.nixosSystem {
  inherit
    modules
    specialArgs
    system
    ;
}
