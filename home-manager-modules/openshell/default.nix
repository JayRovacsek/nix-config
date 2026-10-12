{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    foldl'
    groupBy
    mapAttrs
    mkIf
    mkMerge
    optionalAttrs
    recursiveUpdate
    ;

  cfg = config.services.openshell;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  bin = "${cfg.package}/bin";
  yq = "${pkgs.yq-go}/bin/yq";
  jq = "${pkgs.jq}/bin/jq";

  # Inline attribute sets become JSON files (valid YAML), files pass through.
  toFile =
    name: document:
    if builtins.isAttrs document then
      pkgs.writeText "${name}.json" (builtins.toJSON document)
    else
      "${document}";

  toFiles = name: map (toFile name);

  # Deep merge all documents into one, later documents win.
  mergeDocuments =
    name: documents:
    pkgs.runCommand "${name}.json" { } ''
      ${yq} -o json -I0 '.' ${toString (toFiles name documents)} \
        | ${jq} -s 'reduce .[] as $x ({}; . * $x)' > $out
    '';

  # Fail the build if a policy exceeds the configured boundary.
  proveWithinBoundary =
    name: policy:
    if cfg.boundaryPolicy == null then
      policy
    else
      pkgs.runCommand "${name}-proven.json" { } ''
        ${bin}/openshell-prover check --boundary ${toFile "boundary" cfg.boundaryPolicy} ${policy}
        cp ${policy} $out
      '';

  # One file per provider id, deep merged so later entries win.
  providersDir = pkgs.runCommand "openshell-providers" { } ''
    mkdir -p $out
    ${lib.optionalString (cfg.providers != [ ]) ''
      ${yq} -o json -I0 '.' ${toString (toFiles "provider" cfg.providers)} \
        | ${jq} -sc 'group_by(.id) | map(reduce .[] as $x ({}; . * $x)) | .[]' \
        | while read -r profile; do
            id="$(echo "$profile" | ${jq} -r '.id')"
            echo "$profile" > "$out/$id.yaml"
          done
    ''}
  '';

  sandboxPolicy = proveWithinBoundary "openshell-sandbox-policy" (
    mergeDocuments "openshell-sandbox-policy" cfg.policies
  );

  globalPolicy =
    if cfg.globalPolicy == null then
      null
    else
      proveWithinBoundary "openshell-global-policy" (toFile "openshell-global-policy" cfg.globalPolicy);

  # Merge gateway entries by name, later entries win.
  gateways = mapAttrs (
    name: entries:
    foldl' recursiveUpdate {
      settings.openshell = {
        version = 2;
        gateway = {
          inherit name;
          bind_address = "127.0.0.1:17670";
          compute_driver = "docker";
          disable_tls = true;
          auth.allow_unauthenticated_users = true;
        };
      };
      environment = { };
    } (map (entry: removeAttrs entry [ "name" ]) entries)
  ) (groupBy (entry: entry.name) cfg.gateways);

  endpoint = gateway: "http://${gateway.settings.openshell.gateway.bind_address}";

  # Validated at build time, without starting the gateway.
  gatewayConfig =
    name: gateway:
    let
      file = (pkgs.formats.toml { }).generate "openshell-gateway-${name}.toml" gateway.settings;
    in
    pkgs.runCommand "openshell-gateway-${name}.toml" { } ''
      HOME="$TMPDIR" ${bin}/openshell-gateway --config ${file} config preflight
      cp ${file} $out
    '';

  gatewayEnvironment =
    name: gateway:
    {
      # Keep each gateway's database separate.
      XDG_STATE_HOME = "${config.xdg.stateHome}/openshell/gateways/${name}";
    }
    // gateway.environment;

  gatewayCommand = name: gateway: [
    "${bin}/openshell-gateway"
    "--config"
    "${gatewayConfig name gateway}"
  ];

  # Reconcile the gateway database with the declared providers and policy.
  loadScript =
    name: gateway:
    pkgs.writeShellScript "openshell-load-${name}" ''
      set -euo pipefail
      export OPENSHELL_GATEWAY_ENDPOINT=${lib.escapeShellArg (endpoint gateway)}
      openshell=${bin}/openshell

      for ((i = 0; i < 120; i++)); do
        "$openshell" status >/dev/null 2>&1 && break
        sleep 1
      done

      "$openshell" provider profile list --global -o json \
        | ${jq} -r '.[].id' \
        | while read -r id; do
            "$openshell" provider profile delete --global "$id"
          done

      ${lib.optionalString (cfg.providers != [ ]) ''
        "$openshell" provider profile import --global --from ${providersDir}
      ''}

      ${
        if globalPolicy == null then
          ''"$openshell" policy delete --global --yes''
        else
          ''"$openshell" policy set --global --yes --policy ${globalPolicy}''
      }
    '';

  forEachGateway = f: lib.concatMapAttrs f gateways;
