{ ... }:
{
  # Extended options for jellyfin
  imports = [ ../../options/modules/jellyfin ];

  services.jellyfin = {
    enable = true;

    # Upstream has started mapping these settings, so ho
    # we'll be able to kill a range of our bespoke options
    useDeclarativeSettings = true;

    user = "media";
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
