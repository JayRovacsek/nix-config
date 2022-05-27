{ config, pkgs, ... }:
let isLinux = pkgs.stdenv.isLinux;
in rec {
  name = builtins.toString (if isLinux then "jay" else "jrovacsek");
  initialHashedPassword =
    "$6$LRvlOuUlmWfOtbKW$JuSDUvL0ykqAhFi80rMdWrc89wDz/uJ1Mt6WuHpsa/7kxSTWlz5O0f7xRvFvJ6nxEePUkxx/52FuHHl3rEhj61";
  extraGroups =
    [ "wheel" "docker" "libirt" "networkmanager" "audio" "video" "input" ];
  openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAHcp9K2S8UZWpWTkuXLsEJQ57qoXpriEqHmU4AjrWKFAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICOGbb7QMU4l5jccNIaGp9M8HBhyGm3JeNnD30td49nfAAAABHNzaDo= jay@rovacsek.com"
  ];
  home = if isLinux then "/home/${name}" else "/Users/${name}";
  shell = "zsh";
  # The below should just be done by gen list, then map against a + c but I'll fix it later
  secrets = [
    {
      file = "id_ed25519_sk_type_a_1";
      # file = ../../secrets/id_ed25519_sk_type_a_1.age;
      path = "${home}/.ssh/id_ed25519_sk_type_a_1";
    }
    {
      file = "id_ed25519_sk_type_a_2";
      path = "${home}/.ssh/id_ed25519_sk_type_a_2";
    }
    {
      file = "id_ed25519_sk_type_a_1_pub";
      path = "${home}/.ssh/id_ed25519_sk_type_a_1.pub";
    }
    {
      file = "id_ed25519_sk_type_a_2_pub";
      path = "${home}/.ssh/id_ed25519_sk_type_a_2.pub";
    }
    {
      file = "id_ed25519_sk_type_c_1";
      path = "${home}/.ssh/id_ed25519_sk_type_c_1";
    }
    {
      file = "id_ed25519_sk_type_c_2";
      path = "${home}/.ssh/id_ed25519_sk_type_c_2";
    }
    {
      file = "id_ed25519_sk_type_c_1_pub";
      path = "${home}/.ssh/id_ed25519_sk_type_c_1.pub";
    }
    {
      file = "id_ed25519_sk_type_c_2_pub";
      path = "${home}/.ssh/id_ed25519_sk_type_c_2.pub";
    }
    {
      file = "ssh_config";
      path = "${home}/.ssh/config";
    }
  ];
}
