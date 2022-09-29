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

  # rust-bin.stable.latest.default =
  #   super.rust-bin.stable.latest.default.overrideAttrs (old: rec {
  #     extensions = [ "rust-src" ];
  #     targets = [ "arm-unknown-linux-gnueabihf" ];
  #   });

  # Required to fix the pname being fzf-zsh-unstable and therefore causing
  # pain in oh-my-custom
  fzf-zsh = super.fzf-zsh.overrideAttrs (old: rec { pname = "fzf-zsh"; });

  # Useful for SBCs when they will be missing modules that upstream definitions
  # expect but we won't use; e.g SATA
  makeModulesClosure = x:
    super.makeModulesClosure (x // { allowMissing = true; });
}
