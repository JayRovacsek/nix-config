let
  user = import ../../users/service-accounts/dnsmasq.nix;
in
{
  inherit (user) uid;
  inherit (user.group) gid;
  name = "dnsmasq.d/03-local.conf";
  text = ''
    # Local Address Binds
    address=/pfsense.local/192.168.1.1
    address=/ubiquiti_ap.local/192.168.1.3
    address=/dragonite.local/192.168.1.220
    address=/alakazam.local/192.168.1.221
    address=/speedtest.local/192.168.1.222
    address=/duplicati.local/192.168.1.223
    address=/tv.local/192.168.3.2
    address=/wigglytuff.local/192.168.3.4
    address=/car_bed.local/192.168.3.10
    address=/jackett.local/192.168.4.129
    address=/deluge.local/192.168.4.130
    address=/sonarr.local/192.168.4.131
    address=/radarr.local/192.168.4.132
    address=/lidarr.local/192.168.4.133
    address=/ombi.local/192.168.4.134
    address=/tdarr.local/192.168.4.135
    address=/tdarr-node-01.local/192.168.4.136
    address=/prowlarr.local/192.168.4.137
    address=/flare-solverr.local/192.168.4.138
    address=/swag.local/192.168.5.3
    address=/jellyfin.local/192.168.5.4
    address=/stubby.local/192.168.6.3
    address=/jigglypuff.local/192.168.6.4
    address=/authelia.local/192.168.9.2
    address=/nextcloud.local/192.168.10.2
    address=/home-assistant.local/192.168.12.2
    address=/cache.local/192.168.16.2
    address=/minecraft.local/192.168.17.5
    address=/minecraft.rovacsek.com/192.168.17.5
    address=/valheim.local/192.168.17.3
    address=/valheim.rovacsek.com/192.168.17.3
    address=/terraria.local/192.168.17.4
    address=/terraria.rovacsek.com/192.168.17.4
    address=/.rovacsek.com/192.168.5.3
  '';
  mode = "0444";
}
