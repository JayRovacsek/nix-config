{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "nix-config";
  buildInputs = with pkgs; [ nixfmt statix ];
  shellHook = "";
}
