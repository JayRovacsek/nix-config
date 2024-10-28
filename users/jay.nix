{
  name = "jay";
  isNormalUser = true;
  hashedPassword = "$y$j9T$2m8ZFikkQ3kVzMcpK6MsX0$oaiezoEN4keswQ2EqLqSaeQvwUo4qvMTSKzqLFWKhpC";
  extraGroups = [
    "audio"
    "docker"
    "input"
    "libvirtd"
    "networkmanager"
    "tty"
    "video"
    "wheel"
  ];
  openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMO6FTToBOIByP9uVP2Ke2jGD/ESxPcXEMhvR7unukNGAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINNGQz3ekO1q/DrxuhP7Ck3TnP9V4ooF5vo8ibFWKKqFAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDuG5e8MReihLwtKk3/rbXcZKNfiapcqAhWu//fC0aMKAAAABHNzaDo= jay@rovacsek.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILDjbVDfVzpcxnx9fl4pBr6eKAJdSyX4JLyBK02N9YeFAAAABHNzaDo= jay@rovacsek.com"
  ];
  home.file = {
    ".config/git/allowed_signers".text = "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaL4kr1XUQWWuj+iFjXeIiE6zhRDQFbOs+6toGSW9+5";
  };
  accounts.email.accounts.git = {
    address = "jay@rovacsek.com";
    primary = true;
  };
}
