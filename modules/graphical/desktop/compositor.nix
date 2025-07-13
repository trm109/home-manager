{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.graphical.desktop.compositor;
in
{
  options.modules.graphical.desktop.compositor = {
    type = lib.mkOption {
      type = lib.types.enum [
        "x11"
        "wayland"
        null
      ];
      default = null;
      description = "Choose the compositor type for the desktop environment.";
    };
  };
  config = lib.mkMerge [
    (lib.mkIf (cfg.type != null) {
      # Default, true for both X11 and Wayland
      home = {
        packages = with pkgs; [
          libnotify
          # if laptop, include brightnessctl
          # Wayland stuff
        ];
        sessionVariables = {
          # Set the default session to Wayland if available, otherwise X11
          #XDG_CONFIG_HOME = "$HOME/.config";
          #XDG_CACHE_HOME = lib.mkForce "$HOME/.cache";
          #XDG_DATA_HOME = "$HOME/.local/share";
          #XDG_STATE_HOME = "$HOME/.local/state";
          #XDG_MUSIC_DIR = "$HOME/Music";
          #XDG_PICTURES_DIR = "$HOME/Pictures";
          #XDG_VIDEOS_DIR = "$HOME/Videos";
          #XDG_DOCUMENTS_DIR = "$HOME/Documents";
          #XDG_DOWNLOAD_DIR = "$HOME/Downloads";
          #XDG_DESKTOP_DIR = "$HOME/Desktop";
        };
      };
      services = {
        kdeconnect.enable = true;
      };
      xdg = {
        enable = true;
      };
    })
    (lib.mkIf (cfg.type == "x11") { })
    (lib.mkIf (cfg.type == "wayland") {
      home = {
        packages = with pkgs; [
          wl-clipboard # Clipboard manager for Wayland
          waypipe # Wayland proxy for X11 applications
          weston # Wayland compositor
        ];
        sessionVariables = {
          # Wayland specific variables
          XDG_SESSION_TYPE = "wayland";
          QT_QPA_PLATFORM = "wayland";
          MOZ_ENABLE_WAYLAND = "1"; # Enable Wayland for Firefox and other Mozilla apps
        };
      };
    })
  ];
}
