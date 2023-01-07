{ config, pkgs, ... }: {
  programs.git = {
    enable = true;
    difftastic = {
      enable = true;
      background = "dark";
      color = "auto";
    };
    lfs = {
      enable = true;
      skipSmudge = true;
    };
    # signing = {
    #   gpgPath = "";
    #   key = "";
    #   signByDefault = true;
    # };
    userEmail = "jay@rovacsek.com";
    userName = "jayrovacsek";
  };
}
