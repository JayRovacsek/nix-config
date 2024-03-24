{ self }:
(with self.nixosModules; [ microvm-guest loki time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
