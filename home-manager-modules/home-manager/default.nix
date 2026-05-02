_: {
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  # TODO: Move the below to darwin specific configs
  # targets.darwin = {
  #   linkApps.enable = true;
  #   copyApps.enable = false;
  # };
}
