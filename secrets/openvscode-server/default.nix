let
  # TODO: rekey with new headscale keys
  primaryOpenVscodeKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFF/xU6gTNVAv/ev+Eod5wzscjSqNLOdh70f1/u95l72";
  secondaryOpenVscodeKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICphdq1I7huM6f9hAckz6MBqJ8XMcKFD5F4Tvb8QKR3d";
  openVscodeKeys = [ primaryOpenVscodeKey secondaryOpenVscodeKey ];
in { "connection-token-file.age".publicKeys = openVscodeKeys; }
