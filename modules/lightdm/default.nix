_: {
  services.xserver = {
    enable = true;
    displayManager.lightdm = {
      enable = true;
      greeters = {
        gtk.enable = false;
        enso.enable = true;
      };
    };
  };
}
