{ config, pkgs, ... }:
let loginServer = "https://headscale.rovacsek.com";
in {

  age.secrets."headscale-dns-preauth-key" = {
    file = ../../secrets/headscale-dns-preauth-key.age;
    mode = "0400";
    owner = config.services.headscale.user;
  };
  # Client tailscale config
  services.tailscale = {
    port = 0;
    enable = true;
    interfaceName = "tailscale0";
  };

  environment.systemPackages = with pkgs; [ jq tailscale ];

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };

  # create a job to authenticate to Tailscale
  # thanks to https://github.com/ashkan-leo/machines/blob/main/modules/network/tailscale.nix for this
  systemd.services."tailscale-autoconnect" = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "exec";

    path = with pkgs; [ bash tailscale ];

    script = ''
      bash -c "
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"

      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # else bring tailscale up, reading the authkey for our instance
      ${pkgs.tailscale}/bin/tailscale up -authkey $(cat ${config.age.secrets.headscale-dns-preauth-key.path}) --login-server ${loginServer}"
    '';
  };
}
