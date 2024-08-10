{
  config,
  lib,
  self,
  ...
}:
let
  nextcloud-present = builtins.any (
    p: (p.pname or "") == "nextcloud-client"
  ) config.home.packages;

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
  # TODO: valudate need for:
  # libvirt light lsd lutris matplotlib mimeapps.list Moonlight Game Streaming Project mopidy mpv nautilus neofetch Nextcloud nix nixpkgs nwg-bar nwg-dock nwg-dock-hyprland nwg-panel partitionmanagerrc pokemmo pop-shell procps pudb pulse QtProject.conf Ryujinx Signal Slack sniffnet starship.toml stylix sunshine swaylock systemd teamviewer Thonny unity3d Unknown Organization user-dirs.locale Vencord VirtualBox vlc VSCodium waybar WebCord wireshark Yubico zoom.conf zoomus.conf

  # TODO: write keepers for:
  # discord / webcord
  # lutris
  # keybase
  # libreoffice

  # NOTE:
  # Only directories that are not nix-generated need to be considered here.
  # If nix would generate the location based on config options therefore creating a symlink
  # we do not need to keep the value as it's already in the store
  # 
  # Well, I'm pretty sure anyway :)

  home.persistence."/persistent/home/${config.home.username}" = {
    directories =
      [
        "Pictures"
        "Videos"
        ".gnupg"
        ".ssh"
        ".local/share/keyrings"
        ".local/share/direnv"
        # TODO: write a basic package lib set that handles the checking of nextcloud across both home packages
        # as well as places like homebrew or mas apps - already quasi-done in dockutil, but in a terrbile way.
      ]
      ++ (lib.optional nextcloud-present "Nextcloud")
      # Adds all XDG created directories if the user has opted into creating directories via this option
      ++ xdg-user-dirs;
    files = [ ];
    allowOther = true;
  };
}
