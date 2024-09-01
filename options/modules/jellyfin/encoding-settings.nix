{ pkgs, ... }:
{
  name = "EncodingOptions";
  props = ''xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'';

  value = [
    {
      name = "EncodingThreadCount";
      value = 0;
    }
    { name = "TranscodingTempPath"; }
    {
      name = "EnableFallbackFont";
      value = false;
    }
    {
      name = "DownMixAudioBoost";
      value = 2;
    }
    {
      name = "MaxMuxingQueueSize";
      value = 2048;
    }
    {
      name = "EnableThrottling";
      value = true;
    }
    {
      name = "ThrottleDelaySeconds";
      value = 180;
    }
    {
      name = "HardwareAccelerationType";
      # TODO: make this dynamic depending on system capabilities
      value = "nvenc";
    }
    {
      name = "EncoderAppPathDisplay";
      value = "${pkgs.jellyfin-ffmpeg}/bin/ffmpeg";
    }
    {
      name = "EnableTonemapping";
      value = false;
    }
    {
      name = "EnableVppTonemapping";
      value = false;
    }
    {
      name = "TonemappingAlgorithm";
      value = "bt2390";
    }
    {
      name = "TonemappingMode";
      value = "auto";
    }
    {
      name = "TonemappingRange";
      value = "auto";
    }
    {
      name = "TonemappingDesat";
      value = 0;
    }
    {
      name = "TonemappingPeak";
      value = 100;
    }
    {
      name = "TonemappingParam";
      value = 0;
    }
    {
      name = "VppTonemappingBrightness";
      value = 16;
    }
    {
      name = "VppTonemappingContrast";
      value = 1;
    }
    {
      name = "H264Crf";
      value = 23;
    }
    {
      name = "H265Crf";
      value = 28;
    }
    { name = "EncoderPreset"; }
    {
      name = "DeinterlaceDoubleRate";
      value = false;
    }
    {
      name = "DeinterlaceMethod";
      value = "yadif";
    }
    {
      name = "EnableDecodingColorDepth10Hevc";
      value = true;
    }
    {
      name = "EnableDecodingColorDepth10Vp9";
      value = true;
    }

    {
      name = "EnableDecodingColorDepth10Hevc";
      value = true;
    }
    {
      name = "EnableDecodingColorDepth10Vp9";
      value = true;
    }
    {
      name = "EnableEnhancedNvdecDecoder";
      value = true;
    }
    {
      name = "PreferSystemNativeHwDecoder";
      value = true;
    }
    {
      name = "EnableIntelLowPowerH264HwEncoder";
      value = false;
    }
    {
      name = "EnableIntelLowPowerHevcHwEncoder";
      value = false;
    }
    {
      name = "EnableHardwareEncoding";
      value = true;
    }
    {
      name = "AllowHevcEncoding";
      value = true;
    }
    {
      name = "EnableSubtitleExtraction";
      value = true;
    }
    {
      name = "HardwareDecodingCodecs";
      value = [
        {
          name = "string";
          value = "h264";
        }
        {
          name = "string";
          value = "hevc";
        }
        {
          name = "string";
          value = "mpeg2video";
        }
        {
          name = "string";
          value = "mpeg4";
        }
        {
          name = "string";
          value = "vc1";
        }
        {
          name = "string";
          value = "vp8";
        }
        {
          name = "string";
          value = "vp9";
        }
      ];
    }
    {
      name = "AllowOnDemandMetadataBasedKeyframeExtractionForExtensions";
      value = [
        {
          name = "string";
          value = "mkv";
        }
      ];
    }
  ];
}
