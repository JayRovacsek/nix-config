_: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.rtkit.enable = true;

  hardware.pulseaudio.enable = false;

  # Added to fix default HDMI output on desktop - wonder if it'll break anything else?
  environment.etc."wireplumber/main.lua.d/51-alsa-disable.lua".text = ''
    rule = {
      matches = {
        {
          { "device.name", "equals", "alsa_card.pci-0000_01_00.1" },
        },
      },
      apply_properties = {
        ["device.disabled"] = true,
      },
    }

    table.insert(alsa_monitor.rules,rule)
  '';
}
