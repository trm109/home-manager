{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.graphical;
in
{
  imports = [
    ./desktop
    ./gaming.nix
    ./productivity.nix
  ];
  options.modules.graphical = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true; # read from /etc/capabilties.nix
      description = "Enable graphical applications and settings.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (!cfg.enable) {
      modules.graphical.gaming.enable = lib.mkForce false;
      modules.graphical.productivity.enable = lib.mkForce false;
    })
    (lib.mkIf cfg.enable {

      home.packages = with pkgs; [
        webcord-vencord # Discord client
        stremio # Video player & Torrent
        cheese # Simple webcam viewer
        kdePackages.filelight # Disk Usage analyzer
        bitwarden # Password manager
        xfce.thunar # graphical file manager
        xfce.thunar-archive-plugin # Archive plugin for Thunar
        xfce.thunar-volman # Volume management for Thunar
      ];
      programs = {
        kitty = {
          enable = true; # Terminal emulator
        };
        librewolf = {
          enable = true; # Firefox fork with privacy enhancements
        };
        chromium = {
          enable = true; # Chromium browser
          package = pkgs.ungoogled-chromium; # Use ungoogled-chromium
        };
        mpv = {
          enable = true; # Media player
        };
      };
    })
  ];
}
