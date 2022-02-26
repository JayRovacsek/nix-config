{
  gc = {
    automatic = true;
    dates = "monthly";
    options = "--delete-older-than 7d";
  };
  optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
  settings = {
    trusted-users = [ "jay" "root" ];
    auto-optimise-store = true;
    sandbox = true;
  };
}
