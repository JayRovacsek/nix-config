{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "zsh-completions"
      ];
      theme = "risto";
    };
  };
}
