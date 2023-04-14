_:
let
  # This is a simple hack around an inability to reflect
  # on expected or required attributes for user definitions
  # based on our host configuration.
  #
  # TODO: revist this some time in the future to validate there
  # isn't an obvious way.
  attr-names = [
    "name"
    "isNormalUser"
    "isSystemUser"
    "initialHashedPassword"
    "extraGroups"
    "openssh"
  ];
in attr-names
