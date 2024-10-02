{ pkgs, ... }:
{
  # Add extended options to linux builders
  imports = [ ../../options/modules/linux-builder ];

  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 4;
    config = {
      # Enable cross compilation of the below systems via qemu
      # This requires a list that does not match the system of the host
      # transposed to linux; hence the filter.
      boot.binfmt.emulatedSystems =
        builtins.filter (x: x != "${pkgs.stdenv.hostPlatform.uname.processor}-linux")
          [
            "aarch64-linux"
            "x86_64-linux"
            "armv6l-linux"
            "armv7l-linux"
          ];

      nix.settings = {
        sandbox = true;
        substituters = [ "https://binarycache.rovacsek.com/" ];
        trusted-public-keys = [
          "binarycache.rovacsek.com:xhZ1vkz2OQdHK/ex2ByA2GeziZoehrNHJCeMo7Afvr8="
        ];
      };

      virtualisation = {
        cores = 6;
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
      };
    };
  };
}
