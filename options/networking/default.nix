{ lib, pkgs, config, ... }:
with lib;
let cfg = config.networking.domain;
in {
  options.networking = {
    localDomain = mkOption {
      type = types.str;
      # This is used rather than the networking.domain option to
      # explicitly define local domains rather than general domains.
      # Overriding the original would probably not be wise.
      default = "lan";
      description =
        "The domain. It can be left empty if it is auto-detected through DHCP.";
    };
  };
}
