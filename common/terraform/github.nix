{ self, ... }:
let
  inherit (self.common.terraform.globals.github)
    public-repositories private-repositories;
in {
  default-repository-settings = {
    allow_auto_merge = true;
    allow_merge_commit = true;
    allow_rebase_merge = true;
    allow_squash_merge = true;
    allow_update_branch = true;
    archive_on_destroy = false;
    auto_init = true;
    delete_branch_on_merge = true;
    has_discussions = false;
    has_downloads = false;
    has_issues = true;
    has_projects = false;
    has_wiki = false;
    is_template = false;
    merge_commit_message = "PR_TITLE";
    merge_commit_title = "MERGE_MESSAGE";
    squash_merge_commit_message = "COMMIT_MESSAGES";
    squash_merge_commit_title = "COMMIT_OR_PR_TITLE";
    vulnerability_alerts = true;
  };

  public-repository-settings = {
    visibility = "public";
    security_and_analysis = {
      advanced_security.status = "enabled";
      secret_scanning.status = "enabled";
      secret_scanning_push_protection.status = "enabled";
    };
  };

  private-repository-settings.visibility = "private";

  public-repositories = [
    { name = "after-dark"; }
    { name = "agenix"; }
    {
      name = "AOC";
      archived = true;
    }
    {
      name = "AOC-2018";
      archived = true;
    }
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
      name = "COMP3260A1";
      archived = true;
    }
    {
      name = "COMP3260A2";
      archived = true;
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
      name = "EBUS3030";
      archived = true;
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
      name = "INFT1004";
      archived = true;
    }
    {
      name = "INFT1150";
      archived = true;
    }
    {
      name = "INFT2012";
      archived = true;
    }
    {
      name = "INFT3970";
      archived = true;
    }
    {
      name = "INFT3970-Individual-Report";
      archived = true;
    }
    {
      name = "INFT3970-DB";
      archived = true;
    }
    {
      name = "INFT3970-Public";
      archived = true;
    }
    {
      name = "INFT3970-Sensors";
      archived = true;
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
    {
      name = "SENG1050Assignment2";
      archived = true;
    }
    {
      name = "SENG1050";
      archived = true;
    }
    {
      name = "SENG2260";
      archived = true;
    }
    { name = "semgrep-poc"; }
    {
      name = "soe.nix";
      description = "NixOS & darwin SOE Wrapper";
    }
    {
      name = "speedtestcli-periodic";
      archived = true;
    }
    {
      name = "stubby-docker";
      description =
        "Run Stubby without losing the performance benefits of having a local caching DNS resolver.";
    }
    {
      name = "user.js";
      archived = true;
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
    {
      name = "vulnix";
      description = "Vulnerability (CVE) scanner for Nix/NixOS.";
    }
    {
      name = "vulnix-pre-commit";
      description =
        "A simple wrapper for vulnix to check the state of a flake derivation for new or introduced vulnerabilities ";
    }
  ];
  private-repositories = [

    { name = "calamus"; }
    { name = "COMP1010"; }
    { name = "comparison-tool"; }
    { name = "coolguysinc"; }
    { name = "documentation"; }
    { name = "FOR508-notes"; }
    { name = "jsign-docker"; }
    { name = "maljs"; }
    { name = "ncsg-content"; }
    { name = "ncsg-poc"; }
    { name = "notes"; }
    { name = "py-game"; }
    { name = "py-maintain-sanity"; }
    { name = "pyerrand"; }
    { name = "resume"; }
    { name = "retojaco"; }
    { name = "rovacsek-build"; }
    { name = "rusty-hook"; }
    { name = "scripts"; }
    { name = "Shiryoku"; }
    { name = "szemek"; }
    { name = "tf-nix-deploy-poc"; }
    { name = "University"; }
    { name = "watchrs"; }
  ];

  repositories = public-repositories ++ private-repositories;
}
