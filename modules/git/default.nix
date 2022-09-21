{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    config = {
      commit = {
        gpgsign = true;
        verbose = true;
      };

      init.defaultBranch = "main";

      gpg.format = "ssh";

      tag.gpgSign = true;

      user = {
        name = "Jay Rovacsek";
        email = "jay@rovacsek.com";
        signingKey = "";
      };
    };
  };
}
