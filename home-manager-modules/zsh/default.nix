{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    oh-my-zsh = {
      enable = true;
          plugins = [
      "git" "sudo"
    ];
theme = "risto";
    };
  };
}