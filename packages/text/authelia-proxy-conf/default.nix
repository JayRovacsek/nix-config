{ writeTextFile, ... }:
# Note the below should be injected into location blocks of vhosts
# if authelia is running
writeTextFile {
  name = "proxy.conf";
  text = ''
    # All of the below lines until next indicated are recommended/required
    # authelia options. Otherwise all requirements as per https://www.authelia.com/integration/proxies/nginx/#proxyconf
    # are achieved via the options from services.nginx:
    # * recommendedTlsSettings
    # * recommendedZstdSettings
    # * recommendedOptimisation
    # * recommendedGzipSettings
    # * recommendedProxySettings
    # * recommendedBrotliSettings
    proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
    proxy_set_header X-Forwarded-Uri $request_uri;
    proxy_set_header X-Forwarded-Ssl on;

    client_body_buffer_size 128k;
    proxy_next_upstream error timeout invalid_header http_500 http_502 http_503; 
    proxy_cache_bypass $cookie_session;
    proxy_no_cache $cookie_session;
    proxy_buffers 64 256k;

    real_ip_header X-Forwarded-For;
    real_ip_recursive on;

    # Anything below here is no longer Authelia related
  '';
}
