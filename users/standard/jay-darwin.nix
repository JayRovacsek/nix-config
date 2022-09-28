{ config, pkgs, ... }:
let
  inherit (config) flake;
  inherit (pkgs) lib;
  name = "jrovacsek";
  home = "/Users/${name}";

  userSshKeys =
    import ../functions/agenixSshKeys.nix { inherit name config lib; };
  identityFiles = builtins.concatStringsSep "\n  "
    (builtins.map (x: "IdentityFile ${x.path}") userSshKeys);

  localDomain = if builtins.hasAttr "localDomain" config.networking then
    config.networking.localDomain
  else if builtins.hasAttr "domain" config.networking then
    config.networking.domain
  else
    null;

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

  extraHostNames = darwinHosts ++ linuxHosts;
  extraHostConfigs = builtins.map (hostName: ''
    Host ${hostName}
      HostName ${hostName}
      AddKeysToAgent yes
      ${if ((builtins.length userSshKeys) != 0) then identityFiles else ""}
  '') extraHostNames;
in {
  inherit name home;

  openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMO6FTToBOIByP9uVP2Ke2jGD/ESxPcXEMhvR7unukNGAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINNGQz3ekO1q/DrxuhP7Ck3TnP9V4ooF5vo8ibFWKKqFAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDuG5e8MReihLwtKk3/rbXcZKNfiapcqAhWu//fC0aMKAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILDjbVDfVzpcxnx9fl4pBr6eKAJdSyX4JLyBK02N9YeFAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAHcp9K2S8UZWpWTkuXLsEJQ57qoXpriEqHmU4AjrWKFAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICOGbb7QMU4l5jccNIaGp9M8HBhyGm3JeNnD30td49nfAAAABHNzaDo= jay@rovacsek.com"
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
        AddKeysToAgent yes
        ${if ((builtins.length userSshKeys) != 0) then identityFiles else ""}

      Host *.rovacsek.com.internal
        AddKeysToAgent yes
        ${if ((builtins.length userSshKeys) != 0) then identityFiles else ""}

      ${if localDomain == null then
        ""
      else ''
        Host *.${localDomain}
          AddKeysToAgent yes
          ${
            if ((builtins.length userSshKeys) != 0) then identityFiles else ""
          }''}

      ${builtins.concatStringsSep "\n\n" extraHostConfigs}
    '';
  };
}
