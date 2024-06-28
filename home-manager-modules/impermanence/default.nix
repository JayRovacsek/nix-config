{ config, lib, ... }:
let
  nextcloud-present = builtins.any (p: (p.pname or "") == "nextcloud-client")
    config.home.packages;
in {
  # TODO: valudate need for:
  # libvirt light lsd lutris matplotlib mimeapps.list Moonlight Game Streaming Project mopidy mpv nautilus neofetch Nextcloud nix nixpkgs nwg-bar nwg-dock nwg-dock-hyprland nwg-panel partitionmanagerrc pokemmo pop-shell procps pudb pulse QtProject.conf Ryujinx Signal Slack sniffnet starship.toml stylix sunshine swaylock systemd teamviewer Thonny unity3d Unknown Organization user-dirs.locale Vencord VirtualBox vlc VSCodium waybar WebCord wireshark Yubico zoom.conf zoomus.conf

  # TODO: write keepers for:
  # discord / webcord
  # lutris
  # keybase
  # libreoffice

  # TODO: codify files associated with:
  # keepassxc ini

  # NOTE:
  # Only directories that are not nix-generated need to be considered here.
  # If nix would generate the location based on config options therefore creating a symlink
  # we do not need to keep the value as it's already in the store
  # 
  # Well, I'm pretty sure anyway :)

  home.persistence."/persistent/home/${config.home.username}" = {
    directories = [
      "Pictures"
      "Videos"
      ".gnupg"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/direnv"
      # TODO: write a basic package lib set that handles the checking of nextcloud across both home packages
      # as well as places like homebrew or mas apps - already quasi-done in dockutil, but in a terrbile way.
    ] ++ (lib.optional nextcloud-present "Nextcloud")
    # Adds all XDG created directories if the user has opted into creating directories via this option
      ++ lib.optionals config.xdg.userDirs.createDirectories
      (builtins.attrValues config.xdg.userDirs.extraConfig);
    files = [ ];
    allowOther = true;
  };
}
