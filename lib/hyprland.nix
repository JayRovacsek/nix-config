{ self }:
{
  # Emit Hyprland Lua monitor rules (hl.monitor) from monitor definitions.
  generate-monitors = builtins.map (m: {
    output = m.name;
    mode = m.resolution;
    position = m.position;
    scale = m.scale;
  });
}
