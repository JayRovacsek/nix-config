{ self }:
(with self.nixosModules; [ acme ddclient microvm-guest nginx time timesyncd ])
++ (with self.inputs; [ microvm.nixosModules.microvm ])