in
{
  imports = [ ../../options/home-manager-modules/openshell ];

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = isDarwin || isLinux;
          message = "services.openshell supports only Linux and Darwin.";
        }
        {
          assertion =
            let
              addresses = lib.mapAttrsToList (_: g: g.settings.openshell.gateway.bind_address) gateways;
            in
            lib.length addresses == lib.length (lib.unique addresses);
          message = "services.openshell.gateways: each gateway name needs a distinct bind_address.";
        }
      ];

      home.packages = [ cfg.package ];

      # The CLI targets the first gateway (by name) unless told otherwise.
      home.sessionVariables =
        optionalAttrs (gateways != { }) {
          OPENSHELL_GATEWAY_ENDPOINT = endpoint (lib.head (lib.attrValues gateways));
        }
        // optionalAttrs (cfg.policies != [ ]) {
          OPENSHELL_SANDBOX_POLICY = "${sandboxPolicy}";
        };

      programs.opencode.skills = mkIf (cfg.opencode.enable && config.programs.opencode.enable) (
        lib.genAttrs [
          "debug-inference"
          "debug-openshell-cluster"
          "generate-sandbox-policy"
          "openshell-cli"
        ] (skill: "${cfg.sharedPackage}/share/skills/${skill}")
      );
    }

    {
      systemd.user.services = mkIf isLinux (
        forEachGateway (
          name: gateway: {
            "openshell-gateway-${name}" = {
              Unit.Description = "OpenShell gateway ${name}";
              Service = {
                ExecStart = lib.escapeShellArgs (gatewayCommand name gateway);
                Environment = lib.mapAttrsToList (k: v: "${k}=${v}") (gatewayEnvironment name gateway);
                Restart = "on-failure";
              };
              Install.WantedBy = [ "default.target" ];
            };

            "openshell-load-${name}" = {
              Unit = {
                Description = "Load OpenShell providers and policies into gateway ${name}";
                After = [ "openshell-gateway-${name}.service" ];
                Requires = [ "openshell-gateway-${name}.service" ];
                PartOf = [ "openshell-gateway-${name}.service" ];
              };
              Service = {
                Type = "oneshot";
                ExecStart = "${loadScript name gateway}";
              };
              Install.WantedBy = [ "openshell-gateway-${name}.service" ];
            };
          }
        )
      );

      launchd.agents = mkIf isDarwin (
        forEachGateway (
          name: gateway: {
            "openshell-gateway-${name}" = {
              enable = true;
              config = {
                ProgramArguments = gatewayCommand name gateway;
                EnvironmentVariables = gatewayEnvironment name gateway;
                KeepAlive = true;
                RunAtLoad = true;
                StandardOutPath = "${config.home.homeDirectory}/Library/Logs/openshell-gateway-${name}.log";
                StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/openshell-gateway-${name}.log";
              };
            };

            # launchd has no unit ordering, the script waits for the gateway.
            "openshell-load-${name}" = {
              enable = true;
              config = {
                ProgramArguments = [ "${loadScript name gateway}" ];
                RunAtLoad = true;
                StandardOutPath = "${config.home.homeDirectory}/Library/Logs/openshell-load-${name}.log";
                StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/openshell-load-${name}.log";
              };
            };
          }
        )
      );
    }
  ]);
}
