{ config, pkgs, ... }: {
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      jay = {
        isNormalUser = true;
        useDefaultShell = true;
        extraGroups = [
          "wheel"
          "docker"
          "libirt"
          "networkmanager"
          "audio"
          "video"
          "input"
        ];
      };
    };
  };
}
