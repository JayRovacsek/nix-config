{ self }:
(with self.nixosModules; [ lidarr microvm-guest time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
