_: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  security.rtkit.enable = true;

  hardware.pulseaudio.enable = false;

  # Disable select outputs - below the following devices are disabled:
  # * HDMI screen output on alakazam
  environment.etc."wireplumber/main.lua.d/51-alsa-disable.lua" = {
    mode = "0444";
    text = ''
      rule = {
        matches = {
          {
            { "device.name", "equals", "alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1" },
          },
        },
        apply_properties = {
          ["device.disabled"] = true,
        },
      }

      table.insert(alsa_monitor.rules,rule)
    '';
  };
}
