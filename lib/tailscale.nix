{ self, ... }: {
  lookup-tailnet = hostname: self.common.tailscale.tailnet.${hostname};
}
