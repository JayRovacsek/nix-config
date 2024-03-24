{ self }:
(with self.nixosModules; [ flaresolverr microvm-guest time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
