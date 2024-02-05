{ self }:
(with self.nixosModules; [ microvm-guest prowlarr time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
