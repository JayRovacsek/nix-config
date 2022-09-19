{ config, pkgs, ... }:
let
  inherit (config) flake;
  inherit (pkgs) lib;
  name = "jay";
  home = "/home/${name}";

  userSshKeys =
    import ../functions/agenixSshKeys.nix { inherit name config lib; };
  identityFiles = builtins.concatStringsSep "\n  "
    (builtins.map (x: "IdentityFile ${x.path}") userSshKeys);

  localDomain = if builtins.hasAttr "localDomain" config.networking then
    config.networking.localDomain
  else
    config.networking.domain;

  darwinHosts = if builtins.hasAttr "darwinConfigurations" flake then
    (builtins.map (x: x.config.networking.hostName)
      (builtins.attrValues flake.darwinConfigurations))
  else
    [ ];

  linuxHosts = if builtins.hasAttr "nixosConfigurations" flake then
    (builtins.map (x: x.config.networking.hostName)
      (builtins.attrValues flake.nixosConfigurations))
  else
    [ ];

  addKeys = "AddKeysToAgent yes";
  forwardAgent = "ForwardAgent yes";
  addKeysForwardAgent = ''
    ${addKeys}
      ${forwardAgent}
  '';

  extraHostNames = darwinHosts ++ linuxHosts;
  extraHostConfigs = builtins.map (hostName: ''
    Host ${hostName}
      HostName ${hostName}
      ${addKeysForwardAgent}
      ${if ((builtins.length userSshKeys) != 0) then identityFiles else ""}
  '') extraHostNames;
in {
  inherit name home;
  isNormalUser = true;
  initialHashedPassword =
    "$6$LRvlOuUlmWfOtbKW$JuSDUvL0ykqAhFi80rMdWrc89wDz/uJ1Mt6WuHpsa/7kxSTWlz5O0f7xRvFvJ6nxEePUkxx/52FuHHl3rEhj61";
  extraGroups =
    [ "wheel" "docker" "libvirtd" "networkmanager" "audio" "video" "input" ];
  openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMO6FTToBOIByP9uVP2Ke2jGD/ESxPcXEMhvR7unukNGAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINNGQz3ekO1q/DrxuhP7Ck3TnP9V4ooF5vo8ibFWKKqFAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDuG5e8MReihLwtKk3/rbXcZKNfiapcqAhWu//fC0aMKAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILDjbVDfVzpcxnx9fl4pBr6eKAJdSyX4JLyBK02N9YeFAAAABHNzaDo= jay@rovacsek.com"
  ];
  shell = pkgs.zsh;

  homeManagerConfig = {
    sessionVariables.NIX_PATH = "nixpkgs=${
        config.home-manager.users."${name}".xdg.configHome
      }/nix/inputs/nixpkgs\${NIX_PATH:+:$NIX_PATH}";
    file.".ssh/config".text = ''
      Host github.com
        HostName github.com
        User git
        ${addKeys}
        ${if ((builtins.length userSshKeys) != 0) then identityFiles else ""}

      Host gcleopard1.galahcyber.com.au
        HostName gcleopard1.galahcyber.com.au
        User jay
        ${addKeysForwardAgent}
        ${if ((builtins.length userSshKeys) != 0) then identityFiles else ""}

      Host *.rovacsek.com.internal
        ${addKeysForwardAgent}
        ${if ((builtins.length userSshKeys) != 0) then identityFiles else ""}

      ${if localDomain == null then
        ""
      else ''
        Host *.${localDomain}
          ${addKeysForwardAgent}
          ${
            if ((builtins.length userSshKeys) != 0) then identityFiles else ""
          }''}

      ${builtins.concatStringsSep "\n\n" extraHostConfigs}
    '';
  };
}
