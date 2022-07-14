{ ... }: {
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      user = "jrovacsek";
    };
  };
}
