_: {
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  targets.darwin = {
    linkApps.enable = true;
    copyApps.enable = false;
  };
}
