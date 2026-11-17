# Xilinx Runtime (XRT): the userspace runtime providing libxrt_coreutil.so.2
# and libxrt_core.so.2, required by halogen-flash-server's NPU sidecar at
# /opt/xilinx/xrt/lib (see packages/other/xrt-amdxdna).
#
# Vendored from robcohen/nix-amd-npu@8848c6f3382852290ac25fbe7634058c4e9c037e
# (pkgs/xrt/default.nix, MIT; reviewed per extension supply-chain policy).
# Upstream: https://github.com/Xilinx/XRT (Apache-2.0) — the source AMD's
# xrt_*-base.deb ships are built from. nixpkgs carries no XRT, so it lives
# here; nix-update updates it via the fetchFromGitHub source below.
# Deviations from the vendored source: new-style finalAttrs syntax using
# lib.placeholder (the vendored file's bare `placeholder "out"` relies on a
# derivation-result attribute current nix no longer provides); a version
# bump to 202610.2.23.244 (robcohen's audited 202610.2.21.21 pairs with an
# amd/xdna-driver rev that no longer exists, and that repo's only tag,
# 2.21.75, is written against 2.23.x headers); and -DCMAKE_CXX_STANDARD=20
# (abseil's headers fail to compile at -std=gnu++17 with gcc 16). The boost
# 1.91 fix from the vendored file is upstream in 2.23; only the raw-name
# boost_system link entries still need patching.
{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  git,
  # Python 3.12 to match the mlir_aie wheel in the FHS environments that
  # consume pyxrt.
  python312,
  boost,
  opencl-headers,
  opencl-clhpp,
  ocl-icd,
  rapidjson,
  protobuf,
  elfutils,
  libdrm,
  systemd,
  curl,
  openssl,
  libuuid,
  libxcrypt,
  ncurses,
  gawk,
  libsystemtap,
  wget,
  cacert,
}:
let
  # Python with packages needed by spec_tool.py during the build.
  pythonWithPackages = python312.withPackages (ps: [
    ps.pyyaml
    ps.markdown
    ps.jinja2
    ps.pybind11
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xrt";
  version = "202610.2.23.244";

  src = fetchFromGitHub {
    owner = "Xilinx";
    repo = "XRT";
    rev = finalAttrs.version;
    hash = "sha256-xJPtxPla20pLw6pwowV0fei7WpsEA+aGLnKqU4qeZa4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    git
    gawk
    pythonWithPackages
    wget
  ];

  # pybind11 is provided via pythonWithPackages — not added separately, as a
  # second pybind11 from a different Python version would conflict.
  buildInputs = [
    boost
    opencl-headers
    opencl-clhpp
    ocl-icd
    rapidjson
    protobuf
    elfutils
    libdrm
    systemd
    curl
    openssl
    libuuid
    libxcrypt
    ncurses
    libsystemtap
  ];

  cmakeDir = "../src";

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${lib.placeholder "out"}/opt/xilinx/xrt"
    "-DXRT_INSTALL_PREFIX=${lib.placeholder "out"}/opt/xilinx/xrt"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DDISABLE_WERROR=ON"
    # Build with C++20 instead of XRT's default C++17: libstdc++ 16
    # advertises __cpp_lib_three_way_comparison in C++17 mode without
    # declaring std::{partial,weak,strong}_ordering, so abseil's headers
    # (pulled in via protobuf) fail to compile at -std=gnu++17.
    # settings.cmake honours an externally-set CMAKE_CXX_STANDARD.
    "-DCMAKE_CXX_STANDARD=20"
    # Disable kernel module building (we use the mainline amdxdna driver).
    "-DXRT_DKMS_DRIVER_SRC_BASE_DIR="
    # XRT_UPSTREAM_DEBIAN enables XRT_UPSTREAM which propagates to
    # AIEBU_UPSTREAM; this disables static linking in the aiebu tools
    # (see src/CMake/settings.cmake lines 19-21).
    "-DXRT_UPSTREAM_DEBIAN=ON"
    # Override install dirs to relative paths to prevent aiebu cmake path
    # issues: aiebu concatenates CMAKE_BINARY_DIR + CMAKE_INSTALL_LIBDIR,
    # which breaks with absolute paths.
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    # Enable Python bindings (pyxrt) for IRON/mlir-aie integration.
    "-DXRT_ENABLE_PYXRT=ON"
    "-DPython3_EXECUTABLE=${pythonWithPackages}/bin/python3"
    "-DPython3_INCLUDE_DIR=${pythonWithPackages}/include/python3.12"
    "-DPython3_LIBRARY=${pythonWithPackages}/lib/libpython3.12.so"
    "-DPYTHON_EXECUTABLE=${pythonWithPackages}/bin/python3"
  ];

  # Skip building kernel modules and fix Nix-specific issues.
  postPatch = ''
    # boost 1.69 made boost_system header-only; XRT fixed the
    # find_package(Boost COMPONENTS system ...) and Boost::system
    # references upstream in 2.23, but the raw-name target_link_libraries
    # entries that bypass the imported targets remain in xbflash2, xbmgmt2,
    # xbutil2 and hw_emu. Remove those raw `boost_system` lines (there is
    # no libboost_system to link against).
    for f in src/runtime_src/core/tools/xbflash2/CMakeLists.txt \
             src/runtime_src/core/tools/xbmgmt2/CMakeLists.txt \
             src/runtime_src/core/tools/xbutil2/CMakeLists.txt \
             src/runtime_src/core/pcie/emulation/hw_emu/CMakeLists.txt; do
      if [ -f "$f" ]; then
        sed -i '/^[[:space:]]*boost_system$/d' "$f"
      fi
    done

    # Fix Python3 detection for pybind11/pyxrt: the cmake tries to run
    # /usr/bin/python3, which doesn't exist in the Nix sandbox.
    substituteInPlace src/python/pybind11/CMakeLists.txt \
      --replace-quiet '/usr/bin/python3' "${pythonWithPackages}/bin/python3" || true

    # Remove kernel module references.
    substituteInPlace src/CMakeLists.txt \
      --replace-quiet 'add_subdirectory(runtime_src/core/pcie/driver)' '#add_subdirectory(runtime_src/core/pcie/driver)' || true

    # Fix hardcoded /usr/src DKMS install path: redirect to
    # $out/share/xrt-dkms-src instead.
    for f in src/CMake/version.cmake src/CMake/dkms.cmake src/CMake/dkms-edge.cmake; do
      if [ -f "$f" ]; then
        sed -i 's|/usr/src/xrt-|''${CMAKE_INSTALL_PREFIX}/share/xrt-dkms-src/xrt-|g' "$f"
      fi
    done
    if [ -f src/CMake/dkms-aws.cmake ]; then
      sed -i 's|/usr/src/xrt-aws-|''${CMAKE_INSTALL_PREFIX}/share/xrt-dkms-src/xrt-aws-|g' src/CMake/dkms-aws.cmake
    fi

    # Fix hardcoded /usr/local/bin install paths for xbflash tools.
    for f in src/runtime_src/core/tools/xbflash2/CMakeLists.txt src/runtime_src/core/pcie/tools/xbflash.qspi/CMakeLists.txt; do
      if [ -f "$f" ]; then
        sed -i 's|"/usr/local/bin"|"''${CMAKE_INSTALL_PREFIX}/bin"|g' "$f"
      fi
    done

    # Fix /etc/OpenCL/vendors path for OpenCL ICD registration.
    if [ -f src/CMake/icd.cmake ]; then
      sed -i 's|/etc/OpenCL/vendors|''${CMAKE_INSTALL_PREFIX}/etc/OpenCL/vendors|g' src/CMake/icd.cmake
    fi

    # Fix hardcoded /opt/xilinx/xrt references in the built config reader.
    substituteInPlace src/runtime_src/core/common/config_reader.cpp \
      --replace-quiet '/opt/xilinx/xrt' '${lib.placeholder "out"}/opt/xilinx/xrt' || true

    # Fix /etc/os-release access: CMake scripts read it at build time.
    mkdir -p $TMPDIR/etc
    echo 'ID=nixos' > $TMPDIR/etc/os-release
    echo 'VERSION_ID="25.11"' >> $TMPDIR/etc/os-release
    find . \( -name "*.cmake" -o -name "CMakeLists.txt" \) -print0 \
      | xargs -0 sed -i -e 's|/etc/os-release|'$TMPDIR'/etc/os-release|g' || true

    # Disable Werror globally (also -Werror=... forms, which a bare
    # s/-Werror// would leave as a dangling `=...` token).
    find . -name "CMakeLists.txt" -exec sed -i \
      -e 's/-Werror=[A-Za-z0-9_.-]*//g' -e 's/-Werror\b//g' {} \; || true

    # Replace the wget download commands with `true` (for 2.21-era trees the
    # aiebu stub below is pre-created, so the download is unnecessary).
    find . -name "CMakeLists.txt" -exec grep -l "wget" {} \; | while read -r f; do
      sed -i 's|COMMAND wget|COMMAND true # wget|g' "$f"
      sed -i 's|COMMAND powershell wget|COMMAND true # powershell wget|g' "$f"
    done

    # aiebu lived under core/common in 2.21 but was removed in 2.23; guard
    # all aiebu-specific patches so this file works across versions.
    if [ -d src/runtime_src/core/common/aiebu ]; then
    # Create a stub markdown_graphviz_svg module to avoid a network download
    # (the real module is https://github.com/Tanami/markdown-graphviz-svg;
    # graphviz rendering is disabled in the Nix build).
    cat > src/runtime_src/core/common/aiebu/specification/markdown_graphviz_svg.py << 'PYEOF'
    # Stub implementation of markdown_graphviz_svg for the Nix build.
    from markdown.extensions import Extension

    class GraphvizBlocksExtension(Extension):
        """Stub extension - graphviz rendering is disabled in Nix build"""
        def extendMarkdown(self, md):
            pass

    GraphvizExtension = GraphvizBlocksExtension

    def makeExtension(**kwargs):
        return GraphvizBlocksExtension(**kwargs)
    PYEOF

    # Disable the aie2ps spec generation targets during install: the build
    # phase generates the files correctly, but install-time regeneration with
    # spec_tool.py produces incomplete output (no disassembler code).
    specCmake="src/runtime_src/core/common/aiebu/specification/aie2ps/CMakeLists.txt"
    if [ -f "$specCmake" ]; then
      cat > "$specCmake" << 'STUBCMAKE'
    # SPDX-License-Identifier: MIT
    # Disabled for Nix build - spec generation causes issues.
    message(STATUS "Skipping aie2ps spec generation (Nix build)")
    STUBCMAKE
    fi

    # Fix spec_tool.py shebangs (#!/usr/bin/env python3 doesn't exist in the
    # Nix sandbox).
    patchShebangs --build src/runtime_src/core/common/aiebu/specification/ || true
    patchShebangs --build src/runtime_src/core/common/aiebu/src/python/ || true
    fi
  '';

  postInstall = ''
    # Create convenience symlinks at the top level.
    mkdir -p $out/bin $out/lib $out/include

    for bin in $out/opt/xilinx/xrt/bin/*; do
      ln -sf "$bin" "$out/bin/"
    done

    for lib in $out/opt/xilinx/xrt/lib/*.so*; do
      ln -sf "$lib" "$out/lib/"
    done

    cp $out/opt/xilinx/xrt/setup.sh $out/ || true

    # Create a pkg-config file.
    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/xrt.pc << EOF
    prefix=$out/opt/xilinx/xrt
    exec_prefix=\''${prefix}
    libdir=\''${exec_prefix}/lib
    includedir=\''${prefix}/include

    Name: XRT
    Description: Xilinx Runtime for AMD NPU
    Version: ${finalAttrs.version}
    Libs: -L\''${libdir} -lxrt_coreutil
    Cflags: -I\''${includedir}
    EOF
  '';

  meta = {
    description = "Xilinx Runtime (XRT) for AMD accelerators (NPU-capable build)";
    homepage = "https://github.com/Xilinx/XRT";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "xrt-smi";
  };
})
