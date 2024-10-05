{ config, ... }:
{
  hardware.bluetooth = {
    enable = true;
    hsphfpd.enable = !config.services.pipewire.wireplumber.enable;
  };

  services.blueman.enable = true;
}
