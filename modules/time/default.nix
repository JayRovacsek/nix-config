{ config, pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  configs = {
    x86_64-darwin = import ./x86_64-darwin.nix;
    x86_64-linux = import ./x86_64-linux.nix;
    aarch64-linux = import ./x86_64-linux.nix;
  };
  appliedConfig = configs.${pkgs.system};
in {
  ## Todo; fix infinite recursion occuring here - the below should instead be the applied config rather than this static set that is only applicable to linux.
  time.timeZone = "Australia/Sydney";
  services.timesyncd = {
    servers = [
      "0.au.pool.ntp.org"
      "1.au.pool.ntp.org"
      "2.au.pool.ntp.org"
      "3.au.pool.ntp.org"
    ];
  };
}

