# Combined XRT + amdxdna plugin tree, providing the complete
# /opt/xilinx/xrt layout (libxrt_coreutil.so.2 + libxrt_driver_xdna.so.2 in
# one lib directory) that halogen-flash-server's NPU sidecar expects at the
# hardcoded path /opt/xilinx/xrt/lib.
#
# Mirrors the xrt-amdxdna package of robcohen/nix-amd-npu (a symlinkJoin of
# the two vendored packages here). Not directly updatable by nix-update — it
# follows the versions of xrt and xrt-plugin-amdxdna.
{
  self,
  pkgs,
  lib,
  symlinkJoin,
}:
let
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system})
    xrt
    xrt-plugin-amdxdna
    ;
in
symlinkJoin {
  name = "xrt-amdxdna-${xrt.version}-${xrt-plugin-amdxdna.version}";
  paths = [
    xrt
    xrt-plugin-amdxdna
  ];
  meta = {
    description = "XRT with the AMD XDNA plugin in a single /opt/xilinx/xrt tree";
    homepage = "https://github.com/Xilinx/XRT";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
