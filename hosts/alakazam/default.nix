{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    # ../../modules/alacritty
    # ../../modules/clamav
    # ../../modules/firefox
    # ../../modules/gnome
    # ../../modules/steam
    # ../../modules/zsh
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        useOSProber = true;
        enableCryptodisk = true;
      };
    };
  };

  boot.initrd.luks.devices.crypted = {
    device = "/dev/disk/by-uuid/7cf02c33-9404-45af-9e53-2fa65aa59027";
    preLVM = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      jay = {
        isNormalUser = true;
        useDefaultShell = true;
        extraGroups = [
          "wheel"
          "docker"
          "libirt"
          "networkmanager"
          "audio"
          "video"
          "input"
        ];
      };
    };
  };

  networking = {
    hostName = "alakazam";
    useDHCP = false;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22 ];
  };

  time.timeZone = "Australia/NSW";

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    nvidia = { modesetting.enable = true; };
    pulseaudio.enable = false;
  };

  services = {
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    gvfs.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = [ "nvidia" ];
      displayManager = {
        gdm = {
          enable = true;
          wayland = false;
        };
        autoLogin = {
          enable = true;
          user = "jay";
        };
      };
      desktopManager.gnome.enable = true;
    };
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  programs = {
    gnome-terminal.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    steam.enable = true;
    zsh = {
      enable = true;
      promptInit = ''
        HYPHEN_INSENSITIVE="true"
        ENABLE_CORRECTION="true"
        COMPLETION_WAITING_DOTS="true"

        # Preferred editor for local and remote sessions
        if [[ -n $SSH_CONNECTION ]]; then
            export EDITOR='vim'
        else
            export EDITOR='vim'
        fi

        export PATH=$PATH:$(go env GOPATH)/bin
        export GOPATH=$(go env GOPATH)
        eval "$(starship init zsh)"
      '';
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        customPkgs = [ pkgs.spaceship-prompt ];
        theme = "risto";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gjs
    gnome.gnome-tweaks
    gnome.nautilus
    gnupg
    libfido2
    linuxPackages.nvidia_x11
    vim
    wget
    libnotify
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome.cheese
    gnome-photos
    gnome.gnome-music
    gnome.gedit
    epiphany
    evince
    gnome.gnome-characters
    gnome.totem
    gnome.tali
    gnome.iagno
    gnome.hitori
    gnome.atomix
    gnome.gnome-weather
    gnome.gnome-screenshot
    gnome.gnome-contacts
    gnome.gnome-maps
    gnome.geary
    gnome-tour
    gnome-connections
  ];

  fonts.fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Hack" ]; }) ];

  nix = {
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
    };

    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  documentation.man.generateCaches = true;
  system = {
    stateVersion = "22.05";
    autoUpgrade = {
      enable = true;
      dates = "04:00";
      allowReboot = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };
}
