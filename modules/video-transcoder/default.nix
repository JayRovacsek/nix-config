{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.services.video-transcoder;
in
{
  options.services.video-transcoder = {
    enable = lib.mkEnableOption ''
      Whether to enable the video-transcoder watchdog service.
    '';

    monitorDir = lib.mkOption {
      type = lib.types.str;
      default = "";
    };

    codec = lib.mkOption {
      type = lib.types.str;
      description = ''
        The video codec to use (e.g., 'h264', 'h264_nvenc').
      '';
      default = "";
    };

    output = lib.mkOption {
      type = lib.types.str;
      description = ''
        The output directory or file pattern.
      '';
      default = "";
    };

    optimise = lib.mkOption {
      type = lib.types.str;
      description = ''
        Whether to enable LLM-driven optimisation.
      '';
      default = "";
    };

    apiKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        The OpenAI API key for LLM optimisation.
      '';
      default = null;
    };

    useNvenc = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Use nvenc
      '';
      default = false;
    };

    verbose = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to enable verbose output.
      '';
      default = false;
    };
  };

  config.systemd.services.video-transcoder-watchdog = lib.mkIf cfg.enable {
    description = "Video Transcoder Watchdog Service";
    after = [ "network.target" ];
    wantedBy = [ "multiuser.target" ];

    serviceConfig = {
      ExecStart = lib.concatStringsSep " " (
        [
          "${self.packages.${self.system}.video-transcoder}/bin/video-transcoder"
        ]
        ++ (lib.optional (cfg.monitorDir != "") "-- ${cfg.monitorDir}")
        ++ (lib.optional (cfg.codec != "") "--codec ${cfg.codec}")
        ++ (lib.optional (cfg.output != "") "--output ${cfg.output}")
        # ++ (lib.optionals cfg.optimise "--optimise")
        ++ (lib.optional (cfg.apiKey != null) "--api-key ${cfg.apiKey}")
        ++ (lib.optional cfg.useNvenc "--use-nvenc")
        ++ (lib.optional cfg.verbose "-v")
      );
      Restart = "on-failure";
    };
  };
}
