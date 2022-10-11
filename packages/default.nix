{ pkgs }:
let inherit (pkgs.stdenv) isDarwin;
in with pkgs; {
  amethyst = if isDarwin then callPackage ./amethyst { } else { };
  oh-my-custom = callPackage ./oh-my-custom { };
  vulnix-precommit = callPackage ./vulnix-precommit { };
}
