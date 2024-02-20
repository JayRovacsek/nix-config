{ lib, ... }: {
  options.systemd = lib.mkOption {
    type = lib.types.any;
    default = { };
    description = ''
      A systemd option stub to avoid issues with code shared between linux and darwin as a simple hack until
      better launchd and systemd mappings are done.'';
  };
}
