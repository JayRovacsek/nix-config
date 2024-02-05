{ self }:
(with self.nixosModules; [ headscale microvm-guest time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
