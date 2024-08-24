{ config, ... }:
let
  /*
    A foorgun below; don't set a swap device priority as 32767.
    It's the limit of the i16 value used here.
  */
  max-swap-priority = builtins.foldl' (
    acc: x: if acc >= (x.priority or 0) then acc else (x.priority or 0)
  ) 0 config.swapDevices;
in
{
  zramSwap = {
    algorithm = "zstd";
    enable = true;
    priority = max-swap-priority + 1;
  };
}
