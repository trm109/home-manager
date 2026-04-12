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
  options = {
    modules.graphical.desktop.compositor = {
      x11.enable = lib.mkEnableOption "Enable X11 session";
      wayland.enable = lib.mkEnableOption "Enable Wayland session";
    };
  };
  config = lib.mkMerge [
    (lib.mkIf (cfg.x11.enable || cfg.wayland.enable) {
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
    (lib.mkIf (cfg.x11.enable) { })
    (lib.mkIf (cfg.wayland.enable) {
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
