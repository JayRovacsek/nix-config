{
  config-version = 3;
  disconnect = {
    invalid-arguments-length = "Expected {} arguments, got {}. Is Geyser up-to-date?";
    invalid-key = "Please connect through the official Geyser";
  };
  key-file-name = "key.pem";
  metrics.enabled = false;
  player-link = {
    allowed = true;
    enable-global-linking = true;
    enable-own-linking = false;
    enabled = true;
    link-code-timeout = 300;
    require-link = false;
    type = "sqlite";
  };
  replace-spaces = true;
  username-prefix = ".";
}
