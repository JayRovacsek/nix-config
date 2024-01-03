{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets)
    base hyprland-waybar-desktop games;
  inherit (flake.lib) merge;

  inherit (pkgs) system;
  inherit (config.flake.packages.${system}) trdsql;

  builder = common.users.builder {
    inherit config pkgs;
    modules = base;
  };

  jay = common.users.jay {
    inherit config pkgs;
    modules = hyprland-waybar-desktop ++ games;
  };

  merged = merge [ builder jay ];

in {
  inherit flake;
  inherit (merged) users home-manager;

  systemd = {
    services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
    network = {
      links."00-phys0" = {
        matchConfig.Type = "ether";
        linkConfig.Name = "phys0";
      };
    };
  };

  microvm.vms = {
    test = {
      config = {
        nixpkgs.overlays = [ flake.overlays.lib ];

        imports = [
          flake.nixosModules.blocky
          flake.nixosModules.time
          flake.nixosModules.timesyncd
          flake.nixosModules.systemd-networkd
          {
            systemd.network = {
              netdevs."00-vlan-dns" = {
                enable = true;
                netdevConfig = {
                  Kind = "vlan";
                  Name = "vlan-dns";
                };
                vlanConfig.Id = 6;
              };

              networks = {
                "00-wired" = {
                  enable = true;
                  # mkForce is utilised here to override the default systemd
                  # settings in the systemd-networkd module
                  matchConfig.Name = lib.mkForce "en*";
                  networkConfig = lib.mkForce { VLAN = "vlan-dns"; };
                  dhcpV4Config = lib.mkForce { };
                };

                "10-vlan-dns" = {
                  enable = true;
                  name = "vlan-dns";
                  networkConfig.DHCP = "ipv4";
                };
              };
            };

            services.resolved.enable = false;

            users = {
              groups.test = { };
              users = {
                root.password = "";
                test = {
                  password = "test";
                  group = "test";
                  isNormalUser = true;
                };
              };
            };

            services.openssh = {
              enable = true;
              settings.PermitRootLogin = "yes";
            };
            networking.firewall = {
              enable = false;
              allowedTCPPorts = [ 22 ];
            };
          }
          {
            microvm = {
              shares = [{
                source = "/nix/store";
                mountPoint = "/nix/.ro-store";
                tag = "ro-store";
                proto = "virtiofs";
              }];
              interfaces = [{
                type = "macvtap";
                id = "vm-test";
                mac = "02:01:27:00:00:01";
                macvtap = {
                  link = "phys0";
                  mode = "bridge";
                };
              }];
            };
          }
        ];
      };
    };
    foo = {
      config = {
        nixpkgs.overlays = [ flake.overlays.lib ];

        imports = [
          flake.nixosModules.blocky
          flake.nixosModules.time
          flake.nixosModules.timesyncd
          flake.nixosModules.systemd-networkd
          {
            services.resolved.enable = false;

            users = {
              groups.test = { };
              users = {
                root.password = "";
                test = {
                  password = "test";
                  group = "test";
                  isNormalUser = true;
                };
              };
            };

            services.openssh = {
              enable = true;
              settings.PermitRootLogin = "yes";
            };
            networking.firewall = {
              enable = false;
              allowedTCPPorts = [ 22 ];
            };
          }
          {
            microvm = {
              shares = [{
                source = "/nix/store";
                mountPoint = "/nix/.ro-store";
                tag = "ro-store";
                proto = "virtiofs";
              }];
              interfaces = [{
                type = "macvtap";
                id = "vm-foo";
                mac = "02:01:27:00:00:02";
                macvtap = {
                  link = "phys0";
                  mode = "bridge";
                };
              }];
            };
          }
        ];
      };
    };
  };

  nix.settings = {
    substituters = [ "https://microvm.cachix.org/" ];
    trusted-public-keys =
      [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  age = {
    secrets = {
      "git-signing-key" = rec {
        file = ../../secrets/ssh/git-signing-key.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        path = "/home/${owner}/.ssh/git-signing-key";
      };

      "git-signing-key.pub" = rec {
        file = ../../secrets/ssh/git-signing-key.pub.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        path = "/home/${owner}/.ssh/git-signing-key.pub";
      };

      "terraform-api-key" = rec {
        file = ../../secrets/terraform/terraform-api-key.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        mode = "400";
        path = "/home/${owner}/.terraform.d/credentials.tfrc.json";
      };
    };
    identityPaths = [
      "/agenix/id-ed25519-ssh-primary"
      "/agenix/id-ed25519-terraform-primary"
    ];
  };

  environment.systemPackages = (with pkgs; [ curl wget agenix prismlauncher ])
    ++ [ trdsql ];

  hardware.opengl.driSupport32Bit = true;

  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostId = "ef26b1be";
    hostName = "alakazam";
    useDHCP = false;
  };

  services.tailscale.tailnet = "admin";

  system.stateVersion = "22.11";
}
