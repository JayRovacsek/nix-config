{ lib, pkgs, self, ... }:
let inherit (self.common.networking.services) flaresolverr;
in {
  networking.firewall.allowedTCPPorts = [ flaresolverr.port ];

  systemd.services.flaresolverr = {
    description = "FlareSolverr";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    wants = [ "network.target" ];
    path = with pkgs; [ xorg.xorgserver ];

    environment = {
      HOME = "/run/flaresolverr";
      HOST = "0.0.0.0";
      PORT = builtins.toString flaresolverr.port;
      LOG_LEVEL = "info";
      TZ = "Australia/NSW";
    };

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "3";
      ExecStart = "${pkgs.nur.repos.xddxdd.flaresolverr}/bin/flaresolverr";
      RuntimeDirectory = "flaresolverr";
      WorkingDirectory = "/run/flaresolverr";

      MemoryDenyWriteExecute = false;
      SystemCallFilter = lib.mkForce [ ];
    };
  };
}
