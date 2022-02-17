{ config, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  promptInit = ''
    HYPHEN_INSENSITIVE="true"
    ENABLE_CORRECTION="true"
    COMPLETION_WAITING_DOTS="true"

    # Preferred editor for local and remote sessions
    if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR='vim'
    else
        export EDITOR='vim'
    fi

    eval "$(starship init zsh)"
    eval "$(direnv hook zsh)"
  '';
in {
  programs.zsh = if isDarwin then {
    inherit promptInit;
    enable = true;
    enableCompletion = true;
  } else {
    inherit promptInit;
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
  };
}
