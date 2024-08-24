{
  lib,
  fetchurl,
  buildNpmPackage,
  nodejs,
}:
let
  pname = "xmlbuilder";
  version = "15.1.1";

  meta = with lib; {
    homepage = "https://github.com/oozcitak/xmlbuilder-js";
    description = "An XML builder for node.js similar to java-xmlbuilder.";
    license = licenses.mit;
  };

  src = fetchurl {
    hash = "sha256-xK9u8Hn2X1YCzhPJ4Wp4yxoiks3U7CUGGWKLs81gCZg=";
    url = "https://github.com/oozcitak/xmlbuilder-js/archive/refs/tags/v${version}.tar.gz";
  };

  dontNpmBuild = true;
  npmBuildScript = "prepublish";
  npmDepsHash = "sha256-oMEAQpr0HdNiBTD36u+0BG2jqYgu2l626sQd5tI6FPA=";

in
buildNpmPackage {
  inherit
    pname
    version
    src
    meta
    nodejs
    npmDepsHash
    dontNpmBuild
    npmBuildScript
    ;
}
