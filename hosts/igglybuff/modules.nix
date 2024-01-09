{ self }:
(with self.nixosModules; [ blocky microvm-guest time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
