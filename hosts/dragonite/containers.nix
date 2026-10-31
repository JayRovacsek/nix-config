{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  containerHostnames = builtins.attrNames config.containers;

  path-file = s: lib.last (lib.splitString "/" s);

  agenixRules = builtins.foldl' (
    acc: container:
    acc
    ++ (builtins.map (
      y:
      "C /agenix/${config.containers.${container}.config.systemd.machineId}/${path-file y} - - - - ${y}"
    ) config.containers.${container}.config.age.identityPaths)
  ) [ ] containerHostnames;

  parent = "10-wired";

  inherit (lib)
    mapAttrsToList
    concatLists
    unique
    ;

  # ---------------------------------------------------------------------------
  # Per-container state directories
  #
  # Ephemeral containers rebuild /etc from their derivation on every start,
  # so any FHS file that must survive a restart is kept on dragonite under
  # /var/lib/$HOSTNAME, mirroring the FHS layout, and bind-mounted into the
  # container at its canonical path. Only curated files are mapped - never
  # the container's whole root - and the set is extensible: extend
  # `stateFilesFor` below (or a host's `shares`) to retain further FHS paths.
  #
  # This mirrors the microvm convention in modules/impermanence (per-guest
  # state keyed by machine id); containers use the hostname so the layout
  # stays discoverable.
  # ---------------------------------------------------------------------------

  # The container's own evaluated config (machine-id, ssh keys, ...).
  containerConfig = name: config.containers.${name}.config or { };

  # FHS files every container retains, as { name -> { path, mode, content } }.
  # The machine-id is the repo standard (md5 of hostname via the
  # systemd.machineId option). ssh host keys are included when the host
  # declares programs.ssh.publicHostKeyBase64; the keypair itself is
  # generated and owned on dragonite (secrets never live in this repo), so
  # those entries carry no store source (content = null) and are
  # bind-mounted exactly as they exist on disk.
  stateFilesFor =
    name:
    let
      cfg = containerConfig name;
      machineId = cfg.systemd.machineId or (builtins.hashString "md5" name);
      hasSshKeys = (cfg.programs.ssh.publicHostKeyBase64 or null) != null;
    in
    {
      machineId = {
        path = "etc/machine-id";
        mode = "0644";
        content = pkgs.writeText "machine-id-${name}" "${machineId}\n";
      };
    }
    // lib.optionalAttrs hasSshKeys {
      sshHostKey = {
        path = "etc/ssh/ssh_host_ed25519_key";
        mode = "0600";
        content = null;
      };
      sshHostKeyPub = {
        path = "etc/ssh/ssh_host_ed25519_key.pub";
        mode = "0644";
        content = null;
      };
    };

  # Seed the store-backed state files on dragonite. `C` copies from the
  # store only when the path is absent, so on-disk rotations survive rebuilds
  # (same semantics as the agenix identity rules above). Entries without a
  # store source (host-managed ssh keys) are skipped.
  stateFileRules = concatLists (
    map (
      name:
      mapAttrsToList (_n: f: "C /var/lib/${name}/${f.path} ${f.mode} root root - - ${f.content}") (
        lib.filterAttrs (_n: f: f.content != null) (stateFilesFor name)
      )
    ) containerHostnames
  );

  # Host paths of the state files; excluded from the `d` directory rules
  # below since they are files, not directories.
  stateHostPaths = name: mapAttrsToList (_n: f: "/var/lib/${name}/${f.path}") (stateFilesFor name);

  # Extract all bind mount host paths from all containers
  bindMountHostPaths = unique (
    concatLists (
      mapAttrsToList (
        containerName: containerCfg:
        builtins.filter (path: !(builtins.elem path (stateHostPaths containerName))) (
          mapAttrsToList (_mountName: mountCfg: mountCfg.hostPath) (containerCfg.bindMounts or { })
        )
      ) (config.containers or { })
    )
  );

  varLibRules = builtins.map (path: "d ${path} 0755 root root - -") bindMountHostPaths;

  partyMembers = [
    "bellsprout"
    "igglybuff"
    "machop"
    "mankey"
    "meowth"
    "mr-mime"
    "natu"
    "nidoking"
    "nidorina"
    "nidorino"
    "oddish"
    "poliwag"
    "porygon"
    "slowpoke"
  ];

  partyCommonConfigs = builtins.filter (x: builtins.elem x.hostname partyMembers) (
    builtins.attrValues self.common.config.hosts
  );

  partyVlans = builtins.filter (
    x: builtins.elem x.name (builtins.map (x: x.vlan) partyCommonConfigs)
  ) self.common.config.networks;

  vlans = builtins.map (x: {
    inherit (x) name vlan-tag;
    bridge = "br-${x.name}";
  }) partyVlans;

  party = builtins.map (x: {
    name = x.hostname;
    inherit (x) macAddress vlan shares;
    container = x.container or { };
  }) partyCommonConfigs;
