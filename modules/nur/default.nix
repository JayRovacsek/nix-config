{ self, ... }:
{
  imports = [ self.inputs.nur.modules.nixos.default ];
}
