{ self, ... }:
{
  # Per-container resource metrics for dragonite's nspawn guests. Cadvisor
  # discovers the container@<name> cgroups (cgroup v1 on this host) and
  # exposes them on 127.0.0.1; the alloy module scrapes and remote-writes
  # them to prometheus (see cadvisor-prom-config there).
  services.cadvisor = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = self.common.config.services.cadvisor.port;
    extraOptions = [
      # Only watch the machine.slice subtree where the containers live,
      # keeping cardinality down instead of tracking every system unit.
      "--raw_cgroup_prefix_whitelist=/machine.slice"
    ];
  };
}
