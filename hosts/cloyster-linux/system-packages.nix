{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # CLI
    curl
    wget
    agenix
  ];
}
