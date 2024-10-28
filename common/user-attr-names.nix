_:
let
  # This is a simple hack around an inability to reflect
  # on expected or required attributes for user definitions
  # based on our host configuration.
  #
  # TODO: revisit this some time in the future to validate there
  # isn't an obvious way.
  attr-names = [
    "extraGroups"
    "hashedPassword"
    "initialHashedPassword"
    "isNormalUser"
    "isSystemUser"
    "name"
    "openssh"
  ];
in
attr-names
