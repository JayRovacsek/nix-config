{ pkgs, ... }: {
  services.skhd = {
    enable = true;
    skhdConfig = ''
      ################################################################################
      #
      # window manipulation
      #

      shift + alt - left : ${pkgs.yabai}/bin/yabai -m window --resize left:-20:0
      shift + alt - right : ${pkgs.yabai}/bin/yabai -m window --resize right:-20:0

      lcmd + shift + lctrl - left : ${pkgs.yabai}/bin/yabai -m window --warp east
      lcmd + shift + lctrl - right : ${pkgs.yabai}/bin/yabai -m window --warp west
      lcmd + shift + lctrl - up : ${pkgs.yabai}/bin/yabai -m window --warp north
      lcmd + shift + lctrl - down : ${pkgs.yabai}/bin/yabai -m window --warp south
    '';
  };
}
