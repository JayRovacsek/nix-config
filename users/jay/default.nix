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

  environment.interactiveShellInit = ''
    HYPHEN_INSENSITIVE="true"
    ENABLE_CORRECTION="true"
    COMPLETION_WAITING_DOTS="true"

     Preferred editor for local and remote sessions
    if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR='vim'
    else
        export EDITOR='vim'
    fi
  '';
  environment.shellAliases = {
    nano = "vim";
    l = "lsd -al";
    ls = "lsd";
  };
}
