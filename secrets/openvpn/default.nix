let
  keys = import ../../common/keys.nix { };

  diglett-keys = with keys; [ diglett-primary-key diglett-secondary-key ];

  primary-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILt1yGWTl0BJqyXYpKyAiGsVMngfaaPD51VjzQge0/Se";
  secondary-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiUT2q43oi0HUHe9hPf+drjsOP6cxbukjfT7OnTmTO5";

  openvpn-server-keys = [ primary-key secondary-key ] ++ diglett-keys;

in {
  "ca-cert.age".publicKeys = openvpn-server-keys;
  "dh2048-pem.age".publicKeys = openvpn-server-keys;
  "server-cert.age".publicKeys = openvpn-server-keys;
  "server-key.age".publicKeys = openvpn-server-keys;
  "ta-key.age".publicKeys = openvpn-server-keys;
}
