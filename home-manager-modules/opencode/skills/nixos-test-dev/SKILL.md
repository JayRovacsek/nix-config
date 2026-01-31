# NixOS VM Testing (nixos-test-dev)

This skill provides patterns and best practices for implementing automated integration tests using the NixOS VM testing framework (`pkgs.testers.runNixOSTest`).

## Core Concepts

NixOS tests spin up lightweight QEMU virtual machines to validate system configurations in isolation.

```nix
pkgs.testers.runNixOSTest {
  name = "service-test";
  nodes.machine = { config, pkgs, ... }: {
    # System Configuration
  };
  testScript = ''
    machine.wait_for_unit("service.service")
    machine.succeed("curl localhost")
  '';
}
```

## Patterns

### 1. Minimal Service Test

Avoid importing full host configurations (`hosts/foo/default.nix`) which often contain hardware-specific settings or complex dependencies. Instead, import only the modules necessary for the test.

```nix
imports = [
  self.nixosModules.nginx
  self.nixosModules.authelia
  # ... other generic modules
];
```

### 2. Mocking Secrets

Tests run in a sandbox and cannot access real `agenix` secrets. Mock them by defining the `age` options and creating dummy files.

```nix
options.age.secrets = lib.mkOption { type = lib.types.attrsOf lib.types.anything; default = {}; };

config.age.secrets = {
  "secret-name".path = pkgs.writeText "secret" "dummy-value";
};
```

### 3. Network & DNS Isolation

Tests typically run offline or in a closed network. Map domains to localhost to test ingress flows.

```nix
networking.hosts."127.0.0.1" = [ "service.test.local" ];
services.nginx.virtualHosts."service.test.local" = {
  enableACME = false;
  forceSSL = false; # Or use snakeoil certs
  # ...
};
```

### 4. Python Test Script

Use the Python `testScript` to orchestrate validation.

- `machine.wait_for_unit("nginx.service")`: Block until systemd unit is active.
- `machine.wait_for_open_port(80)`: Block until TCP port is listening.
- `machine.succeed("cmd")`: Run command and fail if exit code != 0.
- `machine.fail("cmd")`: Run command and fail if exit code == 0.

**Example:**

```python
machine.wait_for_unit("nginx.service")
machine.wait_for_open_port(80)
# Use -v to see headers in logs, -L to follow redirects
machine.succeed("curl -v -L http://service.test.local | grep 'Welcome'")
```
