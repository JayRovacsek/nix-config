let piholeUser = import ../../../../users/service-accounts/pihole.nix;
in {
  name = "pihole/dnsmasq.d/03-local.conf";
  text = ''
    # Local Address Binds
    address=/ubiquiti_ap.localdomain/192.168.1.3
    address=/dragonite.localdomain/192.168.1.220
    address=/alakazam.localdomain/192.168.1.221
    address=/speedtest.localdomain/192.168.1.222
    address=/duplicati.localdomain/192.168.1.223
    address=/tv.localdomain/192.168.3.2
    address=/car_bed.localdomain/192.168.3.10
    address=/jackett.localdomain/192.168.4.129
    address=/deluge.localdomain/192.168.4.130
    address=/sonarr.localdomain/192.168.4.131
    address=/radarr.localdomain/192.168.4.132
    address=/lidarr.localdomain/192.168.4.133
    address=/ombi.localdomain/192.168.4.134
    address=/tdarr-controller.localdomain/192.168.4.135
    address=/tdarr-node-01.localdomain/192.168.4.136
    address=/prowlarr.localdomain/192.168.4.137
    address=/flare-solverr.localdomain/192.168.4.138
    address=/swag.localdomain/192.168.5.3
    address=/pihole.localdomain/192.168.6.2
    address=/authelia.localdomain/192.168.9.2
    address=/nextcloud.localdomain/192.168.10.2
    address=/homeassistant.localdomain/192.168.12.2
    address=/cache.localdomain/192.168.16.2
    address=/minecraft.localdomain/192.168.17.5
    address=/minecraft.rovacsek.com/192.168.17.5
    address=/valheim.localdomain/192.168.17.3
    address=/valheim.rovacsek.com/192.168.17.3
    address=/terraria.localdomain/192.168.17.4
    address=/terraria.rovacsek.com/192.168.17.4
    address=/prowlarr.rovacsek.com/192.168.5.3
    address=/.rovacsek.com/192.168.5.3
    address=/.rovacsek.com.localdomain/192.168.5.3
  '';
  uid = piholeUser.uid;
  gid = piholeUser.group.id;
  mode = "0400";
}
