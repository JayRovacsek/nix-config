{ self, pkgs, ... }: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber.configPackages = with self.packages.${pkgs.system};
      [ wireplumber-disable-pci-0 ];
  };

  security.rtkit.enable = true;

  hardware.pulseaudio.enable = false;
}
