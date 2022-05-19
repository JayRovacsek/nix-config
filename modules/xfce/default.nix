{ config, pkgs, ... }:
let
  autoLoginEnable =
    builtins.any (x: x.name == "jay") (builtins.attrValues config.users.users);
  autoLogin = if autoLoginEnable then {
    enable = true;
    user = "jay";
  } else
    { };
in {
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm = {
        inherit autoLogin;
        enable = true;
      };
    };
    desktopManager.xfce = {
      enable = true;
      enableScreensaver = false;
    };
  };
}
