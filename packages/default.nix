{ pkgs }:
with pkgs; {
  amethyst = callPackage ./amethyst { };
  oh-my-custom = callPackage ./oh-my-custom { };
}
