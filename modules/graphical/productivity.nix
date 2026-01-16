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
      #darktable # photo editor TODO enable when build instructions are fixed
      blender # TODO add HIP support when available
      #insomnia # HTTP client for API testing
      krita # Digital painting software
      inkscape # Vector graphics editor
      discord
    ];
    programs = {
      obs-studio = {
        enable = true;
        plugins = [ pkgs.obs-studio-plugins.wlrobs ];
      };
    };
  };
}
