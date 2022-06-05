let
  name = "jay";
  home = "/home/${name}";
in {
  inherit name;
  inherit home;
  initialHashedPassword =
    "$6$LRvlOuUlmWfOtbKW$JuSDUvL0ykqAhFi80rMdWrc89wDz/uJ1Mt6WuHpsa/7kxSTWlz5O0f7xRvFvJ6nxEePUkxx/52FuHHl3rEhj61";
  extraGroups =
    [ "wheel" "docker" "libirt" "networkmanager" "audio" "video" "input" ];
  openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMO6FTToBOIByP9uVP2Ke2jGD/ESxPcXEMhvR7unukNGAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINNGQz3ekO1q/DrxuhP7Ck3TnP9V4ooF5vo8ibFWKKqFAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDuG5e8MReihLwtKk3/rbXcZKNfiapcqAhWu//fC0aMKAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILDjbVDfVzpcxnx9fl4pBr6eKAJdSyX4JLyBK02N9YeFAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAHcp9K2S8UZWpWTkuXLsEJQ57qoXpriEqHmU4AjrWKFAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICOGbb7QMU4l5jccNIaGp9M8HBhyGm3JeNnD30td49nfAAAABHNzaDo= jay@rovacsek.com"
  ];
  shell = "zsh";

  homeConfigs = {
    file.".ssh/config".text = ''
      Host github.com
        HostName github.com
        User git
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519_sk_type_a_1
        IdentityFile ~/.ssh/id_ed25519_sk_type_a_2
        IdentityFile ~/.ssh/id_ed25519_sk_type_c_1
        IdentityFile ~/.ssh/id_ed25519_sk_type_c_2

      Host *
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519_sk_type_a_1
        IdentityFile ~/.ssh/id_ed25519_sk_type_a_2
        IdentityFile ~/.ssh/id_ed25519_sk_type_c_1
        IdentityFile ~/.ssh/id_ed25519_sk_type_c_2
    '';
  };

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
      file = "id_ed25519_sk_type_a_1.pub";
      path = "${home}/.ssh/id_ed25519_sk_type_a_1.pub";
    }
    {
      file = "id_ed25519_sk_type_a_2.pub";
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
      file = "id_ed25519_sk_type_c_1.pub";
      path = "${home}/.ssh/id_ed25519_sk_type_c_1.pub";
    }
    {
      file = "id_ed25519_sk_type_c_2.pub";
      path = "${home}/.ssh/id_ed25519_sk_type_c_2.pub";
    }
    {
      file = "ssh_config";
      path = "${home}/.ssh/config";
    }
  ];
}
