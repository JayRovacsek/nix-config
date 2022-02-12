{ config, lib, pkgs, ... }: {
  users = {
    defaultUserShell = pkgs.zsh;
    users.jay = {
      isNormalUser = true;
      useDefaultShell = true;
      extraGroups =
        [ "wheel" "docker" "libirt" "networkmanager" "audio" "video" "input" ];
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAHcp9K2S8UZWpWTkuXLsEJQ57qoXpriEqHmU4AjrWKFAAAABHNzaDo= jay@rovacsek.com"
      ];
    };
  };

  environment.shellAliases = {
    nano = "vim";
    l = "lsd -al";
    ls = "lsd";
  };
}
