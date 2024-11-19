{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib) merge;
  inherit (pkgs) fetchFromGitHub;

  bat = lib.optionalAttrs config.programs.bat.enable {
    less = "${pkgs.bat}/bin/bat --color always";
  };
in
{
  programs.zsh = {
    autosuggestion.enable = true;
    enable = true;
    enableCompletion = false;
    enableVteIntegration = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
      theme = "risto";
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "sha256-Z6EYQdasvpl1P78poj9efnnLj7QQg13Me8x1Ryyw+dM=";
        };
      }
    ];

    shellAliases = merge [ bat ];
    syntaxHighlighting.enable = true;
  };
}
