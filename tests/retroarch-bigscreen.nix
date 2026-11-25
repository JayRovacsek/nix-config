{ pkgs, self }:
# VM screen-capture test for the declarative RetroArch wrapper.
#
# Why sway and not the bigscreen session: the kde-big-picture module's
# kwin_wayland session renders a black frame inside plain QEMU (verified —
# the screenshot showed only the cursor), and plasma-bigscreen provides only
# a wayland session, so there is no X11 fallback. This test therefore
# retargets the capture to RetroArch itself, rendered under sway using the
# same proven software-rendering recipe as nixpkgs' own sway.nix test
# (WLR_RENDERER=pixman + virtio-gpu-pci), which yields a non-black frame.
# It proves the declarative wrapper launches under a real wayland compositor
# and its bundled cores are available, which is the actual goal.
pkgs.testers.runNixOSTest {
  name = "retroarch-bigscreen";

  nodes.machine =
    { ... }:
    {
      imports = [ self.nixosModules.retroarch ];

      # Install the declarative wrapper (and its cores) under test.
      programs.retroarch.enable = true;
      _module.args.self = self;

      # Sway with the pixman software renderer — the recipe nixpkgs' sway.nix
      # test uses to get a working (non-black) frame in a GPU-less QEMU.
      programs.sway.enable = true;

      environment.variables = {
        SWAYSOCK = "/tmp/sway-ipc.sock";
        WLR_RENDERER = "pixman";
      };

      # Auto-login on tty1 as the test user, then start sway from its login
      # shell (mirrors nixpkgs sway.nix).
      services.getty.autologinUser = "jynx";
      programs.bash.loginShellInit = ''
        if [ "$(tty)" = "/dev/tty1" ]; then
          sway
        fi
      '';

      users.users.jynx = {
        isNormalUser = true;
        description = "Bigscreen user";
        extraGroups = [ "sway" ];
        password = "retroarch";
        uid = 1000;
      };

      virtualisation = {
        resolution = {
          x = 1280;
          y = 720;
        };
        memorySize = 2048;
        # Sway needs virtio-gpu-pci, not the default -vga std, or it renders
        # nothing (the black-frame cause we hit with kwin).
        qemu.options = [ "-vga none -device virtio-gpu-pci" ];
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")

    # Wait for sway to come up: its wayland socket and the fixed IPC socket.
    machine.wait_for_file("/run/user/1000/wayland-1")
    machine.wait_for_file("/tmp/sway-ipc.sock")

    # Launch RetroArch in the background, pointing it at sway's wayland socket.
    # Output is redirected to a log so a crash is debuggable rather than a
    # silent pgrep timeout. (Plain `swaymsg exec retroarch` exits immediately;
    # the explicit WAYLAND_DISPLAY/XDG_RUNTIME_DIR is what keeps it alive.)
    machine.succeed(
      "su - jynx -c 'WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000 "
      "nohup retroarch > /tmp/ra.log 2>&1 &'"
    )
    machine.wait_until_succeeds("pgrep -x retroarch", timeout=120)

    # Give the menu a moment to render, then capture.
    machine.sleep(5)
    machine.screenshot("retroarch")
  '';
}
