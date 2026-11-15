{ self, pkgs, ... }:
{
  imports = [ ../../options/modules/halogen-flash-server ];

  networking.firewall.allowedTCPPorts = [ 11435 ];

  services.halogen-flash-server = {
    enable = true;
    enableVision = true;
    hostAddress = "0.0.0.0";
    # Run the nix-built package directly instead of the upstream OCI image.
    runtime = "package";
    applyRecommendedSystemSettings = true;
    modelDir = "/srv/halogen-models/thinking";
    checkpointFile = "qwen38-flash-next-v2.hgn";
    npu = {
      enable = true;
      models = [ "d3-nano" ];
      xrtPackage = self.packages.${pkgs.system}.xrt-amdxdna;
    };
  };
}
