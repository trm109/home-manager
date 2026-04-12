{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.graphical.desktop.hyprland.quickshell;
in
{
  options = {
    modules.graphical.desktop.hyprland.quickshell.enable = lib.mkEnableOption "quickshell";
  };

  config = lib.mkIf cfg.enable {
    programs.quickshell = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
    };
  };
}
