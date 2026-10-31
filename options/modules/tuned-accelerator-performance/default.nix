# Enables TuneD and activates the built-in accelerator-performance profile
# via a oneshot service, as recommended for Strix Halo (gfx1151) machines
# (https://offsite.guru/blog/halogen-strix-halo/).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.tuned-accelerator-performance;
in
{
  options.services.tuned-accelerator-performance.enable = lib.mkEnableOption ''
    activation of the TuneD accelerator-performance profile
  '';

  config = lib.mkIf cfg.enable {
    services.tuned.enable = true;

    systemd.services.tuned-set-profile = {
      description = "Set TuneD profile";
      after = [ "tuned.service" ];
      wants = [ "tuned.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.tuned}/bin/tuned-adm profile accelerator-performance";
      };
    };
  };
}
