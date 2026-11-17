# NixOS Configuration & Administration

Distilled from the `configuration/` and `administration/` chapters of the NixOS
manual. Locate sources via the discovery methods in SKILL.md — never hardcode store
paths. Condensed, not verbatim.

## Configuration syntax & module basics

| Topic | Rule |
|---|---|
| Module shape | `configuration.nix` is `{ config, pkgs, ... }: { ... }` returning option definitions; always keep `...` so unknown args don't break evaluation |
| Dotted names | `services.httpd.enable = true;` ≡ `services = { httpd = { enable = true; }; };`; prefer dotted form, collapse to a nested set only when many options share a prefix |
| Validation | Every option must be declared somewhere; undefined option → "does not exist" error, wrong-typed value → "is not a boolean" etc. |
| Value types | strings (`"..."`, `\` escapes), multi-line `'' ... ''` (strip common indentation, literal `"`/`\` — ideal for shell snippets), booleans, integers, sets, lists (whitespace-separated, no commas), packages via `pkgs.<name>` |
| Dotted literal names | Quote attribute names containing dots that are NOT options: `boot.kernel.sysctl."net.ipv4.tcp_keepalive_time" = 60;` |
| imports | `imports = [ ./vpn.nix ./kde.nix ];`; a module has the same shape as `configuration.nix`; functions returning sets work: `imports = [ (netConfig "host") ];` |
| Merge semantics | List-typed options (`environment.systemPackages`, `boot.kernelModules`) concatenate with `configuration.nix` merged last; `mkBefore [ ... ]` forces a value first; `mkForce` overrides a non-mergeable ("unique") option defined multiple times, else "defined multiple times" error |
| `config` input | The fully merged configuration, available via Nix laziness — branch on `config.services.xserver.enable`; no value may depend on itself |
| Inspection | `nixos-option <opt>` or `nix repl -f '<nixpkgs/nixos>'` then `config.<opt>` |
| DRY tools | `let` bindings, `//` set-merge, functions (e.g. `makeVirtualHost`, `commonConfig` merged per vhost); `let` allowed wherever an expression is allowed, NOT as an attribute name |

## Package management

| Topic | Rule |
|---|---|
| Styles | Declarative (`environment.systemPackages`, applied consistently on every `nixos-rebuild switch`) vs ad hoc (`nix-env`, mixes Nixpkgs versions, only option for non-root users) |
| Declarative | `environment.systemPackages = [ pkgs.thunderbird ];`; check whether a NixOS module exists first (some apps need D-Bus / systemd registration) |
| Attr prefix | Use the `pkgs` variable in declarative config; the `nixos.` prefix (from `nix-env -qaP '*'`) works only in CLI tools |
| Ad hoc commands | `nix-env -iA nixos.thunderbird`, `-e` (uninstall), `-u '*'` (upgrade all), `--rollback`; `nix-channel --update nixos` refreshes the source |
| Profile locations | Root → `/nix/var/nix/profiles/default`; per-user → `/nix/var/nix/profiles/per-user/<user>/profile` |
| Config | `nixpkgs.config` sets Nixpkgs config for the system (e.g. `allowUnfree = true;`) — only for this config, not standalone `nix` commands |
| Overrides | `.override { arg = val; }` changes the package function's arguments; `.overrideAttrs (old: { ... })` changes `mkDerivation` attributes (src, name); wrap in parentheses inside a list (function application binds weaker than list construction); `withExtensions`/`withPackages` add sub-package extensions (pass, python) |
| Global override | `nixpkgs.config.packageOverrides = pkgs: { emacs = ...; };` applies globally so all dependents use it; inside it `pkgs.emacs` still refers to the original (avoids infinite recursion) |
| Custom packages | In-tree (clone nixpkgs, `nixos-rebuild switch -I nixpkgs=/path`) or out-of-tree via inline `stdenv.mkDerivation` or `pkgs.callPackage ./my-hello.nix { }`; test with `nix-build -E 'with import <nixpkgs> { }; callPackage ./my-hello.nix { }'` |
| Prebuilt binaries | Mostly won't run. Exceptions: flatpaks (flatpak module) and AppImages (`programs.appimage.enable`/`.binfmt`, plus `programs.appimage.package = pkgs.appimage-run.override { extraPkgs = ...; }`); other prebuilts need `autoPatchelfHook` / `buildFHSEnv` — a source build is usually easier |

## Profiles

Predefined configs in `<nixpkgs/nixos/modules/profiles>`, added via
`imports = [ <nixpkgs/nixos/modules/profiles/<name>.nix> ];`.

| Profile | Contents |
|---|---|
| minimal | no graphics, single locale, docs disabled |
| base | install-media utilities |
| graphical | Plasma 6 + sddm + libinput |
| all-hardware | all firmware + boot devices in initrd |
| demo | user `demo`/`demo`, wheel, autologin |
| clone-config | editable config importing image modules; `installer.cloneConfig = false` stops copying |
| docker-container | imports minimal + clone-config, sets `boot.isContainer` |
| headless | EC2-style: no serial console, no emergency mode, reboot-on-panic |
| qemu-guest | virtio in initrd |
| installation-device | CD basics |
| perlless | removes perl; build fails on any "perl" store path |

## User management

| Topic | Rule |
|---|---|
| Declarative user | `users.users.alice = { isNormalUser = true; home; description; extraGroups = [ "wheel" "networkmanager" ]; openssh.authorizedKeys.keys = [ ... ]; };`; no password by default (set with `passwd`, retained across rebuilds); `uid`/`gid` auto-assigned unless set |
| Groups | `users.groups.students.gid = 1000;` |
| mutableUsers | `users.mutableUsers = false` makes `/etc/passwd` and `/etc/group` congruent to config (removed users vanish, `useradd` disabled); use `hashedPassword` (generate with `mkpasswd`) |
| Imperative | `useradd -m`, `passwd`, `userdel -r`, `usermod`, `groupadd`; run `su - alice -c "true"` to create `~/.nix-defexpr` so nix tools work |
| Alternatives (experimental) | `systemd.sysusers.enable` (sysusers) and `services.userborn.enable` (preferred; can update passwords, warns on weak hashing); `services.userborn.passwordFilesLocation` relocates password files (useful with tmpfs/immutable `/etc`); Userborn re-mounts password files read-only, so `useradd` fails immediately |
| Screen time | `services.timekpr.enable` |

## Networking

| Topic | Rule |
|---|---|
| Default | DHCP via `dhcpcd`; IPv6 enabled with SLAAC + privacy extensions |
| Static IPv4 | `networking.interfaces.eth0.ipv4.addresses = [ { address; prefixLength; } ];` plus `networking.defaultGateway` and `networking.nameservers`; IPv6: `.ipv6.addresses`, `networking.defaultGateway6 = { address; interface; };` |
| Hostname / IPv6 | `networking.hostName` (default `nixos`; `""` lets DHCP supply it); `networking.enableIPv6 = false` globally, per-interface via sysctl `net.ipv6.conf.eth0.disable_ipv6`; `networking.tempAddresses` / per-interface `.tempAddress` control privacy extensions |
| Interface names | Predictable names on by default; `networking.usePredictableInterfaceNames = false` reverts; custom names by MAC via `systemd.network.links."10-wan"` (matchConfig.PermanentMACAddress + linkConfig.Name, read by udev, works without networkd) or a udev rule under `boot.initrd.services.udev.rules` (NOT `services.udev.extraRules`, to avoid races) |
| NetworkManager | `networking.networkmanager.enable`; users need the `networkmanager` group; control with `nmcli`/`nmtui`; XFCE needs `programs.nm-applet.enable`; coexists with wpa_supplicant via `networking.networkmanager.unmanaged` |
| wpa_supplicant | `networking.wireless.enable`, `.interfaces`, declarative `.networks` (psk / pskRaw 64-hex via `wpa_passphrase` / `auth` free-form for enterprise / `hidden`); secrets via `.secretsFile` + `ext:` syntax; `.userControlled`, `.allowAuxiliaryImperativeNetworks` for `wpa_cli`; hardening on by default, `.enableHardening = false` only if needed |
| Firewall | Enabled by default (IPv4+IPv6, stateful); `networking.firewall.enable = false` to disable; `allowedTCPPorts`, `allowedUDPPorts`, `allowedTCPPortRanges`/`allowedUDPPortRanges` (`{ from; to; }`); port 22 opens automatically when `services.openssh.enable` |
| localCommands | `networking.localCommands` runs shell after interfaces exist — keep idempotent |
| SSH | `services.openssh.enable`; root password login disallowed by default; `services.openssh.settings.PermitRootLogin = "no"` to disable entirely; keys via `users.users.<u>.openssh.authorizedKeys.keys` |
| Container NAT | `networking.nat.enable`, `.internalInterfaces = [ "ve-+" ]`, `.externalInterface` |

## File systems

| Topic | Rule |
|---|---|
| Basic mount | `fileSystems."/data" = { device; fsType; options; };` writes `/etc/fstab` → systemd-fstab-generator `.mount` unit; auto-mounts unless `"noauto"` (then `systemctl start <mp>.mount`); use `/dev/disk/by-label` or `by-uuid` aliases |
| fsType | Usually omittable; specify for non-ext2/3/4 fs needed in initrd; `options = [ "nofail" ]` so a failed mount doesn't drop to emergency shell |
| NFS | `fsType = "nfs"`, device `server:/export`; automount with `options = [ "noauto" "x-systemd.automount" ]`; ad-hoc mount needs `boot.supportedFilesystems = [ "nfs" ]` |
| SSHFS | `fsType = "sshfs"`; non-interactive needs an unencrypted key (root:root, mode 600) via `IdentityFile=`, plus `allow_other`, `_netdev`, `x-systemd.automount`, `reconnect`; debug with `"debug"` and `journalctl -u $(systemd-escape -p <mp>).mount` |
| LUKS | `boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/...";` + `fileSystems."/".device = "/dev/mapper/crypted";`; GRUB on encrypted `/boot` needs `boot.loader.grub.enableCryptodisk = true`; FIDO2 via `crypttabExtraOpts = [ "fido2-device=auto" ]` after `systemd-cryptenroll` |
| Overlayfs | `fileSystems.<mp>.overlay = { lowerdir; upperdir; workdir; };`; writable needs upper+work (auto-created), read-only needs ≥2 lowerdirs; `neededForBoot = true` for initrd |

## Kernel & hardware

| Topic | Rule |
|---|---|
| Kernel | `boot.kernelPackages = pkgs.linuxPackages_latest` (or `pkgs.linuxKernel.packages.linux_X_Y`); swaps kernel-coupled packages (e.g. NVIDIA); non-longterm kernels removed once abandoned — pinning one risks eval failure |
| Modules/sysctl | `boot.kernelModules` (udev usually auto-loads), `boot.initrd.kernelModules` (early boot), `boot.kernel.sysctl` (runtime params; see `sysctl -a`) |
| Custom config | `packageOverrides` + `extraConfig` (no `CONFIG_` prefix); Rust support via `boot.kernelPatches` features.rust for ≥6.7; ZFS: use the LTS kernel nixpkgs ships |
| GPU | Drivers in `hardware.graphics.extraPackages` (links ICDs under `/run/opengl-driver`); `hardware.graphics.enable32Bit` for 32-bit OpenGL; verify with `clinfo`/`vulkaninfo`/`vainfo`; don't mix ICD loaders/runtimes across nixpkgs versions; GPU devices are world-rw or `uaccess`-tagged — only add user to `video` group if logind is disabled |
| X11 | `services.xserver.enable` + desktop/window manager + display manager (default LightDM); `services.xserver.videoDrivers = [ "nvidia" ]` for proprietary NVIDIA (legacy via `hardware.nvidia.package`); `services.libinput.enable` for touchpads; auto-login via `services.displayManager.autoLogin` + `defaultSession`; startx without a DM via `services.xserver.displayManager.startx` |
| Wayland | Install a compositor directly (`programs.sway.enable`); pair with `services.pipewire.enable` for screen sharing |

## Service management (systemd)

| Topic | Rule |
|---|---|
| Basics | systemd is PID 1; `systemctl` (status), `status <unit>`, `start`/`stop`/`restart` (synchronous); `default.target` pulls in everything at boot |
| Bundled units | A package's bundled unit in `environment.systemPackages` is NOT enabled; use `systemd.packages = [ pkgs.pkg ];` for system services, or a community module's `services.<name>.enable` |
| User units | From `systemd.packages`, start only via `systemctl --user start`; to autostart, symlink into `~/.config/systemd/user/default.target.wants/` (or `timers.target.wants/`) pointing at `/run/current-system/sw/lib/systemd/user/...` — do NOT `systemctl --user enable` directly (symlinks a store path that GC breaks) |
| Custom services | `systemd.services.myservice = { after; requires; before; wantedBy; serviceConfig.ExecStart; };`; use `pkgs.writeShellScript` for multi-line ExecStart |
| Template units | Define base `base-unit@` plus each `base-unit@instance` with `overrideStrategy = "asDropin"` and `wantedBy` |
| cgroups | `systemd-cgls`, `systemd-cgtop`; limit via `serviceConfig.CPUShares` (default 1024) and `serviceConfig.MemoryLimit = "512M"` |

## Administration operations

| Topic | Command / rule |
|---|---|
| Rollback | GRUB "NixOS - All configurations" submenu (un-GC'd configs); make chosen default with `/run/current-system/bin/switch-to-configuration boot`; live rollback `nixos-rebuild switch --rollback`; list via `ls -l /nix/var/nix/profiles/system-*-link`; system configs live in profile `/nix/var/nix/profiles/system` |
| Garbage collection | `nix-collect-garbage` (keeps roots/rollback), `-d` deletes old roots (loses rollback); declarative `nix.gc.automatic = true; nix.gc.dates = "03:15";`; `systemctl start nix-gc.service`; per-profile `nix-env -p <profile> --delete-generations old`; `nix-store --optimise` hard-links identical files (~40% savings); after clearing profiles rebuild with `nixos-rebuild boot`/`switch` to free `/boot` |
| Boot problems | Edit GRUB entry (`e`) for kernel params on the `linux` line — `systemd.debug_shell`, `rescue`, `rd.`-prefixed stage-1 variants, `live.nixos.passwd=password` for SSH; Alt+ArrowUp can start `rescue.target`; agetty prompts appear after ~90s unit timeouts |
| Store corruption | `nixos-rebuild switch --repair` (re-checks closure hashes); `nix-store --verify --check-contents --repair` scans whole store; NixOS syncs before switching and its DB is transactional |
| Network problems | If `cache.nixos.org` is unreachable, `--option use-binary-caches false` (or `--option binary-caches <url>`) avoids timeouts |
| Maintenance | `systemctl rescue` (single-user root shell; exit to leave), `shutdown`/`systemctl poweroff`, `reboot`/`systemctl reboot`, `systemctl kexec` (bypass BIOS), `systemctl suspend`/`hibernate` |
| Logging | `journalctl -b` (this boot), `-u <unit>`, `-p crit`; logs in `/var/log/journal/`; readable by root, `wheel`, `systemd-journal` groups |
| User sessions | `loginctl`, `loginctl session-status <id>`, `loginctl terminate-session <id>` |

## Containers

| Topic | Rule |
|---|---|
| Caveat | NixOS containers share the host's Nix store (fast) but are NOT perfectly isolated — don't give container root to untrusted users |
| Declarative | `containers.<name>.config = { ... };` (rebuilt/updated in place on `nixos-rebuild switch`); `autoStart = true`; `privateNetwork` + `hostAddress`/`localAddress` for own namespace; start via `systemctl start container@<name>`; removing from config doesn't delete the root dir — destroy with `nixos-container destroy` |
| Imperative | Needs `boot.enableContainers`, root only: `nixos-container create foo [--config '...']`, `start`/`stop`/`update`/`destroy`, `root-login`/`login`/`run`, `show-ip`; root dir in `/var/lib/nixos-containers/foo`, config in `/etc/nixos-containers/foo.conf`; default IP from `10.233.0.0/16` |

## Necessary system state (impermanent roots)

For tmpfs/reset rootfs, persist:

- All of `/nix` (store + `/nix/var/nix` DB, roots, profiles)
- `/boot` (kernel, initrd, bootloader config + cmdline)
- `/var/lib/nixos` (stable uid/gid)
- `/etc/machine-id`
- `/var/lib/systemd` (random-seed, persistent timers, coredumps, timesync, backlight/rfkill)
- `/var/log/journal/<machine-id>` (or set journald `Storage=volatile`)
- `/etc/zfs/zpool.cache` when using ZFS

With `users.mutableUsers = false`, the passwd/group/shadow/gshadow/subuid/subgid
files need not persist; otherwise they must.

## Guidelines

| Guideline | Rationale |
|---|---|
| Keep `...` in the module argument list; keep `config`/`pkgs` only if used | Module system adds args; unused ones break evaluation |
| Check for a NixOS service module before adding a bare package | D-Bus/systemd registration is missed otherwise |
| Use `pkgs.<name>` in declarative config, never the `nixos.` CLI prefix | Prefix is CLI-only |
| Wrap `.override`/`.overrideAttrs` in parentheses inside a list | Function application binds weaker than list construction |
| Quote sysctl-style attribute names containing dots | Prevents parsing as nested sets |
| Fix unique-option conflicts at the source or use `mkForce`; use `mkBefore`/`mkAfter` for lists | Predictable merge playbook |
| Branch on `config.<opt>` but never let a value depend on itself | Infinite recursion guard |
| Keep `networking.localCommands` idempotent | Runs on every activation |
| Add `nofail` to non-critical mounts; use `by-label`/`by-uuid` device paths | Failed mount shouldn't break boot; device names shift |
| Don't put secrets inline — use `secretsFile`/`ext:` or `/run/secrets` | Inline values land in the store readable by all |
| Warn before `nix-collect-garbage -d` | Destroys rollback ability |
| Treat `users.mutableUsers = false` as a behavioural switch | Removes imperative tools, deletes unmanaged users — confirm intent |
| Never expose container root to untrusted users | Containers aren't isolated |
| Prefer `linuxPackages`/LTS over pinning a non-longterm kernel | Abandoned kernels risk eval failure |
| Verify a change took effect with `nixos-option` / `nix repl` | Don't guess at merged results |
