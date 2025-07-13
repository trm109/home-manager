{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.graphical.productivity;
in
{
  options.modules.graphical.productivity = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true; # read from /etc/capabilities.nix
      description = "Enable productivity applications and settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice # Office suite
      darktable # photo editor
      blender-hip # blender w/ hip support
      insomnia # HTTP client for API testing
      krita # Digital painting software
      inkscape # Vector graphics editor
    ];
    programs = {
      obs-studio = {
        enable = true;
        plugins = [ pkgs.obs-studio-plugins.wlrobs ];
      };
    };
  };
}
