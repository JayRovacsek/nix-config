{ self }:
(with self.nixosModules; [
  blocky
  microvm-guest
  systemd-networkd
  time
  timesyncd
]) ++ (with self.inputs; [ microvm.nixosModules.microvm ])
