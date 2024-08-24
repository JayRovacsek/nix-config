{ lib, pkgs, ... }:

let
  modifier = "modifier4";
  keybindings = lib.mkOptionDefault {
    "${modifier}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
    "${modifier}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
    "${modifier}+Shift+x" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";

    # Move
    "${modifier}+Shift+Control+left" = "move left";
    "${modifier}+Shift+Control+down" = "move down";
    "${modifier}+Shift+Control+up" = "move up";
    "${modifier}+Shift+Control+right" = "move right";
  };
in
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      inherit keybindings modifier;

      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
        }
      ];
    };
  };
}
