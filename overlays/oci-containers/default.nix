self: super: {
  options.virtualisation.oci-containers =
    super.options.virtualisation.oci-containers.override {
      script = builtins.filter (x: (x != "--rm"))
        super.options.virtualisation.oci-containers.script;
    };
}
