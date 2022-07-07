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

  hostname = config.networking.hostName;
in {

  age.secrets = secrets;

  # Client tailscale config
  services.tailscale = {
    enable = true;
    interfaceName = "tailscale0";
  };

  environment.systemPackages = with pkgs; [ jq tailscale ];

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };

  systemd.services.tailscaled.wants = [ "tailscaled.service" ];

  # create a job to authenticate to Tailscale
  # thanks to https://github.com/ashkan-leo/machines/blob/main/modules/network/tailscale.nix for this
  systemd.services."tailscale-autoconnect" = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "tailscaled.service" ];
    wantedBy = [ "tailscaled.service" ];

    serviceConfig.Type = "oneshot";

    script = ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"

      if [ $status = "Running" ]; then
        tailscale logout
      fi

      sleep 2

      if [ -f "${preauthPath}" ]; then
        ${pkgs.tailscale}/bin/tailscale up \
        --auth-key=file:${preauthPath} \
        --login-server=${loginServer} \
        --hostname=${hostname}
      fi
    '';
  };
}
