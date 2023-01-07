{ self }:
let
  inherit (self.inputs.stable.lib) recursiveUpdate;
  inherit (self.outputs.nixosConfigurations) rpi1 rpi2;
  sd-configurtations = [ rpi1 rpi2 ];

  built-derivations = builtins.map
    (x: { "${x.config.networking.hostName}" = x.config.system.build.sdImage; })
    sd-configurtations;

  images = builtins.foldl' recursiveUpdate { } built-derivations;

in images
