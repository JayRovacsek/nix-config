{ config, ... }: {
  environment.etc."nginx/modules/authelia/authelia-server.conf" = {
    mode = "0444";
    inherit (config.services.nginx) user group;
    text = ''
      location ^~ /authelia {
          include /config/nginx/proxy.conf;
          include /config/nginx/resolver.conf;
          set $upstream_authelia authelia${
            if builtins.hasAttr "localDomain" config.networking then
              ".${config.networking.localDomain}"
            else
              ""
          };
          proxy_pass http://$upstream_authelia:9091;
      }

      location = /authelia/api/verify {
          internal;
          if ($request_uri ~ [^a-zA-Z0-9_+-=\!@$%&*?~.:#'\;\(\)\[\]]) {
              return 401;
          }
          include /config/nginx/resolver.conf;
          set $upstream_authelia authelia${
            if builtins.hasAttr "localDomain" config.networking then
              ".${config.networking.localDomain}"
            else
              ""
          };
          proxy_pass_request_body off;
          proxy_pass http://$upstream_authelia:9091;
          proxy_set_header Content-Length "";

          # Timeout if the real server is dead
          proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

          # [REQUIRED] Needed by Authelia to check authorizations of the resource.
          # Provide either X-Original-URL and X-Forwarded-Proto or
          # X-Forwarded-Proto, X-Forwarded-Host and X-Forwarded-Uri or both.
          # Those headers will be used by Authelia to deduce the target url of the user.
          # Basic Proxy Config
          client_body_buffer_size 128k;
          proxy_set_header Host $host;
          proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Method $request_method;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Host $http_host;
          proxy_set_header X-Forwarded-Uri $request_uri;
          proxy_set_header X-Forwarded-Ssl on;
          proxy_redirect  http://  $scheme://;
          proxy_http_version 1.1;
          proxy_set_header Connection "";
          proxy_cache_bypass $cookie_session;
          proxy_no_cache $cookie_session;
          proxy_buffers 4 32k;

          # Advanced Proxy Config
          send_timeout 5m;
          proxy_read_timeout 240;
          proxy_send_timeout 240;
          proxy_connect_timeout 240;
      }
    '';
  };
}
