{ config, pkgs, ... }:
{
  name = "EncodingOptions";
  props = ''xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'';

  value = [
    {
      name = "AllowAv1Encoding";
      value = false;
    }
    {
      name = "AllowHevcEncoding";
      value = true;
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
    {
      name = "DeinterlaceDoubleRate";
      value = false;
    }
    {
      name = "DeinterlaceMethod";
      value = "yadif";
    }
    {
      name = "DownMixAudioBoost";
      value = 2;
    }
    {
      name = "DownMixStereoAlgorithm";
      value = "None";
    }
    {
      name = "EnableAudioVbr";
      value = false;
    }
    {
      name = "EnableDecodingColorDepth10Hevc";
      value = true;
    }
    {
      name = "EnableDecodingColorDepth10HevcRext";
      value = true;
    }
    {
      name = "EnableDecodingColorDepth10Vp9";
      value = true;
    }
    {
      name = "EnableDecodingColorDepth12HevcRext";
      value = true;
    }
    {
      name = "EnableEnhancedNvdecDecoder";
      value = true;
    }
    {
      name = "EnableFallbackFont";
      value = false;
    }
    {
      name = "EnableHardwareEncoding";
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
      name = "EnableSegmentDeletion";
      value = false;
    }
    {
      name = "EnableSubtitleExtraction";
      value = true;
    }
    {
      name = "EnableThrottling";
      value = true;
    }
    {
      name = "EnableTonemapping";
      value = true;
    }
    {
      name = "EnableVideoToolboxTonemapping";
      value = false;
    }
    {
      name = "EnableVppTonemapping";
      value = false;
    }
    {
      name = "EncoderAppPathDisplay";
      value = "${pkgs.jellyfin-ffmpeg}/bin/ffmpeg";
    }
    {
      name = "EncoderPreset";
      value = "auto";
    }
    {
      name = "EncodingThreadCount";
      value = -1;
    }
    { name = "FallbackFontPath"; }
    {
      name = "H264Crf";
      value = 23;
    }
    {
      name = "H265Crf";
      value = 28;
    }
    {
      name = "HardwareAccelerationType";
      # TODO: make this dynamic depending on system capabilities
      value = "nvenc";
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
      name = "MaxMuxingQueueSize";
      value = 2048;
    }
    {
      name = "PreferSystemNativeHwDecoder";
      value = true;
    }
    { name = "QsvDevice"; }
    {
      name = "SegmentKeepSeconds";
      value = 720;
    }
    {
      name = "ThrottleDelaySeconds";
      value = 180;
    }
    {
      name = "TonemappingAlgorithm";
      value = "bt2390";
    }
    {
      name = "TonemappingDesat";
      value = 0;
    }
    {
      name = "TonemappingMode";
      value = "auto";
    }
    {
      name = "TonemappingParam";
      value = 0;
    }
    {
      name = "TonemappingPeak";
      value = 100;
    }
    {
      name = "TonemappingRange";
      value = "auto";
    }
    {
      name = "TranscodingTempPath";
      value = "${config.services.jellyfin.cacheDir}/transcodes";
    }
    {
      name = "VaapiDevice";
      value = "/dev/dri/renderD128";
    }
    {
      name = "VppTonemappingBrightness";
      value = 16;
    }
    {
      name = "VppTonemappingContrast";
      value = 1;
    }
  ];
}
