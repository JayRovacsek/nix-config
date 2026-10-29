_: {
  imports = [ ../../options/modules/halogen-flash-server ];

  services.halogen-flash-server.enable = true;
  services.halogen-flash-server.applyRecommendedSystemSettings = true;
}
