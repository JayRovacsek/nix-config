{ config, lib, pkgs, self, ... }:
let
  inherit (self.lib) merge;
  inherit (pkgs) fetchFromGitHub;

  bat = lib.optionalAttrs config.programs.bat.enable {
    less = "${pkgs.bat}/bin/bat --color always";
  };
in {
  programs.zsh = {
    autosuggestion.enable = true;
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "risto";
    };

    plugins = [{
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.5.0";
        sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
      };
    }];

    shellAliases = merge [ bat ];
    syntaxHighlighting.enable = true;
  };
}
