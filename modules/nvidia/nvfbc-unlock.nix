# config credit to https://github.com/babbaj/nix-config - thank you so much!
driverPackage:
let
  # Original definitions thanks to: https://github.com/keylase/nvidia-patch/blob/master/patch.sh
  patches = {
    "435.27.08" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\x68\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\x68\\xfa\\xff\\xff/";
    "440.26" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.31" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.33.01" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.36" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.43.01" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.44" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.48.02" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.58.01" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.58.02" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.59" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.64" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.64.00" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.66.02" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.66.03" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.66.04" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.66.08" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.66.09" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.66.11" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.66.12" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.66.14" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.66.15" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.66.17" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.82" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.95.01" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.100" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "440.118.02" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "450.36.06" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "450.51" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "450.51.05" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "450.51.06" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "450.56.01" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "450.56.02" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "450.56.06" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "450.56.11" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "450.57" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "450.66" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "450.80.02" =
      "s/\\x85\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/\\x31\\xc0\\x89\\xc3\\x0f\\x85\\xa9\\xfa\\xff\\xff/";
    "455.23.04" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.23.05" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.26.01" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.26.02" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.28" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.32.00" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.38" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.45.01" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.46.01" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.46.02" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x83/\\x83\\xf8\\x69\\x0f\\x84\\x83/";
    "455.46.04" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.50.02" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.50.03" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.50.04" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.50.05" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.50.07" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "455.50.10" =
      "s/\\x83\\xf8\\x01\\x0f\\x84\\x85/\\x83\\xf8\\x69\\x0f\\x84\\x85/";
    "460.27.04" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "460.32.03" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "460.39" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "460.56" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "460.67" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "460.73.01" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "460.80" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "460.84" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "460.91.03" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "465.19.01" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "465.24.02" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "465.27" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "465.31" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "470.42.01" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "470.57.02" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "470.63.01" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "470.74" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "495.44" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "510.39.01" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "510.47.03" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "510.54" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "510.60.02" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "510.68.02" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "510.73.05" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "510.73.08" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "515.43.04" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "515.48.07" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "515.57" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "515.65.01" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "515.76" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "520.56.06" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "520.61.05" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "525.60.11" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "525.60.13" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "525.78.01" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "525.85.05" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "525.85.12" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "525.89.02" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "530.30.02" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "530.41.03" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "535.43.02" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "535.54.03" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x00\\x72\\x08\\x48/";
    "535.86.05" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x01\\x90\\x90\\x48/";
    "535.86.10" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x01\\x90\\x90\\x48/";
    "535.98" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x01\\x90\\x90\\x48/";
    "535.104.05" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x01\\x90\\x90\\x48/";
    "535.104.12" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x01\\x90\\x90\\x48/";
    "535.113.01" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x01\\x90\\x90\\x48/";
    "535.129.03" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x01\\x90\\x90\\x48/";
    "545.23.06" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x01\\x90\\x90\\x48/";
    "545.29.02" =
      "s/\\x83\\xfe\\x01\\x73\\x08\\x48/\\x83\\xfe\\x01\\x90\\x90\\x48/";

  };
in driverPackage.overrideAttrs ({ version, preFixup ? "", ... }: {
  preFixup = preFixup + ''
    sed -i '${
      builtins.getAttr version patches
    }' $out/lib/libnvidia-fbc.so.${version}
  '';
})
