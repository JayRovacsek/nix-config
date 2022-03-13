let
  user = import ../../../../users/service-accounts/csgo.nix;
  autoexec = import ./settings/autoexec.nix { user = user; };
  gameModeCasual = import ./settings/gameModeCasual.nix { user = user; };
  gameModes = import ./settings/gameModes.nix { user = user; };
in { files = [ autoexec gameModeCasual gameModes ]; }
