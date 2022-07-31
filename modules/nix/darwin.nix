{ ... }: {
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      # This sucks to be hard-coded but there's no a good solution to it :(
      user = "jrovacsek";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
