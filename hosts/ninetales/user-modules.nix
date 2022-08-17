{ config, pkgs, ... }: {
  imports = [
    ../../modules/alacritty
    ../../modules/firefox
    ../../modules/lsd
    ../../modules/starship
    ../../modules/vscodium

    ../../packages/x86_64-darwin.nix
  ];

    home.file."Nix Applications".source = let
    apps = pkgs.buildEnv {
      name = "home-manager-applications";
      paths = config.home.packages;
      pathsToLink = "/Applications";
    };
  in "${apps}/Applications";
}
