{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI Utilities
    git
    htop

    ## Misc
    hunspell
    hunspellDicts.en-au
  ];
}
