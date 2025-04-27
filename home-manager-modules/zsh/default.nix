{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib) merge;

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
        file = "nix-shell.plugin.zsh";
        name = "zsh-autocomplete";
        src = "${pkgs.zsh-completions}/share/zsh-autocomplete";
      }
      {
        file = "nix-shell.plugin.zsh";
        name = "zsh-nix-shell";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
      {
        file = "nix-zsh-completions.plugin.zsh";
        name = "nix-zsh-completions";
        src = "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix";
      }
      {
        file = "you-should-use.plugin.zsh";
        name = "zsh-you-should-use";
        src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
      }
    ];

    shellAliases = merge [ bat ];
    syntaxHighlighting.enable = true;
  };
}
