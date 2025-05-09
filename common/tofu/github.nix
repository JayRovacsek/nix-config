{ self, ... }:
let
  inherit (self.common.tofu.globals.github)
    public-repositories
    private-repositories
    ;
in
{
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
    web_commit_signoff_required = true;
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
      archived = true;
      description = "Advent of Code Repository";
      name = "AOC";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      archived = true;
      name = "AOC-2018";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      description = "Incident Response Documentation made easy. Developed by Incident Responders for Incident Responders";
      name = "Aurora-Incident-Response";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    {
      archived = true;
      description = "COMP3260 Assignment 1";
      name = "COMP3260A1";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      archived = true;
      description = "Git repo for COMP3260 A2";
      name = "COMP3260A2";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      description = "Optimised DHT library for ESP32/ESP8266 using Arduino framework";
      name = "DHTesp";
    }
    {
      archived = true;
      name = "EBUS3030";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      archived = true;
      description = "INFT1004 Assignment";
      name = "INFT1004";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      archived = true;
      description = "Group Assignment For INFT1150";
      name = "INFT1150";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      archived = true;
      description = "INFT2012 Assignment";
      name = "INFT2012";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      archived = true;
      description = "Git repository for INFT3970";
      name = "INFT3970";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      archived = true;
      name = "INFT3970-DB";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      archived = true;
      description = "An individual report created for the INFT3970 course at UoN on secure coding practices.";
      name = "INFT3970-Individual-Report";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      archived = true;
      description = "A public copy of our INFT3970 Solution";
      name = "INFT3970-Public";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      archived = true;
      name = "INFT3970-Sensors";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      description = "A Powershell incident response framework";
      name = "Kansa";
    }
    { name = "NVIDIA-VGPU-Driver-Archive"; }
    {
      description = "PowerShell - Rapid Response... For the incident responder in you!";
      name = "PoSh-R2";
    }
    { name = "PurpleOps"; }
    {
      archived = true;
      name = "SENG1050";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      archived = true;
      description = "Assignment Part 2 SENG1050";
      name = "SENG1050Assignment2";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      archived = true;
      name = "SENG2260";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      description = "An opinionated distribution of U-Boot. — https://matrix.to/#/#Tow-Boot:matrix.org?via=matrix.org";
      name = "Tow-Boot";
    }
    {
      description = "A dark theme for Zola";
      name = "after-dark";
    }
    {
      description = "age-encrypted secrets for NixOS";
      name = "agenix";
    }
    { name = "ags-config"; }
    {
      archived = true;
      name = "aoc-2022";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      description = "Advent of code solutions for 2023";
      name = "aoc-2023";
    }
    {
      description = "AUTOMATIC1111/stable-diffusion-webui for CUDA on NixOS";
      name = "automatic1111-webui-nix";
    }
    { name = "aws-incident-response-runbooks"; }
    { name = "battlenet-lancache-prefill"; }
    {
      archived = true;
      description = "A toy Go program";
      name = "bert";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    { name = "blinky-bed"; }
    {
      name = "blog";
      pages = {
        build_type = "workflow";
        source = {
          branch = "main";
          path = "/";
        };
      };
    }
    {
      description = "Dev environments for numerous languages based on Nix flakes [maintainer=@lucperkins]";
      name = "dev-templates";
    }
    {
      description = "A Docker image for a non-censoring, non-logging, DNSSEC-capable, DNSCrypt-enabled DNS resolver";
      homepage_url = "https://dnscrypt.info";
      name = "dnscrypt-server-docker";
    }
    {
      archived = true;
      description = "A repository to manage dotfiles and config";
      name = "dotfiles";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    {
      description = "Tools for people envious of nvidia's blob driver.";
      name = "envytools";
    }
    {
      description = "Build and ship your app faster  https://fireship.io";
      name = "fireship.io";
    }
    {
      description = "Forty theme - Hugo theme ported from HTML5UP origrinal theme called Forty.";
      name = "forty";
    }
    {
      description = "An open source, self-hosted implementation of the Tailscale control server";
      name = "headscale";
    }
    {
      name = "hydra-badge-api";
    }
    {
      archived = true;
      description = "A hobby project for learning Rust a bit better";
      name = "interrogator";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    {
      has_issues = false;
      has_projects = false;
      homepage_url = "https://www.cyber.gov.au/ism/";
      name = "ism-oscal";
      vulnerability_alerts = false;
      web_commit_signoff_required = true;
    }
    {
      archived = true;
      description = "Jellyfin Discord Music Bot is a Discord Bot for the Jellyfin Media Server!";
      name = "jellyfin-discord-music-bot";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    {
      archived = true;
      name = "jim";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    { name = "magic-nix-cache-action"; }
    { name = "microvm.nix"; }
    {
      archived = true;
      description = "A presentation for Newcastle Cybersecurity Group, Feb 2021";
      name = "ncsg-presentation-feb-2021";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    {
      archived = true;
      description = "A presentation for Newcastle Cybersecurity Group, Feb 2022";
      name = "ncsg-presentation-feb-2022";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    {
      archived = true;
      description = "A presentation for Newcastle Cybersecurity Group, June 2023";
      name = "ncsg-presentation-june-2023";
      pages = {
        build_type = "workflow";
        source = {
          branch = "main";
          path = "/";
        };
      };
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    {
      archived = true;
      description = "A presentation for Newcastle Cybersecurity Group, August 2024";
      name = "ncsg-presentation-august-2024";
      pages = {
        build_type = "workflow";
        source = {
          branch = "main";
          path = "/";
        };
      };
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    {
      description = "A presentation for Newcastle Cybersecurity Group, October 2024";
      name = "ncsg-presentation-october-2024";
      pages = {
        build_type = "workflow";
        source = {
          branch = "main";
          path = "/";
        };
      };
    }
    { name = "neovim-flake"; }
    {
      description = "My nix configs";
      name = "nix-config";
    }
    {
      description = "A proof of concept in avoiding follows abuse for a large number of flakes";
      name = "nix-inputs";
    }
    { name = "nix-lib-html-reference"; }
    {
      description = "A simple reference to option attributes available to common nixos modules for both Linux and Darwin ";
      name = "nix-options";
    }
    {
      description = "🍁 Generate infrastructure and network diagrams directly from your NixOS configurations";
      name = "nix-topology";
    }
    { name = "nixos-hardware"; }
    {
      description = "Attempts to get NixOS up on M1 Macs.";
      name = "nixos-m1";
    }
    {
      description = "Opinionated, shared NixOS configurations.";
      name = "nixos-modules";
    }
    {
      description = "NixOS NVIDIA vGPU Module";
      name = "nixos-nvidia-vgpu";
    }
    { name = "nixos-t2-iso"; }
    {
      allow_auto_merge = false;
      description = "Nix Packages collection & NixOS";
      has_downloads = true;
      has_issues = false;
      has_projects = true;
      name = "nixpkgs";
      delete_branch_on_merge = false;
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
      web_commit_signoff_required = false;
    }
    {
      name = "north-south-ride";
      pages = {
        build_type = "workflow";
        source = {
          branch = "main";
          path = "/";
        };
      };
    }
    {
      description = "This patch removes restriction on maximum number of simultaneous NVENC video encoding sessions imposed by Nvidia to consumer-grade GPUs.";
      name = "nvidia-patch";
    }
    {
      description = "A flake for applying strong opinions in an extensible manner across development environments";
      name = "opinionated-development";
    }
    {
      name = "oscalnix";
    }
    {
      archived = true;
      description = "Captive Portal for Pfsense";
      name = "pf-captive-portal";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    { name = "pf-to-nixos"; }
    {
      archived = true;
      description = "A repository to host code related to https://projecteuler.net";
      name = "project-euler";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
    }
    {
      description = "Alias is a teachable “parasite” that is designed to give users more control over their smart assistants, both when it comes to customisation and privacy. Through a simple app the user can train Alias to react on a custom wake-word/sound, and once trained, Alias can take control over your home assistant by activating it for you.";
      name = "project_alias";
    }
    {
      archived = true;
      description = "Simple autoclicker on request for brother's use.";
      name = "pyautoclick";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    {
      archived = true;
      name = "python-oreilly";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    {
      description = "NixOS modules to aid in configuring NixOS for raspberry pi products";
      name = "raspberry-pi-nix";
    }
    { name = "robotnix"; }
    {
      description = "Homepage repo";
      name = "rovacsek";
      pages = {
        build_type = "legacy";
        source = {
          branch = "main";
          path = "/";
        };
      };
    }
    {
      description = "sbomnix is a utility that generates SBOMs from nix packages";
      name = "sbomnix";
    }
    {
      description = "NixOS & darwin SOE Wrapper";
      name = "soe.nix";
    }
    {
      archived = true;
      description = "Temporary application to assist with troubleshooting";
      name = "speedtestcli-periodic";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    {
      description = "Run Stubby without losing the performance benefits of having a local caching DNS resolver.";
      name = "stubby-docker";
    }
    {
      description = "\"Das U-Boot\" Source Tree";
      name = "u-boot";
    }
    {
      name = "uptime";
      pages = {
        build_type = "legacy";
        source = {
          branch = "gh-pages";
          path = "/";
        };
      };
      web_commit_signoff_required = false;
    }
    {
      archived = true;
      description = "Firefox privacy, security and anti-fingerprinting: a comprehensive user.js template for configuration and hardening";
      name = "user.js";
      security_and_analysis = {
        secret_scanning = {
          status = "disabled";
        };
        secret_scanning_push_protection = {
          status = "disabled";
        };
      };
      vulnerability_alerts = false;
    }
    {
      description = "Unlock vGPU functionality for consumer grade GPUs.";
      name = "vgpu_unlock_5.12";
    }
    {
      description = "NixOS module for QEMU VM's using a similar interface to nixos-containers.";
      name = "vms.nix";
    }
    {
      description = "Vulnerability (CVE) scanner for Nix/NixOS.";
      name = "vulnix";
    }
    {
      overrides.name = "slashnew-presentation-may-2025";
      name = "untitled-talk";
      pages = {
        build_type = "workflow";
        source = {
          branch = "main";
          path = "/";
        };
      };
    }
    {
      description = "A simple wrapper for vulnix to check the state of a flake derivation for new or introduced vulnerabilities";
      name = "vulnix-pre-commit";
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
      description = "A dabble in Go, basic tool for testing regression in internal systems.";
      archived = true;
    }
    {
      name = "documentation";
      description = "A repository to hold documentation of various items.";
    }
    {
      name = "FOR508-notes";
      description = "A repository to host notes on my participation in the SANS FOR508 course";
    }
    {
      name = "jsign-docker";
      description = "A PoC to avoid needing to use a Windows system to sign Powershell payloads";
      archived = true;
    }
    {
      name = "maljs";
      description = "A repo to host some deobfustication of code found on a website";
      archived = true;
    }
    {
      name = "ncsg-content";
      description = "A staging repo for ncsg content to be converted to markdown";
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
      description = "This is what happens when people don't follow naming conventions.";
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
    { name = "velo-workshop"; }
  ];
  repositories = public-repositories ++ private-repositories;
}
