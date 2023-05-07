_: {
  public-archived-repositories = [
    { name = "AOC"; }
    { name = "AOC-2018"; }
    { name = "COMP3260A1"; }
    { name = "COMP3260A2"; }
    { name = "EBUS3030"; }
    { name = "INFT1004"; }
    { name = "INFT2012"; }
    { name = "INFT3970-DB"; }
    { name = "INFT3970-Public"; }
    { name = "INFT3970-Sensors"; }
    { name = "SENG1050Assignment2"; }
    { name = "SENG2260"; }
    { name = "speedtestcli-periodic"; }
    { name = "user.js"; }
  ];
  public-repositories = [
    { name = "after-dark"; }
    { name = "agenix"; }
    { name = "aoc-2022"; }
    { name = "Aurora-Incident-Response"; }
    { name = "automatic1111-webui-nix"; }
    { name = "aws-incident-response-runbooks"; }
    {
      name = "bert";
      description = "A toy Go program";
    }
    { name = "blinky-bed"; }
    {
      name = "blog";
      pages.source = {
        branch = "gh-pages";
        path = "/";
      };
    }
    {
      name = "dev-templates";
      description =
        "Dev environments for numerous languages based on Nix flakes [maintainer=@lucperkins]";
    }
    { name = "DHTesp"; }
    {
      name = "dnscrypt-server-docker";
      description =
        "A Docker image for a non-censoring, non-logging, DNSSEC-capable, DNSCrypt-enabled DNS resolver";
    }
    {
      name = "dotfiles";
      description = "A repository to manage dotfiles and config";
    }
    {
      name = "envytools";
      description = "Tools for people envious of nvidia's blob driver.";
    }
    {
      name = "fireship.io";
      description = "Build and ship your app faster  https://fireship.io";
    }
    {
      name = "forty";
      description =
        "Forty theme - Hugo theme ported from HTML5UP origrinal theme called Forty.";
    }
    {
      name = "headscale";
      description =
        "An open source, self-hosted implementation of the Tailscale control server";
    }
    {
      name = "interrogator";
      description = "A hobby project for learning Rust a bit better";
    }
    {
      name = "jellyfin-discord-music-bot";
      description =
        "Jellyfin Discord Music Bot is a Discord Bot for the Jellyfin Media Server!";
    }
    { name = "jim"; }
    { name = "Kansa"; }
    {
      name = "ncsg-presentation-feb-2021";
      description =
        "A presentation for Newcastle Cybersecurity Group, Feb 2021";
    }
    {
      name = "ncsg-presentation-feb-2022";
      description =
        "A presentation for Newcastle Cybersecurity Group, Feb 2022";
    }
    {
      name = "nix-config";
      description = "My nix configs";
    }
    { name = "nix-lib-html-reference"; }
    {
      name = "nixos-m1";
      description = "Attempts to get NixOS up on M1 Macs.";
    }
    {
      name = "nixos-nvidia-vgpu";
      description = "NixOS NVIDIA vGPU Module";
    }
    {
      name = "nixpkgs";
      allow_auto_merge = false;
      auto_init = false;
      description = "Nix Packages collection";
      has_downloads = true;
      has_issues = false;
      has_projects = true;
      vulnerability_alerts = false;
      security_and_analysis = {
        secret_scanning.status = "disabled";
        secret_scanning_push_protection.status = "disabled";
      };
    }
    {
      name = "nvidia-patch";
      description =
        "This patch removes restriction on maximum number of simultaneous NVENC video encoding sessions imposed by Nvidia to consumer-grade GPUs.";
    }
    {
      name = "pf-captive-portal";
      description = "Captive Portal for Pfsense";
    }
    { name = "PoSh-R2"; }
    {
      name = "project-euler";
      description =
        "A repository to host code related to https://projecteuler.net";
    }
    {
      name = "project_alias";
      description =
        "Alias is a teachable “parasite” that is designed to give users more control over their smart assistants, both when it comes to customisation and privacy. Through a simple app the user can train Alias to react on a custom wake-word/sound, and once trained, Alias can take control over your home assistant by activating it for you.";
    }
    {
      name = "pyautoclick";
      description = "Simple autoclicker on request for brother's use.";
    }
    { name = "python-oreilly"; }
    {
      name = "raspberry-pi-nix";
      description =
        "NixOS modules to aid in configuring NixOS for raspberry pi products";
    }
    {
      name = "rovacsek";
      description = "Homepage repo";
      pages.source = {
        branch = "master";
        path = "/";
      };
    }
    {
      name = "sbomnix";
      description =
        "sbomnix is a utility that generates SBOMs from nix packages";
    }
    { name = "semgrep-poc"; }
    {
      name = "soe.nix";
      description = "NixOS & darwin SOE Wrapper";
    }
    {
      name = "stubby-docker";
      description =
        "Run Stubby without losing the performance benefits of having a local caching DNS resolver.";
    }
    {
      name = "u-boot";
      description = ''"Das U-Boot" Source Tree'';
    }
    {
      name = "vgpu_unlock_5.12";
      description = "Unlock vGPU functionality for consumer grade GPUs.";
    }
    {
      name = "vms.nix";
      description =
        "NixOS module for QEMU VM's using a similar interface to nixos-containers.";
    }
  ];
  private-repositories = [ ];
  private-archived-repositories = [ ];
}
