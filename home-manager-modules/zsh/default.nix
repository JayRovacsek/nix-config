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
    dotDir = "${config.xdg.configHome}/zsh";
    enable = true;
    enableCompletion = false;
    enableVteIntegration = true;

    initContent = lib.mkOrder 550 ''
      DISABLE_AUTO_UPDATE="true"
      DISABLE_COMPFIX="true"

      setopt extendedglob
      autoload -Uz compinit
      for dump in ~/.zcompdump(N.mh+24); do
        compinit
      done
      compinit -C
    '';

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
      {
        name = "zsh-async";
        src = pkgs.fetchFromGitHub {
          owner = "mafredri";
          repo = "zsh-async";
          rev = "ee1d11b68c38dec24c22b1c51a45e8a815a79756";
          hash = "sha256-mkTmgSnfoZlTaOPhw0Y0yG1BkZv+oTo/eEisZZTN5nM=";
        };
        file = "async.plugin.zsh";
      }
    ];

    shellAliases = merge [ bat ];
    syntaxHighlighting.enable = true;
  };
}
