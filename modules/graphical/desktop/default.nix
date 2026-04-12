{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.graphical.desktop;
in
{
  imports = [
    ./compositor.nix
    ./hyprland
  ];
}
