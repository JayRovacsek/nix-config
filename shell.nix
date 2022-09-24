{ pkgs ? import (fetchTarball {
  name = "22.05";
  url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/22.05.tar.gz";
  sha256 = "0d643wp3l77hv2pmg2fi7vyxn4rwy0iyr8djcw1h5x72315ck9ik";
}) { }, unstable ? import (fetchTarball {
  name = "unstable";
  # Commit as per 23/09/2022 
  url =
    "https://github.com/NixOS/nixpkgs/archive/403bfc5a5cc9c8843651bc309b14633fb1e7e1d3.tar.gz";
  sha256 = "16d3dd54s1nprphxb2l8cq0lrgb4r4bcxprwn6x0h0x7g6i4wj57";
}) { } }:
let
  stable-inputs = with pkgs; [ nixfmt statix vulnix ];
  unstable-inputs = with unstable; [ nil ];
  buildInputs = stable-inputs ++ unstable-inputs;
in pkgs.mkShell {
  inherit buildInputs;

  name = "Nix Config Shell";
  shellHook = ''
    nixfmt $(find . -type f -name "*.nix")
  '';
}
