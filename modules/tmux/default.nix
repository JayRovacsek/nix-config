{ pkgs, ... }:
{
  programs.tmux = {
    clock24 = true;
    enable = true;
    historyLimit = 10000;
    keyMode = "vi";
    newSession = true;
    plugins = with pkgs; [ ];
  };
}
