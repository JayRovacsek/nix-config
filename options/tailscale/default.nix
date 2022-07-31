{ config, pkgs, lib, ... }:
# Inspired from https://github.com/X01A/nixos/blob/6b81e786f70381950eef30c24da06fa3a29e1e09/modules/network/tailscale.nix#L1
# :chefkiss: 

with lib;
let
  cfg = config.services.tailscale;
  haveElement = it: (builtins.length it) > 0;
  optionalList = cond: list: if cond then list else [ ];

  tailscaleJoinArgsList =
    [ "-auth-key=file:${cfg.authFile}" "--login-server" cfg.loginServer ]
    ++ (optionalList (haveElement cfg.advertiseRoutes) [
      "--advertise-routes"
      (builtins.concatStringsSep "," cfg.advertiseRoutes)
    ]) ++ (optionalList (cfg.acceptRoute) [ "--accept-routes=true" ])
    ++ (optionalList (cfg.advertiseExitNode) [ "--advertise-exit-node=true" ])
    ++ cfg.extraUpArgs;

  enableForwarding =
    ((haveElement cfg.advertiseRoutes) || cfg.advertiseExitNode);

  tailscaleJoinArgsString = builtins.concatStringsSep " " tailscaleJoinArgsList;
in {
  options = {
    services.tailscale = {
      authFile = mkOption {
        type = types.str;
        example = "/run/keys/TAILSCALE_KEY";
        description = "File location store tailscale auth-key";
      };

      loginServer = mkOption {
        type = types.str;
        default = "https://controlplane.tailscale.com";
        example = "https://headscale.example.com";
        description = "Tailscale login server url";
      };

      advertiseRoutes = mkOption {
        type = with types; listOf str;
        default = [ ];
        example = ''["10.0.0.0/24"]'';
        description = "List of advertise routes";
      };

      acceptRoute = mkOption {
        type = types.bool;
        default = false;
        description = "Accept route when join netowrk";
      };

      advertiseExitNode = mkOption {
        type = types.bool;
        default = false;
      };

      insertTable = mkOption {
        type = types.bool;
        default = true;
      };

      extraUpArgs = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = "Extra args for tailscale up";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.tailscale.enable = true;
      environment.systemPackages = with pkgs; [ tailscale ];

      # Don't restart tailscale if changed, arovid ssh connection disconnect
      systemd.services.tailscaled.restartIfChanged = false;
      systemd.services.tailscale-autoconnect = {
        description = "Automatic connection to Tailscale";

        # make sure tailscale is running before trying to connect to tailscale
        after = [ "network-pre.target" "tailscale.service" ];
        wants = [ "network-pre.target" "tailscale.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig.Type = "oneshot";
        script = with pkgs; ''
          # wait for tailscaled to settle
          sleep 2

          # check if we are already authenticated to tailscale
          status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then # if so, then do nothing
            exit 0
          fi

          health="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r '.Health | .[0]')"
          if [ $status = "not in map poll" ]; then # reauth the connection
            echo "It's reauthing"
            ${tailscale}/bin/tailscale up ${tailscaleJoinArgsString} --force-reauth
          else
            ${tailscale}/bin/tailscale up ${tailscaleJoinArgsString}
          fi
        '';
      };
    }

    (mkIf enableForwarding {
      boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv4.conf.default.forwarding" = true;
        "net.ipv4.ip_forward" = true;
        "net.ipv6.conf.all.forwarding" = true;
      };
    })

    (mkIf (enableForwarding && cfg.insertTable) {
      networking.nftables.ruleset = mkAfter ''
        table ip nat {
          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            iifname "tailscale0" masquerade
          }
        }
      '';
    })
  ]);
}
