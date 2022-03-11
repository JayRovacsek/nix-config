let group = import ../groups/games.nix;
in {
  name = "csgo";
  uid = 3000;
  inherit group;
}
