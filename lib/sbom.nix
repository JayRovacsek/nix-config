{ self }:
let
  inherit (self.inputs.nixpkgs.lib) mapAttrs;

  inherit (self.inputs) sbomnix;

  # Build a CycloneDX/SPDX/CSV SBOM for a single host, derived purely from the
  # host's evaluated system configuration. The host's full system closure is
  # represented by config.system.build.toplevel, so its derivation (.drv) is the
  # only thing handed to sbomnix; the surrounding package set is selected from
  # that same host's system so the SBOM tooling matches the closure it inspects.
  #
  # sbomnix shells out to `nix` to walk the closure, so the build runs outside
  # the sandbox (__noChroot). --exclude-meta keeps the run offline by skipping
  # the api.nixos.org licence enrichment, and --buildtime captures the complete
  # build-time dependency graph rather than only the runtime closure.
  #
  # The closure is large by nature (a host SBOM lists every transitive package),
  # so substitution stays enabled: the closure is fetched from the binary cache
  # rather than recompiled. Forcing allowSubstitutes=false here would make Nix
  # build all ~700 derivations instead of downloading them.
  mkHostSbom =
    name: system: toplevelDrv:
    let
      pkgs = self.common.package-sets."${system}-unstable";
    in
    pkgs.runCommand "sbom-${name}" { } ''
      mkdir -p "$out"
      ${sbomnix.packages.${system}.sbomnix}/bin/sbomnix \
        --exclude-meta \
        --buildtime \
        --cdx "$out/sbom.cdx.json" \
        --spdx "$out/sbom.spdx.json" \
        --csv "$out/sbom.csv" \
        ${toplevelDrv}
    '';

  # Generalise host SBOM generation over every evaluated configuration. Each
  # entry is keyed by host name and built from that host's own toplevel, so the
  # resulting attrset is a complete, per-host SBOM inventory of the flake.
  mkAllHostSboms =
    nixosConfigurations:
    mapAttrs (
      name: evaluation:
      let
        inherit (evaluation.config) nixpkgs system;
      in
      mkHostSbom name nixpkgs.system system.build.toplevel
    ) nixosConfigurations;

in
{
  inherit
    mkAllHostSboms
    mkHostSbom
    ;
}
