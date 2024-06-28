{ self, ... }: {
  imports = with self.inputs; [ home-manager.nixosModules.default ];
  home-manager.extraSpecialArgs = { inherit self; };

}
