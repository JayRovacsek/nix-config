{
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    # The below just has to be _one_ of the private keys described in the secrets/secrets.nix module
    hostKeys = [{
      path = "/tmp/.ssh/id_ed25519_agenix";
      type = "ed25519";
    }];
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
