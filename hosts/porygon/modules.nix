{ self }:
(with self.nixosModules; [ palworld microvm-guest time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
