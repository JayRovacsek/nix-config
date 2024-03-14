{ self }:
(with self.nixosModules; [ authelia microvm-guest time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
