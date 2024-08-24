{
  common = {
    version = 1;
    doc = "The `common` flake output defines common values across other flake outputs.";
    inventory =
      output:
      let
        recurse = attrs: {
          children = builtins.mapAttrs (
            name: value:
            if builtins.isFunction value then
              {
                # Tell `nix flake show` what this is.
                what = "function";
                # Make `nix flake check` enforce our naming convention.
                evalChecks.kebab-case = builtins.match "[a-z0-9\\-]+" name == [ ];
              }
            else if builtins.isList value then
              {
                what = "array";
                # Ensure exposed arrays within this space are not empty 
                # (otherwise they're redundant)
                evalChecks.not-empty = (builtins.length value) != 0;
              }
            else if builtins.isString value then
              {
                what = "string";
                evalChecks = { };
              }
            else if builtins.isAttrs value then
              # Recurse into nested sets of functions.
              recurse value
            else
              throw "unsupported 'lib' type"
          ) attrs;
        };
      in
      recurse output;
  };
  lib = {
    version = 1;
    doc = "The `lib` flake output defines Nix functions.";
    inventory =
      output:
      let
        recurse = attrs: {
          children = builtins.mapAttrs (
            name: value:
            if builtins.isFunction value then
              {
                # Tell `nix flake show` what this is.
                what = "library function";
                # Make `nix flake check` enforce our naming convention.
                evalChecks.kebab-case = builtins.match "[a-z0-9\\-]+" name == [ ];
              }
            else if builtins.isAttrs value then
              # Recurse into nested sets of functions.
              recurse value
            else
              throw "unsupported 'lib' type"
          ) attrs;
        };
      in
      recurse output;
  };
}
