{ config, pkgs, lib, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
  direnvInit = if config.services.lorri.enable then ''
    eval "$(direnv hook zsh)"
  '' else
    "";

  environment.systemPackages =
    if isDarwin then with pkgs; [ oh-my-zsh ] else [ ];

  ohMyZshInit = if isDarwin then ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
  '' else
    "";

  ohMyZshPostInit = if isDarwin then ''
    ZSH_THEME="risto"
    plugins=(zsh-autosuggestions, git)
    source $ZSH/oh-my-zsh.sh
  '' else
    "";

  starshipInit = if isDarwin
  && config.home-manager.users.jrovacsek.programs.starship.enable then ''
    eval "$(starship init zsh)"
  '' else
    "";

  interactiveShellInit = lib.strings.concatStrings [
    ohMyZshInit
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
    ohMyZshPostInit
    starshipInit
    direnvInit
  ];

  promptInit = "";

  shellAliases = if isDarwin
  && config.home-manager.users.jrovacsek.programs.lsd.enable then {
    ls = "lsd";
  } else
    { };
in {
  environment.shellAliases = shellAliases;

  programs.zsh = {
    inherit promptInit;
    inherit interactiveShellInit;
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
