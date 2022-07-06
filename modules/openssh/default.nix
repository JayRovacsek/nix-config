{ config, pkgs, lib, ... }:
let
  agenixPresent = builtins.hasAttr "age" config;

  users = builtins.filter (x: x.isNormalUser)
    (builtins.attrValues config.users.users);

  sshKeys = builtins.foldl' (a: b: a // b) { } (builtins.map (user:
    (builtins.foldl' (a: b: a // b) { } (builtins.map (x: {
      "${lib.strings.removeSuffix ".age" x}" = {
        file = ../../secrets/${x};
        mode = "0400";
        owner = config.services.headscale.user;
      };
    }) (builtins.filter (z: (lib.strings.hasInfix "id-ed25519" z))
      (builtins.attrNames (builtins.readDir ../../secrets)))))) users);
in {
  age.secrets = sshKeys;

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
