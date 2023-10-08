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
      secret_scanning.status = "enabled";
      secret_scanning_push_protection.status = "enabled";
    };
  };

  private-repository-settings.visibility = "private";
  public-repositories = [
    {
      name = "after-dark";
      description = "A dark theme for Zola";
    }
    {
      name = "agenix";
      description = "age-encrypted secrets for NixOS";
    }
    {
      name = "AOC";
      archived = true;
      description = "Advent of Code Repository";
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "AOC-2018";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "aoc-2022";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "aoc-2023";
      description = "Advent of code solutions for 2023";
    }
    {
      name = "Aurora-Incident-Response";
      description =
        "Incident Response Documentation made easy. Developed by Incident Responders for Incident Responders";
      vulnerability_alerts = false;
      security_and_analysis = {
        secret_scanning.status = "disabled";
        secret_scanning_push_protection.status = "disabled";
      };
    }
    {
      name = "automatic1111-webui-nix";
      description = "AUTOMATIC1111/stable-diffusion-webui for CUDA on NixOS";
    }
    { name = "aws-incident-response-runbooks"; }
    {
      name = "bert";
      description = "A toy Go program";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
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
      description = "COMP3260 Assignment 1";
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "COMP3260A2";
      archived = true;
      description = "Git repo for COMP3260 A2";
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "dev-templates";
      description =
        "Dev environments for numerous languages based on Nix flakes [maintainer=@lucperkins]";
    }
    {
      name = "DHTesp";
      description =
        "Optimized DHT library for ESP32/ESP8266 using Arduino framework";
    }
    {
      name = "dnscrypt-server-docker";
      description =
        "A Docker image for a non-censoring, non-logging, DNSSEC-capable, DNSCrypt-enabled DNS resolver";
      homepage_url = "https://dnscrypt.info";
    }
    {
      name = "dotfiles";
      description = "A repository to manage dotfiles and config";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "EBUS3030";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
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
      description = "INFT1004 Assignment";
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "INFT1150";
      archived = true;
      description = "Group Assignment For INFT1150";
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "INFT2012";
      archived = true;
      description = "INFT2012 Assignment";
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "INFT3970";
      archived = true;
      description = "Git repository for INFT3970";
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "INFT3970-Individual-Report";
      archived = true;
      description =
        "An individual report created for the INFT3970 course at UoN on secure coding practices.";
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "INFT3970-DB";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "INFT3970-Public";
      archived = true;
      description = "A public copy of our INFT3970 Solution";
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "INFT3970-Sensors";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "interrogator";
      description = "A hobby project for learning Rust a bit better";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "jellyfin-discord-music-bot";
      description =
        "Jellyfin Discord Music Bot is a Discord Bot for the Jellyfin Media Server!";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "jim";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "Kansa";
      description = "A Powershell incident response framework";
    }
    {
      name = "ncsg-presentation-feb-2021";
      description =
        "A presentation for Newcastle Cybersecurity Group, Feb 2021";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "ncsg-presentation-feb-2022";
      description =
        "A presentation for Newcastle Cybersecurity Group, Feb 2022";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "ncsg-presentation-june-2023";
      description =
        "A presentation for Newcastle Cybersecurity Group, June 2023";
      pages.build_type = "workflow";
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
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "PoSh-R2";
      description =
        "PowerShell - Rapid Response... For the incident responder in you!";
    }
    {
      name = "project-euler";
      description =
        "A repository to host code related to https://projecteuler.net";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "project_alias";
      description =
        "Alias is a teachable “parasite” that is designed to give users more control over their smart assistants, both when it comes to customisation and privacy. Through a simple app the user can train Alias to react on a custom wake-word/sound, and once trained, Alias can take control over your home assistant by activating it for you.";
    }
    {
      name = "pyautoclick";
      description = "Simple autoclicker on request for brother's use.";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "python-oreilly";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
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
      description = "Assignment Part 2 SENG1050";
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "SENG1050";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "SENG2260";
      archived = true;
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "soe.nix";
      description = "NixOS & darwin SOE Wrapper";
    }
    {
      name = "speedtestcli-periodic";
      archived = true;
      description = "Temporary application to assist with troubleshooting";
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
    }
    {
      name = "stubby-docker";
      description =
        "Run Stubby without losing the performance benefits of having a local caching DNS resolver.";
    }
    {
      name = "user.js";
      archived = true;
      description =
        "Firefox privacy, security and anti-fingerprinting: a comprehensive user.js template for configuration and hardening";
      security_and_analysis = {
        secret_scanning_push_protection.status = "disabled";
        secret_scanning.status = "disabled";
      };
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
        "A simple wrapper for vulnix to check the state of a flake derivation for new or introduced vulnerabilities";
    }
  ];
  private-repositories = [
    {
      name = "calamus";
      archived = true;
    }
    {
      name = "COMP1010";
      archived = true;
    }
    {
      name = "comparison-tool";
      description =
        "A dabble in Go, basic tool for testing regression in internal systems.";
      archived = true;
    }
    {
      name = "documentation";
      description = "A repository to hold documentation of various items.";
    }
    {
      name = "FOR508-notes";
      description =
        "A repository to host notes on my participation in the SANS FOR508 course";
    }
    {
      name = "jsign-docker";
      description =
        "A PoC to avoid needing to use a Windows system to sign Powershell payloads";
      archived = true;
    }
    {
      name = "maljs";
      description =
        "A repo to host some deobfustication of code found on a website";
      archived = true;
    }
    {
      name = "ncsg-content";
      description =
        "A staging repo for ncsg content to be converted to markdown";
    }
    { name = "ncsg-poc"; }
    {
      name = "notes";
      description = "A repository for notes";
    }
    {
      name = "py-game";
      archived = true;
    }
    {
      name = "py-maintain-sanity";
      description =
        "This is what happens when people don't follow naming conventions.";
      archived = true;
    }
    {
      name = "pyerrand";
      archived = true;
    }
    { name = "resume"; }
    { name = "retojaco"; }
    {
      name = "rovacsek-build";
      archived = true;
    }
    {
      name = "rusty-hook";
      archived = true;
    }
    {
      name = "scripts";
      archived = true;
    }
    {
      name = "Shiryoku";
      description = "Simple SPA app to create graphs";
      archived = true;
    }
    {
      name = "szemek";
      archived = true;
    }
    {
      name = "tf-nix-deploy-poc";
      description = "A simple example to build and deploy Terraform via nix";
    }
    {
      name = "University";
      description = "Projects for University";
      archived = true;
    }
    {
      name = "watchrs";
      archived = true;
    }
  ];
  repositories = public-repositories ++ private-repositories;
}
