{ pkgs, lib, ... }:
let
  # https://github.com/ranger/ranger/pull/2466 is complete and sixel is to be supported
  # but the version of ranger currently packaged does not include these changes.
  # See also: https://github.com/ranger/ranger/issues/2702
  ranger-sixel-support = lib.versionAtLeast pkgs.ranger.version "1.9.4";
  preview-method = "set preview_images_method ${
      if ranger-sixel-support then "sixel" else "urxvt"
    }";
  optional-packages = with pkgs;
    if ranger-sixel-support then [ imagemagick ] else [ rxvt-unicode ];
  packages = with pkgs; [ ranger ] ++ optional-packages;
in {
  imports = [ ../xdg ];

  home = { inherit packages; };

  xdg.configFile."ranger/rc.conf".text = ''
    set preview_images true
    ${preview-method}
  '';
}
