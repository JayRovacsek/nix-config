{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  # ---------------------------------------------------------------------------
  # mkOpencodeSource: Generic builder for external agent/skill/command sources
  #
  # Takes a source (fetchFromGitHub or flake input), applies patch rules to
  # strip unwanted frontmatter from .md files, then copies selected component
  # subdirectories into a normalised $out/{agents,skills,commands}/ structure.
  # ---------------------------------------------------------------------------
  mkOpencodeSource =
    pkgs:
    {
      name,
      src,
      patchRules ? [ ],
      components ? { },
    }:
    let
      agentPaths = components.agents or [ ];
      skillPaths = components.skills or [ ];
      commandPaths = components.commands or [ ];

      # Generate sed delete-line commands for each patch rule regex
      sedArgs = lib.concatMapStringsSep " " (
        pattern: "-e '/${pattern}/d'"
      ) patchRules;

      patchPhase = lib.optionalString (
        patchRules != [ ]
      ) "find . -name '*.md' -type f -exec ${pkgs.gnused}/bin/sed -i ${sedArgs} {} +";

      # Copy a list of source subdirectories into a target directory,
      # preserving internal structure. Note: cp -rT is last-wins on
      # filename conflicts (unlike symlinkJoin which is first-wins).
      # This is safe here because paths come from a single upstream repo.
      copyComponents =
        targetDir: paths:
        lib.concatMapStringsSep "\n" (srcPath: ''
          if [ -d "${srcPath}" ]; then
            cp -rT "${srcPath}" "$out/${targetDir}"
          fi
        '') paths;
    in
    pkgs.stdenv.mkDerivation {
      inherit name src;

      dontBuild = true;
      dontFixup = true;

      nativeBuildInputs = lib.optional (patchRules != [ ]) pkgs.gnused;

      postPatch = patchPhase;

      installPhase = ''
        mkdir -p $out/{agents,skills,commands}
        ${copyComponents "agents" agentPaths}
        ${copyComponents "skills" skillPaths}
        ${copyComponents "commands" commandPaths}
      '';
    };

  # ---------------------------------------------------------------------------
  # mkMcpServer: Declarative MCP server builder
  #
  # Supports three invocation patterns:
  #   1. Flake ref: `nix run <flakeRef> -- [args]`  (for non-nixpkgs flakes)
  #   2. Store path: `<pkg>/bin/<binary> [args]`     (for nixpkgs packages)
  #   3. Remote URL: SSE/HTTP endpoint               (for hosted MCP servers)
  #
  # Exactly one of { flakeRef, command, url } must be provided.
  # ---------------------------------------------------------------------------
  mkMcpServer =
    {
      name,
      flakeRef ? null,
      command ? null,
      url ? null,
      args ? [ ],
      env ? { },
      headers ? { }, # HTTP headers for remote MCP servers (e.g., Authorization)
    }:
    let
      hasFlakeRef = flakeRef != null;
      hasCommand = command != null;
      hasUrl = url != null;

      localBase =
        if hasFlakeRef then
          {
            type = "local";
            command = [
              "nix"
              "run"
              flakeRef
              "--"
            ]
            ++ args;
          }
        else
          {
            type = "local";
            command = command ++ args;
          };

      remoteBase = {
        type = "remote";
        inherit url;
      };

      base = if hasUrl then remoteBase else localBase;

      # Only include env/headers when non-empty
      envAttr = lib.optionalAttrs (env != { }) { inherit env; };
      headersAttr = lib.optionalAttrs (headers != { }) { inherit headers; };
    in
    assert lib.assertMsg (
      (lib.count (x: x) [
        hasFlakeRef
        hasCommand
        hasUrl
      ]) == 1
    ) "mkMcpServer '${name}': exactly one of flakeRef, command, or url must be set";
    assert lib.assertMsg (
      !(hasUrl && args != [ ])
    ) "mkMcpServer '${name}': 'args' cannot be used with remote 'url' servers";
    assert lib.assertMsg (
      !(!hasUrl && headers != { })
    ) "mkMcpServer '${name}': 'headers' can only be used with remote 'url' servers";
    {
      ${name} = base // envAttr // headersAttr;
    };

  # ---------------------------------------------------------------------------
  # mkOpencodeAttrs: Extract per-entry attrsets from an mkOpencodeSource drv
  #
  # NOTE: This uses Import From Derivation (IFD). builtins.readDir is called
  # on derivation output paths ("${drv}/agents", etc.), which forces the
  # derivation to be built during Nix evaluation rather than at build time.
  #
  # Trade-offs:
  #   - IFD is necessary because external sources (fetchFromGitHub) are opaque
  #     derivations whose output contents cannot be enumerated at eval time
  #     without building them first.
  #   - Performance: the derivation must be realised during `nix eval` / module
  #     evaluation. These are small copy-only derivations so the cost is low
  #     once cached (fixed-output fetch + trivial installPhase).
  #   - Compatibility: IFD works with both CppNix and Lix. Some CI evaluators
  #     (e.g. Hydra with restrict-eval) may reject IFD — this repo does not
  #     use Hydra, so that is acceptable.
  #
  # Produces: { agents = { name = path; ... }; skills = { ... }; commands = { ... }; }
  # ---------------------------------------------------------------------------
  mkOpencodeAttrs =
    drv:
    let
      # Enumerate .md files in a subdirectory, stripping the .md suffix from keys.
      enumerateMdFiles =
        subdir:
        let
          dir = "${drv}/${subdir}";
          entries = builtins.readDir dir;
          mdEntries = lib.filterAttrs (
            name: type: (type == "regular" || type == "symlink") && lib.hasSuffix ".md" name
          ) entries;
        in
        lib.mapAttrs' (
          name: _:
          lib.nameValuePair (lib.removeSuffix ".md" name) (
            builtins.path {
              path = "${dir}/${name}";
              name = "opencode-${subdir}-${lib.removeSuffix ".md" name}";
            }
          )
        ) mdEntries;

      # Enumerate skill directories (or symlinks to directories).
      # Returns { skill-name = /nix/store/...-opencode-skill-<name>; ... }
      enumerateSkillDirs =
        let
          dir = "${drv}/skills";
          entries = builtins.readDir dir;
          dirEntries = lib.filterAttrs (
            _: type: type == "directory" || type == "symlink"
          ) entries;
        in
        lib.mapAttrs' (
          name: _:
          lib.nameValuePair name (
            builtins.path {
              path = "${dir}/${name}";
              name = "opencode-skill-${name}";
            }
          )
        ) dirEntries;
    in
    {
      agents = enumerateMdFiles "agents";
      skills = enumerateSkillDirs;
      commands = enumerateMdFiles "commands";
    };
in
{
  inherit mkOpencodeSource mkMcpServer mkOpencodeAttrs;
}
