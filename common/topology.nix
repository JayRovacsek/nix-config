{ self, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.lib.topology)
    mkInternet
    mkRouter
    mkSwitch
    mkConnection
    ;
  inherit (pkgs) system;
  inherit (lib) recursiveUpdate;
in
{
  nixosConfigurations = builtins.removeAttrs self.nixosConfigurations [
    "amazon"
    "butterfree"
    "ditto"
    "linode"
    "mew"
    "oracle"
    "porygon"
    "rpi4"
    "rpi5"
  ];

  nodes = {
    # WAN interfaces
    internet = mkInternet { connections = mkConnection "pfsense" "em1"; };
    openvpn1 = mkInternet { connections = mkConnection "pfsense" "ovpnc1"; };
    openvpn2 = mkInternet { connections = mkConnection "diglett" "eth0"; };

    # Simple bindings of interface -> network for most hosts
    # These seem like they'd be for free _if_ I were using
    # networking.interface options, but I'm explicitly using
    # systemd-networkd rules. TODO: See if I can get the below
    # for free :)
    alakazam.interfaces.eth0.network = "lan";
    cloyster = {
      deviceType = "nixos";
      interfaces.wlan0.network = "wlan";
    };
    diglett = {
      interfaces = {
        eth0 = { };
        tun0.network = "ovpnc2";
      };
    };
    dragonite.interfaces =
      let
        interfaces = builtins.foldl' (
          acc: vlan: recursiveUpdate acc { ${vlan.name}.network = vlan.name; }
        ) { } self.common.config.networks;
      in
      recursiveUpdate { eth0.network = "lan"; } interfaces;

    gastly.interfaces.wlan0.network = "wlan";
    ivysaur.interfaces.eth0.network = "lan";
    jigglypuff.interfaces.vlan-dns.network = "dns";
    wartortle.interfaces.eth0.network = "lan";
    wigglytuff.interfaces.wlan0.network = "iot";
    zubat.interfaces.eth0.network = "lan";

    pfsense = mkRouter "pfsense" {
      info = "pfsense";
      image = "${self.packages.${system}.pfsense-logo}/share/logo.png";
      interfaceGroups = [
        [ "em0" ]
        [
          "em1"
          "ovpnc1"
          "ovpnc2"
        ]
      ];

      interfaces =
        let
          interfaces = builtins.foldl' (
            acc: vlan:
            recursiveUpdate acc {
              ${vlan.name} = {
                network = vlan.name;
                addresses = [ "192.168.${builtins.toString vlan.vlan-tag}.1" ];
                virtual = true;
              };
            }
          ) { } self.common.config.networks;
        in
        {
          em1 = {
            addresses = [ "192.168.1.1" ];
            network = "lan";
          };
          ovpnc2 = {
            physicalConnections = [ (mkConnection "diglett" "tun0") ];
          };
        }
        // interfaces;
    };

    switch = mkSwitch "US-24" {
      hardware.info = "Ubiquiti UniFi 24 Port Managed Switch with SFP";
      image = "${self.packages.${system}.ubiquiti-logo}/share/logo.png";
      interfaces =
        let
          interfaces = builtins.foldl' (
            acc: vlan:
            recursiveUpdate acc {
              ${vlan.name} = {
                network = vlan.name;
                virtual = true;
                physicalConnections = [ (mkConnection "pfsense" vlan.name) ];
              };
            }
          ) { } self.common.config.networks;
        in
        recursiveUpdate {
          eth0 = {
            network = "lan";
            physicalConnections = [ (mkConnection "pfsense" "em1") ];
          };
          eth1 = {
            network = "lan";
            physicalConnections = [
              (mkConnection "alakazam" "eth0")
              (mkConnection "ivysaur" "eth0")
              (mkConnection "wartortle" "eth0")
              (mkConnection "zubat" "eth0")
            ];
          };
          eth2 = {
            network = "lan";
            physicalConnections = [ (mkConnection "dragonite" "eth0") ];
          };
          eth3 = {
            network = "dns";
            physicalConnections = [ (mkConnection "jigglypuff" "vlan-dns") ];
          };
          eth4 = {
            network = "lan";
            physicalConnections = [ (mkConnection "wap" "eth0") ];
          };
        } interfaces;
    };

    wap = mkSwitch "AP AC Lite" {
      hardware.info = "Ubiquiti UniFi AP AC Lite 802.11ac Access Point";
      image = "${self.packages.${system}.ubiquiti-logo}/share/logo.png";
      interfaces = {
        eth0 = { };
        wlan1 = {
          network = "wlan";
          physicalConnections = [
            (mkConnection "cloyster" "wlan0")
            (mkConnection "gastly" "wlan0")
          ];
        };
        wlan2 = {
          network = "iot";
          physicalConnections = [ (mkConnection "wigglytuff" "wlan0") ];
        };
      };
    };
  };

  networks =
    let
      networks = builtins.foldl' (
        acc: vlan:
        recursiveUpdate acc {
          ${vlan.name} = {
            inherit (vlan) name;
            cidrv4 = "192.168.${builtins.toString vlan.vlan-tag}.0/24";
          };
        }
      ) { } self.common.config.networks;
    in
    recursiveUpdate {
      lan = {
        name = "lan";
        cidrv4 = "192.168.1.0/24";
      };
      ovpnc2 = {
        name = "ovpnc2";
      };
    } networks;
}
