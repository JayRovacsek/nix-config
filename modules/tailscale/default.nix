{ config, pkgs, lib, tailnet, ... }:
let
  loginServer = "https://headscale.rovacsek.com";

  tailnets = builtins.map (x:
    "${lib.strings.removeSuffix "-preauth-key"
    (lib.strings.removePrefix "tailscale-" x)}")
    (builtins.filter (z: (lib.strings.hasInfix "${tailnet}-preauth-key" z))
      (builtins.attrNames (builtins.readDir ../../secrets)));

  # TODO: validate the parameter tailnet is one of the above via an assert

  secrets = builtins.foldl' (a: b: a // b) { } (builtins.map (x: {
    "${lib.strings.removeSuffix ".age" x}" = {
      file = ../../secrets/${x};
      mode = "0400";
    };
  }) (builtins.filter (z: (lib.strings.hasInfix "${tailnet}-preauth-key" z))
    (builtins.attrNames (builtins.readDir ../../secrets))));

  preauthPath = config.age.secrets."tailscale-${tailnet}-preauth-key".path;
in {

  age.secrets = secrets;

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

      if [ $status == "Running" ]; then # Assume changes might have been made to this config - re-auth to ensure we match our config
        tailscale logout
      fi

      sleep 2

      ${pkgs.tailscale}/bin/tailscale up -authkey $(cat ${preauthPath}) --login-server ${loginServer}"
    '';
  };
}
