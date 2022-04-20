{ config, pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  direnvInit = if config.services.lorri.enable then ''
    eval "$(direnv hook zsh)"
  '' else
    "";

  starshipInit = if isDarwin
  && config.home-manager.users.jrovacsek.programs.starship.enable then ''
    eval "$(starship init zsh)"
  '' else
    "";

  promptInit = lib.strings.concatStrings [
    ''
      HYPHEN_INSENSITIVE="true"
      ENABLE_CORRECTION="true"
      COMPLETION_WAITING_DOTS="true"

      # Preferred editor for local and remote sessions
      if [[ -n $SSH_CONNECTION ]]; then
          export EDITOR='vim'
      else
          export EDITOR='vim'
      fi
    ''
    starshipInit
    direnvInit
  ];

in {
  programs.zsh = {
    inherit promptInit;
  } // (if isDarwin then {
    enable = true;
    enableCompletion = true;
  } else {
    enable = true;
    histSize = 10000;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      customPkgs = [ pkgs.spaceship-prompt ];
      theme = "risto";
    };
  });
}
