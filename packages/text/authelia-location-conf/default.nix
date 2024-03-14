{ self, writeTextFile, ... }:
let inherit (self.common.networking.services) authelia;
in writeTextFile {
  name = "authelia-location.conf";

  text = ''
    set $upstream_authelia ${authelia.protocol}://${authelia.ipv4}:${
      builtins.toString authelia.port
    }/api/verify;

    ## Virtual endpoint created by nginx to forward auth requests.
    location /authelia {
        ## Essential Proxy Configuration
        internal;
        proxy_pass $upstream_authelia;

        ## Headers
        ## The headers starting with X-* are required.
        proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
        proxy_set_header X-Original-Method $request_method;
        proxy_set_header X-Forwarded-Method $request_method;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-Uri $request_uri;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Content-Length "";
        proxy_set_header Connection "";

        ## Basic Proxy Configuration
        proxy_pass_request_body off;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503; # Timeout if the real server is dead
        proxy_redirect http:// $scheme://;
        proxy_http_version 1.1;
        proxy_cache_bypass $cookie_session;
        proxy_no_cache $cookie_session;
        proxy_buffers 4 32k;
        client_body_buffer_size 128k;

        ## Advanced Proxy Configuration
        send_timeout 5m;
        proxy_read_timeout 240;
        proxy_send_timeout 240;
        proxy_connect_timeout 240;
    }
  '';
}
