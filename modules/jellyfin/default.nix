{ lib, ... }:
{
  # Extended options for jellyfin
  imports = [ ../../options/modules/jellyfin ];

  # Required to enable nvidia capabilities to jellyfin. Otherwise
  # configuration may seem fine, but never can invoke cuda backed capabilities
  systemd.services.jellyfin = {
    environment.LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    serviceConfig.DeviceAllow = lib.mkForce [
      "/dev/nvidia0 rw"
      "/dev/nvidiactl rw"
      "/dev/nvidia-uvm rw"
      "/dev/nvidia-uvm-tools rw"
      "/dev/nvidia-modeset rw"
    ];
  };

  services.jellyfin = {
    enable = true;

    # Upstream has started mapping these settings, so ho
    # we'll be able to kill a range of our bespoke options
    useDeclarativeSettings = true;

    user = "jellyfin";
    group = "media";

    hardwareAcceleration = {
      enable = true;
      device = "/dev/nvidia0";
      type = "nvenc";
    };

    forceEncodingConfig = true;

    openFirewall = true;

    transcoding = {
      deleteSegments = true;
      enableHardwareEncoding = true;
      enableSubtitleExtraction = true;
      enableToneMapping = true;
      encodingPreset = "auto";

      hardwareDecodingCodecs = {
        av1 = true;
        h264 = true;
        hevc = true;
        hevc10bit = true;
        hevcRExt10bit = true;
        hevcRExt12bit = true;
        mpeg2 = true;
        vc1 = true;
        vp8 = true;
        vp9 = true;
      };
      hardwareEncodingCodecs = {
        av1 = true;
        hevc = true;
      };
      throttleTranscoding = true;
    };
  };
}