in
{
  systemd.tmpfiles.rules = varLibRules ++ agenixRules ++ stateFileRules;

  containers = builtins.foldl' (
    acc: pokemon:
    lib.recursiveUpdate acc {
      "${pokemon.name}" = pokemon.container // {
        autoStart = true;

        ephemeral = true;

        privateNetwork = true;

        localMacAddress = pokemon.macAddress;
        hostBridge = "br-${pokemon.vlan}";

        bindMounts = {
          agenix = {
            hostPath = "/agenix/${builtins.hashString "md5" pokemon.name}";
            mountPoint = "/agenix";
            isReadOnly = false;
          };
        }
        // lib.mapAttrs' (
          _name: f:
          lib.nameValuePair _name {
            hostPath = "/var/lib/${pokemon.name}/${f.path}";
            mountPoint = "/${f.path}";
            isReadOnly = true;
          }
        ) (stateFilesFor pokemon.name)
        //
          (builtins.foldl' (
            acc: share:
            acc
            // {
              "${share.name}" = {
                inherit (share)
                  hostPath
                  mountPoint
                  isReadOnly
                  ;
              };
            }
          ) { })
            pokemon.shares;

        specialArgs = { inherit self; };

        config = _: {
          nixpkgs.config = {
            allowUnfree = lib.mkForce true;
            cudaSupport = true;
          };
          age = {
            identityPaths = [
              "/agenix/id-ed25519-${pokemon.name}-primary"
            ];
          };
          container-guest.stateBindMounts = true;
          imports = [ ../${pokemon.name} ];
        };
      };
    }
  ) { } party;

  systemd.network = {
    #
    # VLAN devices
    #
    netdevs = builtins.foldl' (
      acc: vlan:
      lib.recursiveUpdate acc {

        #
        # VLAN netdev
        #
        "00-${vlan.name}" = {
          netdevConfig = {
            Kind = "vlan";
            Name = vlan.name;
          };

          vlanConfig.Id = vlan.vlan-tag;
        };

        #
        # Bridge netdev
        #
        "10-${vlan.bridge}" = {
          netdevConfig = {
            Kind = "bridge";
            Name = vlan.bridge;
          };
        };
      }
    ) { } vlans;

    networks = builtins.foldl' (
      acc: vlan:
      lib.recursiveUpdate acc {

        #
        # Parent NIC gets VLAN attached
        #
        "${parent}" = {
          vlan = (acc.${parent}.vlan or [ ]) ++ [ vlan.name ];
        };

        #
        # VLAN interface joins bridge
        #
        "20-${vlan.name}" = {
          matchConfig.Name = vlan.name;

          networkConfig = {
            Bridge = vlan.bridge;
          };
        };

        #
        # Bridge config
        #
        "30-${vlan.bridge}" = {
          matchConfig.Name = vlan.bridge;
        };
      }
    ) { } vlans;
  };
}
