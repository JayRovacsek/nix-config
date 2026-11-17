{ lib, ... }:
{
  options.kde-big-picture = {
    autoLoginUser = lib.mkOption {
      type = lib.types.str;
      description = "User automatically logged into the Plasma Bigscreen session at boot.";
    };
  };
}
