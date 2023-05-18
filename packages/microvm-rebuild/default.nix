{ stdenv, pkgs, lib }:
with lib;
let
  name = "microvm-rebuild";
  pname = "microvm-rebuild";
  version = "0.0.1";
  meta = {
    description =
      "A simple shell wrapper to make rebuilding of microvms easier";
    platforms = platforms.unix;
  };

  microvm-rebuild-wrapped = pkgs.writeShellScriptBin "microvm-rebuild" ''
    # The below is simply a copy/paste of existing script I hadn't added.
    # I'll either clean this up or kill it in the near future
    sudo systemctl stop microvm@igglybuff.service
    sudo systemctl stop microvms.target 
    sudo systemctl stop microvm-tap-interfaces@igglybuff.service 
    sudo systemctl stop microvm-virtiofsd@igglybuff.service  
    sudo rm -rf /var/lib/microvms/igglybuff 
    sudo systemctl stop microvm@aipom.service 
    sudo systemctl stop microvms.target 
    sudo systemctl stop microvm-tap-interfaces@aipom.service 
    sudo systemctl stop microvm-virtiofsd@aipom.service  
    sudo rm -rf /var/lib/microvms/aipom 
    # sudo rm -rf /etc/systemd/network/ 
    nixos-rebuild switch --flake .# --use-remote-sudo 
    sudo systemctl daemon-reload 
    sudo networkctl reload
  '';

  phases = [ "installPhase" "fixupPhase" ];

in stdenv.mkDerivation {
  inherit name pname version meta phases;

  buildInputs = [ microvm-rebuild-wrapped ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${microvm-rebuild-wrapped}/bin/microvm-rebuild $out/bin
  '';
}
