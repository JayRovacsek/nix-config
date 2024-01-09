{ self }:
(with self.nixosModules; [ microvm-guest radarr time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
