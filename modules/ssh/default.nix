{ lib, ... }:
let
  # Shared host inventory (common/config.nix). Imported directly rather
  # than via `self` so this module evaluates in every context that imports
  # it (host configs pass self through specialArgs; the probe configs in
  # lib/options.nix do not).
  inventory = import ../../common/config.nix { };

  # System-wide ssh known_hosts for every host that has declared a public
  # key. Replaces the former programs.ssh.publicHostKeyBase64 option:
  # nixpkgs' programs.ssh.knownHosts is the standard mechanism, and ssh
  # clients - including nix remote builders with publicHostKey = null -
  # validate against the resulting /etc/ssh/ssh_known_hosts. Reading the
  # flat inventory means a single host never evaluates the other hosts'
  # configurations.
  knownHosts = lib.mapAttrs' (
    name: host:
    lib.nameValuePair name {
      publicKey = host.publicHostKey;
      extraHostNames = lib.unique ((map (ip: ip.fqdn) host.ips) ++ (map (ip: ip.address) host.ips));
    }
  ) (lib.filterAttrs (_: host: host.publicHostKey or null != null) inventory.hosts);
in
{
  age = {
    identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];

    secrets = {
      type-a-1 = {
        file = ../../secrets/ssh/type-a-1.age;
        owner = "jay";
      };
      type-c-1 = {
        file = ../../secrets/ssh/type-c-1.age;
        owner = "jay";
      };
      type-a-2 = {
        file = ../../secrets/ssh/type-a-2.age;
        owner = "jay";
      };
      type-c-2 = {
        file = ../../secrets/ssh/type-c-2.age;
        owner = "jay";
      };
    };
  };

  programs.ssh.knownHosts = knownHosts;
}
