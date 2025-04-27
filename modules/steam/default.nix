{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    gamescopeSession = {
      enable = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };

    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];

    remotePlay.openFirewall = true;
  };
}
