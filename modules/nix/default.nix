{ config, arch ? "x86_64-linux", flake ? { }, ... }: {

  imports = [ (import ./${arch}.nix { inherit config flake; }) ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
