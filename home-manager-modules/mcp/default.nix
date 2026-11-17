{
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (self.packages.${pkgs.system}) rea;
in
{
  programs.mcp = {
    enable = true;

    servers = {
      # NixOS/Home Manager/nix-darwin package & option search
      nixos.command = "${pkgs.mcp-nixos}/bin/mcp-nixos";

      # Grafana: dashboards, datasources, Prometheus/Loki queries, alerting.
      # https://github.com/grafana/mcp-grafana
      # Requires GRAFANA_URL and GRAFANA_SERVICE_ACCOUNT_TOKEN in the
      # environment at runtime.
      grafana.command = "${pkgs.mcp-grafana}/bin/mcp-grafana";

      # Up-to-date library documentation from context7.com.
      # https://github.com/upstash/context7
      # Optional CONTEXT7_API_KEY in the environment for higher rate limits.
      context7.command = "${pkgs.context7-mcp}/bin/context7-mcp";

      # Firefox DevTools automation via WebDriver BiDi: page navigation, DOM
      # snapshots, console and network inspection.
      # https://github.com/mozilla/firefox-devtools-mcp
      # Auto-detects a `firefox` binary on PATH at runtime (provided by the
      # desktop home package set).
      firefox-devtools.command = "${pkgs.firefox-devtools-mcp}/bin/firefox-devtools-mcp";
    }
    # REA — Reverse Engineer Anything: MCP server for reverse engineering
    # native binaries, managed assemblies, JavaScript/Electron apps and
    # more. https://github.com/morluto/rea (packaged in packages/other/rea,
    # which only supports x86_64-linux)
    // lib.optionalAttrs (lib.meta.availableOn pkgs.stdenv.hostPlatform rea) {
      rea = {
        command = "${rea}/bin/rea";
        args = [ "mcp" ];
      };
    };
  };
}
