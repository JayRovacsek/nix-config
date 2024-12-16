{ self }:
let
  inherit (self.common.system) unstable-system;

  inherit (self.common.package-sets) aarch64-linux-unstable;
  inherit (aarch64-linux-unstable) system identifier pkgs;

  modules = self.common.modules.${identifier} ++ [
    self.nixosModules.raspberry-pi-4
    {
      networking.hostName = "rpi4";

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
unstable-system {
  inherit
    modules
    pkgs
    specialArgs
    system
    ;
}
