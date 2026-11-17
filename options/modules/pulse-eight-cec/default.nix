{ lib, ... }:
{
  options.pulse-eight-cec = {
    enable = lib.mkEnableOption "management of a Pulse-Eight USB-CEC adapter";

    devicePath = lib.mkOption {
      type = lib.types.str;
      default = "/dev/ttyACM0";
      description = "CDC-ACM serial device exposed by the Pulse-Eight adapter.";
    };

    clientType = lib.mkOption {
      type = lib.types.enum [
        "tv"
        "recording"
        "tuner"
        "playback"
        "audio-system"
      ];
      default = "playback";
      description = "CEC device type the host advertises on the CEC bus.";
    };
  };
}
