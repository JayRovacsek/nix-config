{ self }:
(with self.nixosModules; [ deluge microvm-guest time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
