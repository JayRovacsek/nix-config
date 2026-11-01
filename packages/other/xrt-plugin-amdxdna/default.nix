# The AMD XDNA runtime plugin (libxrt_driver_xdna.so.2) for XRT — the
# userspace shim that lets XRT drive the amdxdna NPU driver. Required by
# halogen-flash-server's NPU sidecar alongside libxrt_coreutil (see
# packages/other/xrt-amdxdna).
#
# Vendored from robcohen/nix-amd-npu@8848c6f3382852290ac25fbe7634058c4e9c037e
# (pkgs/xrt-plugin-amdxdna/default.nix, MIT; reviewed per extension
# supply-chain policy). Upstream: https://github.com/amd/xdna-driver
# (Apache-2.0). Five changes from the vendored source:
# - the source is pinned to the actual 2.21.75 tag: the vendored file used
#   rev 202610.2.21.21 (the XRT version string), which does not exist on
#   amd/xdna-driver (its only tag is 2.21.75, the matching 2.21-series
#   release);
# - the XRT source tree for internal headers comes from xrt.src instead of a
#   second fetchFromGitHub, so the headers can never drift from the XRT build
#   the plugin links against;
# - the XRT version string and numeric version defines are derived from the
#   linked xrt version instead of hardcoded constants;
# - C++17 is pinned via -DCMAKE_CXX_STANDARD=17: gcc 16 defaults to C++20,
#   where libstdc++ removed the legacy std::memory_order::memory_order_seq_cst
#   spelling the shim sources use;
# - postPatch rewrites the shim's `#include "core/common/smi.h"` to
#   `core/common/smi/smi.h`, where XRT 2.23 relocated the header.
{
  self,
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  git,
  python3,
  boost,
  rapidjson,
  libdrm,
  elfutils,
  libuuid,
  libsystemtap,
}:
let
  xrt = self.packages.${pkgs.stdenv.hostPlatform.system}.xrt;

  # The XRT version embedded in the plugin's generated version.h, derived
  # from the linked XRT version (202610.2.23.244 -> 2.23.244).
  xrtVersionParts = lib.splitString "." xrt.version;
  xrtVersion = lib.concatStringsSep "." (lib.tail xrtVersionParts);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xrt-plugin-amdxdna";
  # Literal (rather than inherited from xrt) so nix-update can rewrite it
  # when amd/xdna-driver publishes a new tag; src.rev follows via
  # finalAttrs.version.
  version = "2.21.75";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "xdna-driver";
    rev = finalAttrs.version;
    hash = "sha256-bBiI42bwap6O59MQdIylX7uz+fLUF75RTyNWTJfAFds=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    git
    python3
  ];

  buildInputs = [
    boost
    rapidjson
    libdrm
    elfutils
    libuuid
    libsystemtap
    xrt
  ];

  # Build from the source root with the wrapper CMakeLists.txt created in
  # postPatch (cmakeDir = ".." selects it over src/CMakeLists.txt).
  cmakeDir = "..";

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${lib.placeholder "out"}"
    "-DCMAKE_BUILD_TYPE=Release"
    # Pin C++17: gcc 16 defaults to C++20, where libstdc++ removed the
    # legacy `std::memory_order::memory_order_seq_cst` enumerator spelling
    # used by the shim sources.
    "-DCMAKE_CXX_STANDARD=17"
    "-DXRT_VERSION_STRING=${xrtVersion}"
    # Point to the XRT installation for libraries.
    "-DXRT_INSTALL_DIR=${xrt}/opt/xilinx/xrt"
    # Point to the XRT source tree for internal headers.
    "-DXRT_SOURCE_DIR=${xrt.src}/src"
  ];

  postPatch = ''
    # Disable Werror (also -Werror=... forms).
    find . -name "CMakeLists.txt" -exec sed -i \
      -e 's/-Werror=[A-Za-z0-9_.-]*//g' -e 's/-Werror\b//g' {} \; || true

    # XRT 2.23 relocated core/common/smi.h to core/common/smi/smi.h;
    # rewrite the plugin's includes to the new location.
    grep -rlZ '#include "core/common/smi.h"' src 2>/dev/null \
      | xargs -0r sed -i 's|#include "core/common/smi.h"|#include "core/common/smi/smi.h"|' || true

    # Remove the testing install commands for XRT targets (they don't exist
    # in upstream mode).
    sed -i '/install(TARGETS.*XRT_CORE_TARGET/d' src/shim/CMakeLists.txt
    sed -i '/install(TARGETS.*XRT_COREUTIL_TARGET/d' src/shim/CMakeLists.txt
    sed -i '/install(TARGETS.*XDNA_TARGET.*DESTINATION.*XDNA_BIN_DIR/d' src/shim/CMakeLists.txt

    # Create a wrapper CMakeLists.txt that defines IMPORTED targets for XRT.
    cat > CMakeLists.txt << 'CMAKEOF'
    cmake_minimum_required(VERSION 3.18)
    project(xrt-plugin-amdxdna)

    # XRT upstream mode
    set(XRT_UPSTREAM ON)

    # Create IMPORTED targets for XRT libraries
    add_library(xrt_core SHARED IMPORTED)
    set_target_properties(xrt_core PROPERTIES
      IMPORTED_LOCATION "''${XRT_INSTALL_DIR}/lib/libxrt_core.so"
      INTERFACE_INCLUDE_DIRECTORIES "''${XRT_INSTALL_DIR}/include"
    )

    add_library(xrt_coreutil SHARED IMPORTED)
    set_target_properties(xrt_coreutil PROPERTIES
      IMPORTED_LOCATION "''${XRT_INSTALL_DIR}/lib/libxrt_coreutil.so"
      INTERFACE_INCLUDE_DIRECTORIES "''${XRT_INSTALL_DIR}/include"
    )

    # Create gen directory for version.h
    file(MAKE_DIRECTORY ''${CMAKE_BINARY_DIR}/gen)

    # Create version.h stub
    file(WRITE ''${CMAKE_BINARY_DIR}/gen/version.h
    "#pragma once
    #define XRT_VERSION \"''${XRT_VERSION_STRING}\"
    #define XRT_VERSION_MAJOR ${lib.elemAt xrtVersionParts 1}
    #define XRT_VERSION_MINOR ${lib.elemAt xrtVersionParts 2}
    #define XRT_VERSION_PATCH ${lib.elemAt xrtVersionParts 3}
    ")

    # Set XRT_BINARY_DIR for gen includes
    set(XRT_BINARY_DIR ''${CMAKE_BINARY_DIR})

    # Plugin version
    set(XRT_PLUGIN_VERSION_STRING ''${XRT_VERSION_STRING})
    set(XRT_SOVERSION ${lib.elemAt xrtVersionParts 1})

    # Package installation directories
    set(XDNA_PKG_LIB_DIR "opt/xilinx/xrt/lib")
    set(XDNA_COMPONENT "xdna")
    set(XDNA_BIN_DIR "''${CMAKE_BINARY_DIR}/bin")

    add_subdirectory(src/shim)
    CMAKEOF
  '';

  postInstall = ''
    # Move the plugin library to XRT's expected location.
    mkdir -p $out/opt/xilinx/xrt/lib
    if [ -d $out/opt/xilinx/lib ]; then
      mv $out/opt/xilinx/lib/* $out/opt/xilinx/xrt/lib/ || true
    fi

    # Create top-level symlinks.
    mkdir -p $out/lib
    for lib in $out/opt/xilinx/xrt/lib/*.so*; do
      ln -sf "$lib" "$out/lib/" 2>/dev/null || true
    done

    # Create a pkg-config file.
    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/xrt-amdxdna.pc << EOF
    prefix=$out/opt/xilinx/xrt
    exec_prefix=\''${prefix}
    libdir=\''${exec_prefix}/lib
    includedir=\''${prefix}/include

    Name: XRT-AMDXDNA
    Description: AMD XDNA Plugin for Xilinx Runtime
    Version: ${xrtVersion}
    Requires: xrt
    Libs: -L\''${libdir} -lamdxdna
    EOF
  '';

  passthru = {
    inherit xrt;
  };

  meta = {
    description = "AMD XDNA driver plugin for XRT (Ryzen AI NPU support)";
    homepage = "https://github.com/amd/xdna-driver";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
})
