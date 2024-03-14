{ writeTextFile, ... }:
# TODO: figure if I can ever remove the hardcoded site value on the 
# last line of the config
writeTextFile {
  name = "authelia-authrequest.conf";
  text = ''
    ## Send a subrequest to Authelia to verify if the user is authenticated and has permission to access the resource.
    auth_request /authelia;

    ## Set the $target_url variable based on the original request.

    ## Comment this line if you're using nginx without the http_set_misc module.
    # set_escape_uri $target_url $scheme://$http_host$request_uri;

    ## Uncomment this line if you're using NGINX without the http_set_misc module.
    set $target_url $scheme://$http_host$request_uri;

    ## Save the upstream response headers from Authelia to variables.
    auth_request_set $user $upstream_http_remote_user;
    auth_request_set $groups $upstream_http_remote_groups;
    auth_request_set $name $upstream_http_remote_name;
    auth_request_set $email $upstream_http_remote_email;

    ## Inject the response headers from the variables into the request made to the backend.
    proxy_set_header Remote-User $user;
    proxy_set_header Remote-Groups $groups;
    proxy_set_header Remote-Name $name;
    proxy_set_header Remote-Email $email;

    ## If the subreqest returns 200 pass to the backend, if the subrequest returns 401 redirect to the portal.
    error_page 401 =302 https://authelia.rovacsek.com/?rd=$target_url;
  '';
}
