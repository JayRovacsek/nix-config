{ self, ... }:
{
  imports =
    (with self.nixosModules; [
      acme
      agenix
      alloy
      ddclient
      container-guest
      nginx
      nix-topology
      time
      timesyncd
      tmp-tmpfs
    ])
    ++ [ ./nginx.nix ];

  networking.hostName = "nidorina";

  # Pinned ssh host keypair (draft key - rotate via `ssh-keygen -t ed25519`
  # and re-seed; dragonite retains it in /var/lib/nidorina/etc/ssh/).
  programs.ssh.hostKeyBase64 = "LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFBQUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUFNd0FBQUF0emMyZ3RaVwpReU5UVXhPUUFBQUNDWUMvMTlQMi9EalgrdHY3YUt3UXYvdEh2NGFOaGRBaytkOTJlYXh2RFNaUUFBQUpCelMxSFljMHRSCjJBQUFBQXR6YzJndFpXUXlOVFV4T1FBQUFDQ1lDLzE5UDIvRGpYK3R2N2FLd1F2L3RIdjRhTmhkQWsrZDkyZWF4dkRTWlEKQUFBRUE0bFJ2SmV5V2RoWkxVOUNuTGt3ci9tTm05ckR1eTg1QXlOU2JHVFhTcStwZ0wvWDAvYjhPTmY2Mi90b3JCQy8rMAplL2hvMkYwQ1Q1MzNaNXJHOE5KbEFBQUFEWEp2YjNSQWJtbGtiM0pwYm1FPQotLS0tLUVORCBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0K";
  programs.ssh.publicHostKeyBase64 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpnTC9YMC9iOE9OZjYyL3RvckJDLyswZS9obzJGMENUNTMzWjVyRzhOSmwgcm9vdEBuaWRvcmluYQo=";

  system.stateVersion = "24.05";
}
