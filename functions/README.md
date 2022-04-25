# My nix functions

![What in tarnation](https://github.com/JayRovacsek/ncsg-presentation-feb-2022/blob/main/resources/what-in.jpg?raw=true)

During the course of moving into more serious nixification, it became clear that some code was going to be best abstracted into functions to be reused. Please find below short explainations/examples.

## docker.nix
Mostly inspired by Portainer initially, this just enables the configuration of a docker host to be split from the generated config enabling what I believe is clearer code. Examples of this are my:
* [stack folder](https://github.com/JayRovacsek/nix-config/tree/main/modules/docker/stacks)
* [config folder](https://github.com/JayRovacsek/nix-config/tree/main/modules/docker/configs)

Admittedly, this could be removed in the future and was just a relic of learning nix a bit better.

### Output
The output simply wraps a default docker configuration set with the service name, e.g:
```nix
rec {
  autoStart = true;
  image = "portainer/portainer-ce:alpine";
  serviceName = "portainer";
  ports = [ "0.0.0.0:9000:9000" ];
  volumes = [
    "/var/run/docker.sock:/var/run/docker.sock"
    "/mnt/zfs/containers/portainer:/data"
    "/etc/passwd:/etc/passwd:ro"
  ];
  environment = { TZ = "Australia/Sydney"; };
  extraOptions = [ "--name=${serviceName}" "--network=bridge" ];
}
```
Becomes:
```nix
{
  portainer = {
    autoStart = true;
    image = "portainer/portainer-ce:alpine";
    serviceName = "portainer";
    ports = [ "0.0.0.0:9000:9000" ];
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
      "/mnt/zfs/containers/portainer:/data"
      "/etc/passwd:/etc/passwd:ro"
    ];
    environment = { TZ = "Australia/Sydney"; };
    extraOptions = [ "--name=${serviceName}" "--network=bridge" ];
  };
}
```

Which we can use for any number of docker configs to map against `virtualisation.oci-containers.containers` assuming the service name does not collide with another service name

## home-manager.nix
This function was created to solve the problem that was needing to include usernames (a dynamic property) in configs such as alacritty, firefox etc.

This function depends on a folder `hosts` existing in the root of the directory, a subfolder of `$hostname` as well as the following files existing in each `$hostname` directory:

* user-modules.nix
* users.nix

The function does require:

* home-manager
* hostname
* a boolean of if the system is linux or not (as darwin doesn't support required systemd features) - _this has a default true so no need to include it if you are using linux_

As the `users.nix` file is assumed to be utilised also by the `map-reduce-users` function it is safe to assume we can use all usernames in this function to generate a suitable home-manager configuration.

User modules _cannot_ be used interchangably as system modules if defined the same way that I have used [e.g](https://github.com/JayRovacsek/nix-config/blob/5f37e2d5c6c9fc0d9013a3196777c8d8ccc5f203/modules/firefox/default.nix#L1):
```nix
{
  programs.firefox = {
      enable = true;
  }
}
``` 

If you require a package to be both utilised as a system module as well as a user module, it may be best to rename the import to include a distinct identifier enabling you to use a similar construct to below:

Example for system import: 
```nix
{
  imports = [
    ../../modules/firefox-system
  ];
}
```

Example for user import: 
```nix
{
  imports = [
    ../../modules/firefox-user
  ];
}
```

I can't honestly see why you'd want the above however.

### Extra Modules
This function also has an optional extraModules parameter, populate it with any number of modules such as `nixos-hardware` or alike.

### System Packages
System packages that are not wanted per-user should be defined via the `environment.systemPackages` value, however as home-manager is happy to wrap packages per user we can also include a list of packages in our imports list for `user-modules.nix`. If we do this we _need_ to use the `home.packages` value not environment value ([for example](https://github.com/JayRovacsek/nix-config/blob/5f37e2d5c6c9fc0d9013a3196777c8d8ccc5f203/hosts/alakazam/user-modules.nix#L11))

### Output
The output of this function is an array of modules to be loaded. Notably this function will handle any number of users on a system via the `home-manager.users` property of the system. This occurs as each `user-module` passed to the function will generate a unique set for the associated user, e.g using firefox with the user `foo` and `bar` would create:
```nix
{
    foo.programs.firefox.enable = true;
    bar.programs.firefox.enable = true;
}
```

The above of-course is simplified, but any options in a user module are inherited by system users, e.g
```nix
{
    foo.programs.firefox = {
        enable = true;
        settings."foo"= true;
    };
    bar.programs.firefox = {
        enable = true;
        settings."foo"= true;
    };
}
```
