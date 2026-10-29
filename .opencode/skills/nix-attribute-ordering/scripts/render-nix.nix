# Render a JSON-representable Nix value as formatted Nix source.
# Attrset keys are emitted in sorted (ASCII) order; list order is preserved.
#
# Companion to the JSON round-trip gate in SKILL.md. The result is a string,
# so invoke with `nix eval --raw --impure --expr '(import ./render-nix.nix)
# (import ./<data-file>.nix { })' > <file>.nix.new`, adapt the "_: " wrapper
# below to the file's function signature, then nixfmt the output.
let
  indent = n: builtins.concatStringsSep "" (builtins.genList (_: "  ") n);

  isBareKey = s: builtins.match "[A-Za-z_][A-Za-z0-9_'-]*" s != null;

  renderKey = k: if isBareKey k then k else renderString k;

  # builtins.toJSON JSON-quotes a string; Nix accepts the same escapes, but
  # JSON leaves "$" untouched where Nix would treat "${" as interpolation.
  # Escaping every "$" is harmless: "\$" is a valid Nix escape for "$".
  # Known limit: JSON emits control characters as \uXXXX escapes, which Nix
  # does not accept; control characters in config data are vanishingly rare
  # and the JSON round-trip gate catches any breakage.
  renderString = s: builtins.replaceStrings [ "$" ] [ "\\$" ] (builtins.toJSON s);

  renderList =
    depth: vs:
    if vs == [ ] then
      "[ ]"
    else
      "[\n"
      + builtins.concatStringsSep "\n" (map (v: "${indent (depth + 1)}${render (depth + 1) v}") vs)
      + "\n${indent depth}]";

  renderAttrs =
    depth: blankBetween: as:
    let
      names = builtins.attrNames as;
      sep = if blankBetween then "\n\n" else "\n";
      lines = builtins.concatStringsSep sep (
        map (n: "${indent (depth + 1)}${renderKey n} = ${render (depth + 1) as.${n}};") names
      );
    in
    if names == [ ] then "{ }" else "{\n" + lines + "\n${indent depth}}";

  render =
    depth: v:
    if builtins.isAttrs v then
      renderAttrs depth false v
    else if builtins.isList v then
      renderList depth v
    else if builtins.isString v then
      renderString v
    else if builtins.isInt v then
      builtins.toString v
    else if builtins.isFloat v then
      # toJSON preserves float precision where toString truncates to six
      # decimals; it emits "1e+20"-style exponents for huge magnitudes,
      # which Nix rejects — the JSON gate backstops both limits.
      builtins.toJSON v
    else if builtins.isBool v then
      (if v then "true" else "false")
    else if v == null then
      "null"
    else
      builtins.abort "cannot render value of type ${builtins.typeOf v}";
in
cfg: "_: " + renderAttrs 0 true cfg + "\n"
