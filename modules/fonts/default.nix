{ pkgs, ... }: {
  fonts.fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Hack" ]; }) ];
}
