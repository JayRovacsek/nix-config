{
  pkgs,
  stdenvNoCC,
  fetchFromGitHub,
  coreutils,
  eww,
  self,
  ...
}:
let
  inherit (pkgs) system;
  inherit (self.packages.${system})
    eww-battery
    eww-mem-ad
    eww-memory
    eww-music-info
    eww-pop
    eww-wifi
    eww-workspace
    ;

  name = "eww-sleek-bar";
  version = "0.0.1";
  meta = {
    description = "A sleek eww bar";
  };

  src = fetchFromGitHub {
    owner = "saimoomedits";
    repo = "eww-widgets";
    rev = "cfb2523a4e37ed2979e964998d9a4c37232b2975";
    hash = "sha256-yPSUdLgkwJyAX0rMjBGOuUIDvUKGPcVA5CSaCNcq0e8=";
  };

  phases = [
    "installPhase"
    "fixupPhase"
  ];

in
stdenvNoCC.mkDerivation {
  inherit
    name
    version
    meta
    phases
    src
    ;

  installPhase = ''
    ${coreutils}/bin/mkdir -p $out/share/scripts $out/share/images
    ${coreutils}/bin/cp $src/eww/bar/images/*.png $out/share/images
    ${coreutils}/bin/cp $src/eww/bar/eww.scss $out/share
    ${coreutils}/bin/cp $src/eww/bar/eww.yuck $out/share

    substituteInPlace $out/share/eww.yuck \
      --replace '(defwindow bar' '(defwindow bar :monitor 0 :monitor 1 :monitor 2 :monitor 3' \
      --replace '(defvar eww "$HOME/.local/bin/eww/eww -c $HOME/.config/eww/bar")' '(defvar eww "${eww}/bin/eww -c $HOME/.config/eww")' \
      --replace '~/.config/eww/bar' '~/.config/eww' \
      --replace '$HOME/.config/eww/bar' '$HOME/.config/eww' \
      --replace './scripts/' '$out/share/scripts'

    substituteInPlace $out/share/eww.scss \
      --replace 'font-family: feather;' 'font-family: DejaVu Sans;' \
      --replace 'font-family: DaddyTimeMono NF;' 'font-family: Hack Nerd Font;' \
      --replace 'font-family: JetBrainsMono Nerd Font;' 'font-family: Hack Nerd Font;' \
      --replace 'font-family: Iosevka Nerd Font;' 'font-family: Hack Nerd Font;'

    ${coreutils}/bin/ln -s ${eww-battery}/bin/battery $out/share/scripts
    ${coreutils}/bin/ln -s ${eww-mem-ad}/bin/mem-ad $out/share/scripts
    ${coreutils}/bin/ln -s ${eww-memory}/bin/memory $out/share/scripts
    ${coreutils}/bin/ln -s ${eww-music-info}/bin/music_info $out/share/scripts
    ${coreutils}/bin/ln -s ${eww-pop}/bin/pop $out/share/scripts
    ${coreutils}/bin/ln -s ${eww-wifi}/bin/wifi $out/share/scripts
    ${coreutils}/bin/ln -s ${eww-workspace}/bin/workspace $out/share/scripts
  '';
}
