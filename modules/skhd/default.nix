{ pkgs, ... }:
let
  inherit (pkgs) bash yabai;
in
{
  launchd.user.agents.skhd.environment.SHELL = "${bash}/bin/bash";

  services.skhd = {
    enable = true;
    skhdConfig = ''
      ################################################################################
      #
      # window manipulation
      #

      lcmd + shift + lctrl - left : ${yabai}/bin/yabai -m window --warp west || ${yabai}/bin/yabai -m display --focus west
      lcmd + shift + lctrl - right : ${yabai}/bin/yabai -m window --warp east || ${yabai}/bin/yabai -m display --focus east
      lcmd + shift + lctrl - up : ${yabai}/bin/yabai -m window --warp north || ${yabai}/bin/yabai -m display --focus north
      lcmd + shift + lctrl - down : ${yabai}/bin/yabai -m window --warp south || ${yabai}/bin/yabai -m display --focus south
    '';
  };
}
