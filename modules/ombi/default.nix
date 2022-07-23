{
  users.groups = { download = { }; };

  services.ombi = {
    enable = true;
    port = 80;
    group = "download";
    openFirewall = true;
  };
}
