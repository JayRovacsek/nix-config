{ self }:
(with self.nixosModules; [ microvm-guest nextcloud time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
