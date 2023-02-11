{ self ? null, system ? null, pkgs ? import <nixpkgs> { } }:
let
  inherit (pkgs) callPackage;
  inherit (pkgs.stdenv) isLinux isDarwin isx86_64;
  inherit (pkgs.lib) recursiveUpdate;

  isFlake = !(builtins.isNull self) && !(builtins.isNull system);

  # Amethyst only evaluates on darwin, because the context of this is both
  # via NUR and a flake, the below is done to hack this requirement
  darwinPackages = if isDarwin then {
    amethyst = callPackage ./amethyst { };
    velociraptor-bin = callPackage ./velociraptor-bin { };
  } else
    { };

  # As above, velociraptor isn't build upstream for aarch.
  # would be cool to resolve this.
  x64LinuxPackages = if isLinux && isx86_64 then {
    velociraptor-bin = callPackage ./velociraptor-bin { };
  } else
    { };

  flakePackages = if isFlake then
    let inherit (self.inputs) terranix;
    in {
      linode = terranix.lib.terranixConfiguration {
        inherit system;
        modules =
          [ { config._module.args = { inherit self; }; } ../terranix/linode ];
      };
    }
  else
    {

    };

  extraPackages = darwinPackages // x64LinuxPackages // flakePackages;

  packages = {
    better-english = callPackage ./better-english { };
    # Disable until I can resolve this
    # netextender = callPackage ./netextender { };
    trdsql-bin = callPackage ./trdsql-bin { };
    vulnix-pre-commit = callPackage ./vulnix-pre-commit { };
  } // extraPackages;

  # Understand the context of where we're at - if in a flake then
  # merge the raspberry pi images in also to be a possible build option.
in if builtins.isNull self then
  packages
else
  recursiveUpdate self.outputs.common.images packages
