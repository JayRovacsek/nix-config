{ cairo, cmake, fetchFromGitHub, hyprland, lib, pango, pkg-config, pkgs, stdenv
}:
let
  version = "hl0.${builtins.elemAt (lib.splitVersion hyprland.version) 1}.0";
  pname = "hy3";
  src = fetchFromGitHub {
    owner = "outfoxxed";
    repo = pname;
    rev = version;
    # If the below shows a mismatch, you've just been visited by the 
    # hyprland update angel of peace.
    # change it to:
    # sha256 = lib.fakeHash;
    # Rebuild and correct the value for peace and prosperity
    # forever more
    sha256 = "sha256-j49bEOLjBa1CH2gTwM+A2Edrw/GspE2m8q1teAn6SuQ=";
  };

  hyprland-dev = hyprland.dev.overrideAttrs (_old: {
    postFixup = ''
      substituteInPlace $out/include/hyprland/src \
        --replace "#include <format>" ""
    '';
  });

  nativeBuildInputs = with pkgs; [ cmake pkg-config ];

  buildInputs = [ hyprland-dev pango cairo ] ++ hyprland.buildInputs;

  meta = with lib; {
    homepage = "https://github.com/outfoxxed/hy3";
    description = "Hyprland plugin for an i3 / sway like manual tiling layout";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };

in stdenv.mkDerivation {
  inherit buildInputs nativeBuildInputs meta pname src version;
}
