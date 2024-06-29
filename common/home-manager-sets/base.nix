{ self }:
with self.homeManagerModules; [
  home-manager
  # TODO: resolve common home manager files
  # to be handled by impermanence
  # impermanence 
  xdg
]
