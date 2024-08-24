{ self }:
let
  inherit (self.inputs.nixpkgs) lib;

  has-microvm = builtins.hasAttr "microvm";

  is-microvm-host =
    config: (has-microvm config) && builtins.hasAttr "vms" config.microvm;

  is-microvm-guest =
    config: (has-microvm config) && builtins.hasAttr "hypervisor" config.microvm;

  is-recursive-microvm =
    config: (is-microvm-host config) && (is-microvm-guest config);

  bridge-networks =
    config:
    builtins.map (x: x.netdevConfig.Name) (
      builtins.filter (x: x.netdevConfig.Kind == "bridge" && x.enable) (
        builtins.attrValues config.systemd.network.netdevs
      )
    );

  generate-journald-share =
    hostName:
    # The below is utilised to ensure our host has access to journald logs as per
    # this: https://astro.github.io/microvm.nix/faq.html#how-to-centralize-logging-with-journald
    {
      # On the host
      source = "/var/lib/microvms/${hostName}/journal";
      # In the MicroVM
      mountPoint = "/var/log/journal";
      tag = "journal";
      proto = "virtiofs";
      socket = "journal.sock";
    };

  generate-tailscale-share =
    source:
    let
      parts = lib.strings.splitString "/" source;
      filteredParts = lib.lists.sublist 0 ((builtins.length parts) - 1) parts;
      mountPoint = lib.strings.concatStringsSep "/" filteredParts;

    in
    {
      inherit source mountPoint;
      proto = "virtiofs";
      tag = "tailscale";
      socket = "tailscale-identity-file.socket";
    };

in
{
  inherit
    has-microvm
    is-microvm-host
    is-microvm-guest
    is-recursive-microvm
    bridge-networks
    generate-journald-share
    generate-tailscale-share
    ;
}
