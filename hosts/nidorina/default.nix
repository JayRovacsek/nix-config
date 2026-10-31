{ self, ... }:
{
  imports =
    (with self.nixosModules; [
      acme
      agenix
      alloy
      ddclient
      container-guest
      nginx
      nix-topology
      time
      timesyncd
      tmp-tmpfs
    ])
    ++ [ ./nginx.nix ];

  networking.hostName = "nidorina";

  # Public half of the ssh host keypair; the private key is generated and
  # owned on dragonite at /var/lib/nidorina/etc/ssh/ (never committed to
  # this public repo). Update this value whenever the keypair is rotated.
  programs.ssh.publicHostKeyBase64 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpnTC9YMC9iOE9OZjYyL3RvckJDLyswZS9obzJGMENUNTMzWjVyRzhOSmwgcm9vdEBuaWRvcmluYQo=";

  system.stateVersion = "24.05";
}
