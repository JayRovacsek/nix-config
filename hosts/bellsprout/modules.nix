{ self }:
(with self.nixosModules; [ microvm-guest sonarr time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
