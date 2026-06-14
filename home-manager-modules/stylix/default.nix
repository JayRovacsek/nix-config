{ config, lib, ... }:
{
  gtk.gtk4.theme = lib.mkForce config.gtk.theme;
}
