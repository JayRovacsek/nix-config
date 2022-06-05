let
  name = "sarah";
  home = "/home/${name}";
in {
  inherit name;
  inherit home;
  initialHashedPassword =
    "$6$LRvlOuUlmWfOtbKW$JuSDUvL0ykqAhFi80rMdWrc89wDz/uJ1Mt6WuHpsa/7kxSTWlz5O0f7xRvFvJ6nxEePUkxx/52FuHHl3rEhj61";
  extraGroups = [ ];
  openssh.authorizedKeys.keys = [ ];
  shell = "zsh";
}
