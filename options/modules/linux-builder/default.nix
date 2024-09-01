{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs) stdenv;

  cfg = config.nix.linux-builder;
  builder-config = builtins.head (builtins.head cfg.config.imports).imports;

in
with lib;
{
  config = mkIf (stdenv.isDarwin && cfg.enable) {
    nix.buildMachines = [
      {
        hostName = "linux-builder";
        sshUser = "builder";
        sshKey = "/etc/nix/builder_ed25519";
        system = "${stdenv.hostPlatform.uname.processor}-linux";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=";
        inherit (cfg) maxJobs supportedFeatures;

        systems = lib.unique (
          [ "${stdenv.hostPlatform.uname.processor}-linux" ]
          ++ builder-config.boot.binfmt.emulatedSystems
        );
      }
    ];
  };
}
