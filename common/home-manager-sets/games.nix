{ self }:
let inherit (self.common) home-manager-modules;
in with home-manager-modules; [ lutris ]
