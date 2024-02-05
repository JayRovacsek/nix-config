{ config, lib, ... }:
let
  inherit (config.services.blocky.settings.ports) dns tls http https;
  inherit (lib) concatStrings reverseList;
  bin-blocks = let
    bin-chars = [ "b" "i" "n" ];
    mod-chars = [ "m" "o" "d" ];
    duolcfmaj-chars = [ "d" "u" "o" "l" "c" "f" "m" "a" "j" ];
    bin-prefix = concatStrings (reverseList bin-chars);
    mod-infix = concatStrings (reverseList mod-chars);
    duolcfmaj-infix = concatStrings (reverseList duolcfmaj-chars);
  in {
    "${bin-prefix}.${duolcfmaj-infix}.com" = "0.0.0.0";
    "${bin-prefix}${mod-infix}.com" = "0.0.0.0";
    "${bin-prefix}${mod-infix}.com.au" = "0.0.0.0";
  };
in {
  networking.firewall = {
    allowedTCPPorts = [ dns tls http https ];
    allowedUDPPorts = [ dns ];
  };

  systemd.services.blocky = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    startLimitIntervalSec = 1;
    startLimitBurst = 50;
  };

  services.blocky = {
    enable = true;
    #
    # SEE ALSO: https://0xerr0r.github.io/blocky/latest/configuration/#logging-configuration
    #
    settings = {

      # optional: use black and white lists to block queries (for example ads, trackers, adult pages etc.)
      blocking = {
        # definition of blacklist groups. Can be external link (http/https) or local file
        blackLists = {
          ads = [
            "https://adaway.org/hosts.txt"
            "https://raw.githubusercontent.com/blocklistproject/Lists/master/ads.txt"
            "https://raw.githubusercontent.com/blocklistproject/Lists/master/phishing.txt"
            "https://raw.githubusercontent.com/blocklistproject/Lists/master/tracking.txt"
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
          ];

          void = [ ];
        };
        # definition of whitelist groups. Attention: if the same group has black and whitelists, whitelists will be used to disable particular blacklist entries. If a group has only whitelist entries -> this means only domains from this list are allowed, all other domains will be blocked
        whiteLists.ads = [ ];
        # definition: which groups should be applied for which client
        clientGroupsBlock = {
          # default will be used, if no special definition for a client name exists
          default = [ "ads" ];
          # use client name (with wildcard support: * - sequence of any characters, [0-9] - range)
          # or single ip address / client subnet as CIDR notation
          # "foo*" = [ "ads" ];
          "192.168.8.11/32" = [ "void" ];
          "192.168.8.50/32" = [ "void" ];
        };

        # which response will be sent, if query is blocked:
        # zeroIp: 0.0.0.0 will be returned (default)
        # nxDomain: return NXDOMAIN as return code
        # comma separated list of destination IP addresses (for example: 192.100.100.15, 2001:0db8:85a3:08d3:1319:8a2e:0370:7344). Should contain ipv4 and ipv6 to cover all query types. Useful with running web server on this address to display the "blocked" page.
        blockType = "zeroIp";
        # optional: TTL for answers to blocked domains
        # default: 6h
        blockTTL = "6h";

        loading = {
          # optional: automatically list refresh period (in duration format). Default: 4h.
          # Negative value -> deactivate automatically refresh.
          # 0 value -> use default
          refreshPeriod = "4h";

          # optional: if failOnError, application startup will fail if at least one list can't be downloaded / opened. Default: blocking
          strategy = "fast";

          downloads = {
            # optional: timeout for list download (each url). Default: 60s. Use large values for big lists or slow internet connections
            timeout = "60s";
            # optional: Number of download attempts.
            attempts = 5;
            # optional: Time between the download attempts. Default: 1s
            cooldown = "1s";
          };
        };
      };

      # optional: use these DNS servers to resolve blacklist urls and upstream DNS servers. It is useful if no system DNS resolver is configured, and/or to encrypt the bootstrap queries.
      bootstrapDns = {
        upstream = "https://dns.google/dns-query";
        ips = [ "8.8.8.8" "8.8.4.4" ];
      };

      # optional: configuration for caching of DNS responses
      caching = {
        # duration how long a response must be cached (min value).
        # If <=0, use response's TTL, if >0 use this value, if TTL is smaller
        # Default: 0
        minTime = "0m";
        # duration how long a response must be cached (max value).
        # If <0, do not cache responses
        # If 0, use TTL
        # If > 0, use this value, if TTL is greater
        # Default: 0
        maxTime = "0m";
        # Max number of cache entries (responses) to be kept in cache (soft limit). Useful on systems with limited amount of RAM.
        # Default (0): unlimited
        maxItemsCount = 0;
        # if true, will preload DNS results for often used queries (default: names queried more than 5 times in a 2-hour time window)
        # this improves the response time for often used queries, but significantly increases external traffic
        # default: false
        prefetching = true;
        # prefetch track time window (in duration format)
        # default: 120
        prefetchExpires = "2h";
        # name queries threshold for prefetch
        # default: 5
        prefetchThreshold = 3;
        # Max number of domains to be kept in cache for prefetching (soft limit). Useful on systems with limited amount of RAM.
        # Default (0): unlimited
        prefetchMaxItemsCount = 0;
        # Time how long negative results (NXDOMAIN response or empty result) are cached. A value of -1 will disable caching for negative results.
        # Default: 30m
        cacheTimeNegative = "90m";
      };

      # optional: Determines how blocky will create outgoing connections. This impacts both upstreams, and lists.
      # accepted: dual, v4, v6
      # default: dual
      connectIPVersion = "v4";

      # optional: custom IP address(es) for domain name (with all sub-domains). Multiple addresses must be separated by a comma
      # example: query "printer.lan" or "my.printer.lan" will return 192.168.178.3
      customDNS = {
        customTTL = "1h";
        # optional: if true (default), return empty result for unmapped query types (for example TXT, MX or AAAA if only IPv4 address is defined).
        # if false, queries with unmapped types will be forwarded to the upstream resolver
        filterUnmappedTypes = false;
        # optional: replace domain in the query with other domain before resolver lookup in the mapping
        mapping = bin-blocks // {
          # Local
          "pfsense.lan" = "192.168.1.1";
          "ubiquiti_ap.lan" = "192.168.1.3";
          "dragonite.lan" = "192.168.1.220";
          "alakazam.lan" = "192.168.1.221";
          "speedtest.lan" = "192.168.1.222";
          "duplicati.lan" = "192.168.1.223";
          "tv.lan" = "192.168.3.2";
          "wigglytuff.lan" = "192.168.3.4";
          "car_bed.lan" = "192.168.3.10";
          "jackett.lan" = "192.168.4.129";
          "deluge.lan" = "192.168.4.130";
          "sonarr.lan" = "192.168.4.131";
          "radarr.lan" = "192.168.4.132";
          "lidarr.lan" = "192.168.4.133";
          "ombi.lan" = "192.168.4.134";
          "tdarr.lan" = "192.168.4.135";
          "tdarr-node-01.lan" = "192.168.4.136";
          "prowlarr.lan" = "192.168.4.137";
          "flare-solverr.lan" = "192.168.4.138";
          "swag.lan" = "192.168.5.3";
          "jellyfin.lan" = "192.168.5.4";
          "stubby.lan" = "192.168.6.3";
          "jigglypuff.lan" = "192.168.6.4";
          "igglybuff.lan" = "192.168.6.8";
          "victreebel.lan" = "192.168.7.12";
          "authelia.lan" = "192.168.9.2";
          "nextcloud.lan" = "192.168.10.2";
          "home-assistant.lan" = "192.168.12.2";
          "cache.lan" = "192.168.16.2";
          "minecraft.lan" = "192.168.17.5";
          "porygon.lan" = "192.168.17.2";
          "valheim.lan" = "192.168.17.3";
          "terraria.lan" = "192.168.17.4";

          "authelia.rovacsek.com" = "192.168.1.220";
          "binarycache.rovacsek.com" = "192.168.1.220";
          "code.rovacsek.com" = "192.168.1.220";
          "deluge.rovacsek.com" = "192.168.1.220";
          "firefox-syncserver.rovacsek.com" = "192.168.1.220";
          "headscale.rovacsek.com" = "192.168.1.220";
          "hydra.rovacsek.com" = "192.168.1.220";
          "jellyfin.rovacsek.com" = "192.168.1.220";
          "jellyseerr.rovacsek.com" = "192.168.1.220";
          "lidarr.rovacsek.com" = "192.168.1.220";
          "nextcloud.rovacsek.com" = "192.168.1.220";
          "pfsense.rovacsek.com" = "192.168.1.220";
          "portainer.rovacsek.com" = "192.168.1.220";
          "prowlarr.rovacsek.com" = "192.168.1.220";
          "radarr.rovacsek.com" = "192.168.1.220";
          "sonarr.rovacsek.com" = "192.168.1.220";
          "palworld.rovacsek.com" = "192.168.17.2";

          # Blizzard
          "dist.blizzard.com" = "192.168.16.2";
          "dist.blizzard.com.edgesuite.net" = "192.168.16.2";
          "llnw.blizzard.com" = "192.168.16.2";
          "edgecast.blizzard.com" = "192.168.16.2";
          "blizzard.vo.llnwd.net" = "192.168.16.2";
          "blzddist1-a.akamaihd.net" = "192.168.16.2";
          "blzddist2-a.akamaihd.net" = "192.168.16.2";
          "blzddist3-a.akamaihd.net" = "192.168.16.2";
          "blzddist4-a.akamaihd.net" = "192.168.16.2";
          "level3.blizzard.com" = "192.168.16.2";
          "nydus.battle.net" = "192.168.16.2";
          "edge.blizzard.top.comcast.net" = "192.168.16.2";
          "cdn.blizzard.com" = "192.168.16.2";

          # Epic
          "cdn1.epicgames.com" = "192.168.16.2";
          "cdn.unrealengine.com" = "192.168.16.2";
          "cdn1.unrealengine.com" = "192.168.16.2";
          "cdn2.unrealengine.com" = "192.168.16.2";
          "cdn3.unrealengine.com" = "192.168.16.2";
          "download.epicgames.com" = "192.168.16.2";
          "download2.epicgames.com" = "192.168.16.2";
          "download3.epicgames.com" = "192.168.16.2";
          "download4.epicgames.com" = "192.168.16.2";
          "epicgames-download1.akamaized.net" = "192.168.16.2";
          "fastly-download.epicgames.com" = "192.168.16.2";

          # Nintendo
          "ccs.cdn.wup.shop.nintendo.com" = "192.168.16.2";
          "ccs.cdn.wup.shop.nintendo.net" = "192.168.16.2";
          "ccs.cdn.wup.shop.nintendo.net.edgesuite.net" = "192.168.16.2";
          "geisha-wup.cdn.nintendo.net" = "192.168.16.2";
          "geisha-wup.cdn.nintendo.net.edgekey.net" = "192.168.16.2";
          "idbe-wup.cdn.nintendo.net" = "192.168.16.2";
          "idbe-wup.cdn.nintendo.net.edgekey.net" = "192.168.16.2";
          "ecs-lp1.hac.shop.nintendo.net" = "192.168.16.2";
          "receive-lp1.dg.srv.nintendo.net" = "192.168.16.2";
          "wup.shop.nintendo.net" = "192.168.16.2";
          "wup.eshop.nintendo.net" = "192.168.16.2";
          "hac.lp1.d4c.nintendo.net" = "192.168.16.2";
          "hac.lp1.eshop.nintendo.net" = "192.168.16.2";

          # Origin
          "origin-a.akamaihd.net" = "192.168.16.2";
          "lvlt.cdn.ea.com" = "192.168.16.2";
          "cdn-patch.swtor.com" = "192.168.16.2";

          # Riot
          "l3cdn.riotgames.com" = "192.168.16.2";
          "worldwide.l3cdn.riotgames.com" = "192.168.16.2";
          "riotgamespatcher-a.akamaihd.net" = "192.168.16.2";
          "riotgamespatcher-a.akamaihd.net.edgesuite.net" = "192.168.16.2";
          "dyn.riotcdn.net" = "192.168.16.2";

          # Rockstar
          "patches.rockstargames.com" = "192.168.16.2";

          # Sony
          "gs2.ww.prod.dl.playstation.net" = "192.168.16.2";
          "gs2.sonycoment.loris-e.llnwd.net" = "192.168.16.2";
          "pls.patch.station.sony.com" = "192.168.16.2";
          "gs2-ww-prod.psn.akadns.net" = "192.168.16.2";
          "gs2.ww.prod.dl.playstation.net.edgesuite.net" = "192.168.16.2";
          "playstation4.sony.akadns.net" = "192.168.16.2";
          "theia.dl.playstation.net" = "192.168.16.2";
          "tmdb.np.dl.playstation.net" = "192.168.16.2";
          "gs-sec.ww.np.dl.playstation.net" = "192.168.16.2";

          # Steam
          # Uplay
          "cdn.ubi.com" = "192.168.16.2";

          # XBox Live
          "assets1.xboxlive.com" = "192.168.16.2";
          "assets2.xboxlive.com" = "192.168.16.2";
          "xboxone.loris.llnwd.net" = "192.168.16.2";
          "xboxone.vo.llnwd.net" = "192.168.16.2";
          "xbox-mbr.xboxlive.com" = "192.168.16.2";
          "assets1.xboxlive.com.nsatc.net" = "192.168.16.2";
          "xvcf1.xboxlive.com" = "192.168.16.2";
          "xvcf2.xboxlive.com" = "192.168.16.2";
          "d1.xboxlive.com" = "192.168.16.2";
        };
      };

      # optional: drop all queries with following query types. Default: empty
      filtering.queryTypes = [ "AAAA" ];

      # optional: logging configuration
      log = {
        # optional: Log level (one from debug, info, warn, error). Default: info
        level = "info";
        # optional: Log format (text or json). Default: text
        format = "text";
        # optional: log timestamps. Default: true
        timestamp = true;
        # optional: obfuscate log output (replace all alphanumeric characters with *) for user sensitive data like request domains or responses to increase privacy. Default: false
        privacy = false;
      };

      # optional: Minimal TLS version that the DoH and DoT server will use
      minTlsServeVersion = "1.2";
      # if https port > 0: path to cert and key file for SSL encryption. if not set, self-signed certificate will be generated
      #certFile: server.crt
      #keyFile: server.key

      # optional: ports configuration
      ports = {
        # optional: DNS listener port(s) and bind ip address(es), default 53 (UDP and TCP). Example: 53, :53, "127.0.0.1:5353,[::1]:5353"
        dns = 53;
        # optional: Port(s) and bind ip address(es) for DoT (DNS-over-TLS) listener. Example: 853, 127.0.0.1:853
        tls = 853;
        # optional: Port(s) and optional bind ip address(es) to serve HTTPS used for prometheus metrics, pprof, REST API, DoH... If you wish to specify a specific IP, you can do so such as 192.168.0.1:443. Example: 443, :443, 127.0.0.1:443,[::1]:443
        https = 8443;
        # optional: Port(s) and optional bind ip address(es) to serve HTTP used for prometheus metrics, pprof, REST API, DoH... If you wish to specify a specific IP, you can do so such as 192.168.0.1:4000. Example: 4000, :4000, 127.0.0.1:4000,[::1]:4000
        http = 4000;
      };

      # optional: configuration for prometheus metrics endpoint
      prometheus = {
        # enabled if true
        enable = false;
        # url path, optional (default '/metrics')
        path = "/metrics";
      };

      # optional: If true, blocky will fail to start unless at least one upstream server per group is reachable. Default: false
      startVerifyUpstream = true;

      upstreams = {
        groups = {
          # these external DNS resolvers will be used. Blocky picks 2 random resolvers from the list for each query
          # format for resolver: [net:]host:[port][/path]. net could be empty (default, shortcut for tcp+udp), tcp+udp, tcp, udp, tcp-tls or https (DoH). If port is empty, default port will be used (53 for udp and tcp, 853 for tcp-tls, 443 for https (Doh))
          # this configuration is mandatory, please define at least one external DNS resolver
          default = [
            "tcp-tls:dot.libredns.gr:853"
            "tcp-tls:dot1.applied-privacy.net:853"
            "tcp-tls:dot.nl.ahadns.net:853"
            "tcp-tls:dot.la.ahadns.net:853"
            "https://doh.mullvad.net/dns-query"
            "https://doh-jp.blahdns.com/dns-query"
          ];

          # optional: use client name (with wildcard support: * - sequence of any characters, [0-9] - range)
          # or single ip address / client subnet as CIDR notation
          "192.168.4.0/24" = [
            "https://dnsnl.alekberg.net/dns-query"
            "https://dnsse.alekberg.net/dns-query"
            "https://doh.dns.sb/dns-query"
            "https://doh.sb/dns-query"
            "https://doh.dns4all.eu/dns-query"
          ];

          "192.168.8.11/32" = [ "https://cloudflare-dns.com/dns-query" ];
          "192.168.8.50/32" = [ "https://cloudflare-dns.com/dns-query" ];
        };
        # Blocky supports different upstream strategies (default parallel_best) that determine how and to which upstream DNS servers requests are forwarded.
        strategy = "parallel_best";

        # optional: timeout to query the upstream resolver. Default: 2s
        timeout = "2s";
      };
    };
  };
}
