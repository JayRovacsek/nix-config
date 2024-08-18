{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.ledger-live-desktop ];

  hardware.ledger.enable = true;
}
