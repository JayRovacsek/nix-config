{
  imports = [
    ../options/flake
    ../options/hardware
    ../options/networking
    ../options/systemd
    # TODO: resolve the below being optionally included and/or 
    # not including linux specific jazz
    # ../options/tailscale
  ];
}
