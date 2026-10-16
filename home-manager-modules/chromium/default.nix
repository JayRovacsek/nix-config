{ pkgs, ... }: {
  programs.chromium = {
    enable = true;
    dictionaries = [
      pkgs.hunspellDictsChromium.en-gb
    ];
  };
}
