{
  programs.zsh = {
    enable = true;
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

      export PATH=$PATH:$(go env GOPATH)/bin
      export GOPATH=$(go env GOPATH)
      eval "$(starship init zsh)"
    '';
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
