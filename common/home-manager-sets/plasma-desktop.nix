{ self }:
with self.common.home-manager-module-sets;
base ++ [ self.homeManagerModules.plasma-bigscreen ]
