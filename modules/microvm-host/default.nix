{
  config,
  lib,
  self,
  ...
}:
let
  inherit (self.lib.microvm) is-microvm-host;

  path-file = s: lib.last (lib.splitString "/" s);

  enable = is-microvm-host config;

  microvmHostnames =
    if enable then (builtins.attrNames config.microvm.vms) else [ ];

  # Assumption vms value matches that of a nixosConfiguration
  # TODO: add guard to check for attribute
  microvms = builtins.map (x: self.nixosConfigurations.${x}) microvmHostnames;

  agenix-rules = builtins.foldl' (
    acc: microvm:
    acc
    ++ (builtins.map (
      y: "C /agenix/${microvm.config.systemd.machineId}/${path-file y} - - - - ${y}"
    ) microvm.config.age.identityPaths)
  ) [ ] microvms;

  journald-rules = builtins.map (
    microvm:
    let
      inherit (microvm.config.systemd) machineId;
      inherit (microvm.config.networking) hostName;
    in
    # creates a symlink of each MicroVM's journal under the host's /var/log/journal
    "L+ /var/log/journal/${machineId} - - - - /var/lib/microvms/${hostName}/journal/${machineId}"
  ) microvms;

  services = builtins.foldl' (
    acc: n:
    acc
    // {
      # Required to ensure a microvm doesn't start without required services being loaded
      # correctly before it starts (otherwise leads to failure cases)
      "microvm@${n}" =
        let
          vm-dependencies = [
            "microvm-macvtap-interfaces@${n}.service"
            "microvm-pci-devices@${n}.service"
            "microvm-tap-interfaces@${n}.service"
            "microvm-virtiofsd@${n}.service"
          ];
        in
        {
          after = vm-dependencies;
          wants = vm-dependencies;
        };

      # Required to ensure devices that are depended on by microvms are 
      # correctly started prior to virtual device services attempting to load
      "microvm-macvtap-interfaces@" =
        let
          interface-dependencies = builtins.map (
            vlan: "sys-devices-virtual-net-${vlan.name}.device"
          ) config.microvm.macvlans;
        in
        {
          after = interface-dependencies;
          wants = interface-dependencies;
        };

    }
  ) { } (builtins.attrNames config.microvm.vms);

in
{
  imports = [
    self.inputs.microvm.nixosModules.host
    ../systemd-networkd
    ../../options/microvm-host
  ];

  nix.settings = {
    substituters = [ "https://microvm.cachix.org/" ];
    trusted-public-keys = [
      "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
    ];
  };

  systemd = {
    inherit services;
    tmpfiles.rules = agenix-rules ++ journald-rules;
  };
}
