{ pkgs, ... }: {
  services.skhd = {
    enable = true;
    skhdConfig = ''
      ################################################################################
      #
      # window manipulation
      #

      lcmd + shift + lctrl - left : ${pkgs.yabai}/bin/yabai -m window --warp east || ${pkgs.yabai}/bin/yabai -m display --focus east
      lcmd + shift + lctrl - right : ${pkgs.yabai}/bin/yabai -m window --warp west || ${pkgs.yabai}/bin/yabai -m display --focus west
      lcmd + shift + lctrl - up : ${pkgs.yabai}/bin/yabai -m window --warp north || ${pkgs.yabai}/bin/yabai -m display --focus north
      lcmd + shift + lctrl - down : ${pkgs.yabai}/bin/yabai -m window --warp south || ${pkgs.yabai}/bin/yabai -m display --focus south
    '';
  };
}
