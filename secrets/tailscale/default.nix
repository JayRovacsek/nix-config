let
  keys = import ../../common/keys.nix { };

  alakazam-keys = with keys; [ alakazam-primary-key alakazam-secondary-key ];
  dragonite-keys = with keys; [ dragonite-primary-key dragonite-secondary-key ];
  jigglypuff-keys = with keys; [
    jigglypuff-primary-key
    jigglypuff-secondary-key
  ];
  magikarp-keys = with keys; [ magikarp-primary-key magikarp-secondary-key ];
  nidorina-keys = with keys; [ nidorina-primary-key nidorina-secondary-key ];
  poliwag-keys = with keys; [ poliwag-primary-key poliwag-secondary-key ];
  slowpoke-keys = with keys; [ slowpoke-primary-key slowpoke-secondary-key ];
  bellsprout-keys = with keys; [
    bellsprout-primary-key
    bellsprout-secondary-key
  ];
  gastly-keys = with keys; [ gastly-primary-key gastly-secondary-key ];
  mankey-keys = with keys; [ mankey-primary-key mankey-secondary-key ];
  mr-mime-keys = with keys; [ mr-mime-primary-key mr-mime-secondary-key ];
  nidorino-keys = with keys; [ nidorino-primary-key nidorino-secondary-key ];
  porygon-keys = with keys; [ porygon-primary-key porygon-secondary-key ];
  victreebel-keys = with keys; [
    victreebel-primary-key
    victreebel-secondary-key
  ];
  igglybuff-keys = with keys; [ igglybuff-primary-key igglybuff-secondary-key ];
  machop-keys = with keys; [ machop-primary-key machop-secondary-key ];
  meowth-keys = with keys; [ meowth-primary-key meowth-secondary-key ];
  nidoking-keys = with keys; [ nidoking-primary-key nidoking-secondary-key ];
  wigglytuff-keys = with keys; [
    wigglytuff-primary-key
    wigglytuff-secondary-key
  ];

  # Group keys by function
  admin-keys = alakazam-keys ++ dragonite-keys ++ gastly-keys ++ magikarp-keys;
  auth-keys = nidorina-keys ++ magikarp-keys;
  dns-keys = igglybuff-keys ++ jigglypuff-keys ++ magikarp-keys;
  download-keys = machop-keys ++ mankey-keys ++ meowth-keys ++ bellsprout-keys
    ++ poliwag-keys ++ slowpoke-keys ++ magikarp-keys;
  game-keys = porygon-keys ++ magikarp-keys;
  general-keys = magikarp-keys ++ wigglytuff-keys ++ magikarp-keys;
  log-keys = mr-mime-keys ++ magikarp-keys;
  nextcloud-keys = nidoking-keys ++ magikarp-keys;
  reverse-proxy-keys = nidorino-keys ++ magikarp-keys;
  work-keys = victreebel-keys ++ magikarp-keys;
in {
  ## Tailscale preauth keys
  "preauth-admin.age".publicKeys = admin-keys;
  "preauth-auth.age".publicKeys = auth-keys;
  "preauth-dns.age".publicKeys = dns-keys;
  "preauth-download.age".publicKeys = download-keys;
  "preauth-game.age".publicKeys = game-keys;
  "preauth-general.age".publicKeys = general-keys;
  "preauth-log.age".publicKeys = log-keys;
  "preauth-nextcloud.age".publicKeys = nextcloud-keys;
  "preauth-reverse-proxy.age".publicKeys = reverse-proxy-keys;
  "preauth-work.age".publicKeys = work-keys;
}
