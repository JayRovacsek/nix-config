{ config, pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  configs = {
    x86_64-darwin = import ./x86_64-darwin.nix;
    x86_64-linux = import ./x86_64-linux.nix;
    aarch64-linux = import ./x86_64-linux.nix;
  };
in {
  time.timeZone = "Australia/Sydney";
  services = if isDarwin then { } else configs.${pkgs.system};
}
