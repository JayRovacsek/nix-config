self: super: {
  hello = super.hello.overrideAttrs (old: rec {
    pname = "hello";
    version = "9001";

    src = super.fetchurl {
      url = "mirror://gnu/hello/hello-${version}.tar.gz";
      sha256 = super.lib.fakeHash;
    };

    doCheck = false;
  });

  hello-unfree = super.hello-unfree.overrideAttrs (old: rec {
    pname = "hello-unfree";
    version = "9002";
  });
}
