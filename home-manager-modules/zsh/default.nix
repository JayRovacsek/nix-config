{ config, pkgs, ... }:
let
  inherit (pkgs) fetchFromGitHub;
  inherit (pkgs.lib.attrsets) recursiveUpdate;
  batAlias = if config.programs.bat.enable then {
    less = "${pkgs.bat}/bin/bat --color always";
  } else
    { };
  mergeAliases = [ batAlias ];
  shellAliases = builtins.foldl' recursiveUpdate { } mergeAliases;
in {
  programs.zsh = {
    inherit shellAliases;
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
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
  };
}
