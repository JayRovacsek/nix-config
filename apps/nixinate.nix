{ self, ... }:
let
  inherit (self.lib) merge;
  inherit (self.inputs.nixinate) nixinate;
  aarch64-darwin = nixinate.aarch64-darwin self;
  x86_64-darwin = nixinate.x86_64-darwin self;
  aarch64-linux = nixinate.aarch64-linux self;
  x86_64-linux = nixinate.x86_64-linux self;

in merge [ aarch64-darwin x86_64-darwin aarch64-linux x86_64-linux ]
