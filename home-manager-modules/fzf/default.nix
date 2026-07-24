{ config, lib, ... }: {
  programs.fzf = {
    enable = true;
    historyWidget.command = lib.mkIf config.programs.atuin.enable "";
  };

}
