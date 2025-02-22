{ self, ... }:
{
  imports = [
    self.inputs.nur.modules.homeManager.default
  ];
}
