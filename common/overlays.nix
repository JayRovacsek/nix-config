final: prev: {
  hello = prev.hello.overrideAttrs (old: rec {
    pname = "hello";
    version = "9001";

    src = prev.fetchurl {
      url = "mirror://gnu/hello/hello-${version}.tar.gz";
      sha256 = prev.lib.fakeHash;
    };

    doCheck = false;
  });

  hello-unfree = prev.hello-unfree.overrideAttrs (old: rec {
    pname = "hello-unfree";
    version = "9002";
  });

  # Useful for SBCs when they will be missing modules that upstream definitions
  # expect but we won't use; e.g SATA
  makeModulesClosure = x:
    prev.makeModulesClosure (x // { allowMissing = true; });
}
