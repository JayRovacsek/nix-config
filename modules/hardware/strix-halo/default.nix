_: {
  imports = [ ../../../options/modules/hardware/strix-halo ];

  hardware.strix-halo.enable = true;

  # bolt authorises devices on the USB4 host routers (domains report
  # security "user"), enabling DP Alt Mode plus USB tunnelling for the
  # monitor's single-cable setup.
  services.hardware.bolt.enable = true;
}
