_: {
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      settings = {
        General = {
          DisplayServer = "wayland";
          GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
        };

        Wayland = { CompositorCommand = ""; };
      };
    };
  };
}
