{
  config,
  lib,
  osConfig,
  self,
  ...
}:
let
  /**
    Beware: the below is kinda cursed, but I'm kinda chuffed with it.
    The intent is to describe a function that can be curried so that the
    assessment of common traits between system and home settings can be
    evaluated without duplicating too much code.
  */
  package-has =
    cfg: package: fn:
    # Check if the package exists as a program option in home-manager
    if (builtins.hasAttr package cfg.programs) then
      cfg.programs."${package}".enable
    # Alternatively as a service
    else if (builtins.hasAttr package cfg.services) then
      cfg.services."${package}".enable
    else
      fn;

  home-packages-has =
    package:
    package-has config package (
      builtins.any (p: package == (p.pname or p.name or "")) config.home.packages
    );

  system-packages-has =
    package:
    package-has osConfig package (
      builtins.any (
        p: package == (p.pname or p.name or "")
      ) osConfig.environment.systemPackages
    );

  # The final boss of curries
  any-packages-has =
    package:
    builtins.any (f: f package) [
      home-packages-has
      system-packages-has
    ];

  # HERE BE DRAGONS!
  #
  # So, this takes the defined xdg dirs and splits the absolute path; assuming 
  # a prefix of anything then /$USERNAME/ e.g. /home/foo/ where foo is the username.
  #
  # This would seem like a good idea generally, but there is a obvious flaw here
  # where a user might opt to make a directory that includes their username in it
  # e.g. /home/foo/bar/baz/foo/a - while generally unlikely to cause issue, this would
  # absolutely have a bug where data WILL BE LOST if this happens and the below code
  # is the only code used. 
  #
  # It could trivially be resolved via a check for linux / darwin,
  # then stripping the normal patterns off the front of the string. But I'm this deep now and 
  # uncaring to solve it - the below should generally work also.
  xdg-user-dirs = lib.optionals config.xdg.userDirs.createDirectories (
    builtins.map (x: lib.last (lib.splitString "/${config.home.username}/" x)) (
      builtins.attrValues config.xdg.userDirs.extraConfig
    )
  );

in
{
  imports = [ self.inputs.impermanence.nixosModules.home-manager.impermanence ];

  # NOTE:
  # Only directories that are not nix-generated need to be considered here.
  # If nix would generate the location based on config options therefore creating a symlink
  # we do not need to keep the value as it's already in the store

  home.persistence."/persistent/home/${config.home.username}" = {
    directories =
      [
        # TEMPORARY TO ENABLE TRANSITION - REMOVE
        "restic"

        ".cache/nix"
        ".gnupg"
        ".local/share/keyrings"
        ".ssh"
      ]
      ## Atuin
      ++ (lib.optionals (home-packages-has "atuin") [ ".local/share/atuin" ])

      ## Direnv
      ++ (lib.optionals (home-packages-has "direnv") [ ".local/share/direnv" ])

      ## Firefox; note that ".cache/mozilla/firefox" could be 
      # added to the below to retain the browser cache, but I'm going to see
      # how it goes just nuking that directory for now.
      ++ (lib.optionals (home-packages-has "firefox") [ ".mozilla/firefox" ])

      # Jellyfin
      ++ (lib.optionals (home-packages-has "jellyfin-media-player") [
        ".local/share/Jellyfin Media Player"
        ".local/share/jellyfinmediaplayer"
      ])

      ## Keybase
      ++ (lib.optionals (home-packages-has "keybase") [ ".local/share/keybase" ])

      ## Lutris
      ++ (lib.optionals (home-packages-has "lutris") [ ".config/lutris" ])

      ++ (lib.optionals (home-packages-has "nextcloud-client") [
        ".config/Nextcloud"
        ".local/share/Nextcloud"
        "Nextcloud"
      ])

      ++ (lib.optionals (home-packages-has "ollama") [
        ".ollama"
      ])

      ## r2modman
      ++ (lib.optionals (home-packages-has "r2modman") [ ".config/r2modman" ])

      ## Slack
      ++ (lib.optionals (home-packages-has "slack") [ ".config/Slack" ])

      ## Signal
      ++ (lib.optionals (home-packages-has "signal-desktop") [ ".config/Signal" ])

      ## Steam
      ++ (lib.optionals (any-packages-has "steam") [
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
        {
          directory = ".steam";
          method = "symlink";
        }
      ])

      ## Thunderbird
      ++ (lib.optionals (home-packages-has "thunderbird") [ ".thunderbird" ])

      ## VSCodium
      ++ (lib.optionals (home-packages-has "vscodium") [ ".config/VSCodium" ])

      ## Webcord / Vencord
      ++ (lib.optionals (home-packages-has "webcord-vencord") [
        ".config/Vencord"
        ".config/Webcord"
      ])

      ## Zoom
      ++ (lib.optionals (home-packages-has "zoom-us") [ ".zoom" ])

      # Adds all XDG created directories if the user has opted into creating directories via this option
      ++ xdg-user-dirs;
    files = [ ];
    allowOther = true;
  };
}
