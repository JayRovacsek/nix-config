{
  pkgs,
  ...
}:
{
  environment = {
    gnome.excludePackages = with pkgs; [
      cheese
      gnome-photos
      gnome-music
      gedit
      epiphany
      evince
      gnome-characters
      totem
      tali
      iagno
      hitori
      atomix
      gnome-weather
      gnome-contacts
      gnome-maps
      geary
      gnome-tour
      gnome-connections
    ];
  };
}
