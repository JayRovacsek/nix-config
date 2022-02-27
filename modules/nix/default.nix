{ pkgs, ... }:
let
  configs = { x86_64-darwin = import ./x86_64-darwin.nix; };
  configs = { x86_64-linux = import ./x86_64-linux.nix; };
  configs = { aarch64-linux = import ./aarch64-linux.nix; };
  extraOptions = ''
    experimental-features = nix-command flakes
  '';
  package = pkgs.nixUnstable;
in {
  nix = configs.${pkgs.system};
} // {
  nix.package = package;
  nix.extraOptions = extraOptions;
}
