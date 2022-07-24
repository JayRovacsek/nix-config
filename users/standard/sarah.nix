{ config, pkgs, flake ? { }, ... }:
let
  lib = pkgs.lib;
  name = "sarah";
  home = "/home/${name}";
in {
  inherit name home;
  isNormalUser = true;
  initialHashedPassword =
    "$6$LRvlOuUlmWfOtbKW$JuSDUvL0ykqAhFi80rMdWrc89wDz/uJ1Mt6WuHpsa/7kxSTWlz5O0f7xRvFvJ6nxEePUkxx/52FuHHl3rEhj61";
  extraGroups = [ ];
  openssh.authorizedKeys.keys = [ ];
  shell = pkgs.zsh;
}
